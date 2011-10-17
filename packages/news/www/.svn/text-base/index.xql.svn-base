<?xml version="1.0"?>

<queryset>

<fullquery name="item_list_with_max_priority">      
      <querytext>
   select * from (  
		select item_id,
	       package_id,
	       publish_title,
	       publish_lead,
    	   publish_body,
		   publish_date,
		   0 as priority,
	       to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
		from   news_items_approved 
		where  item_id = :max_priority_item
		UNION ALL
		select item_id,
	       package_id,
	       publish_title,
	       publish_lead,
	       publish_body,
		   publish_date,
           1 as priority,
	       to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
		from   news_items_approved
	        $list_of_items_where_clause
		order by priority, publish_date desc
	) as all_news
        where 't' = acs_permission__permission_p(all_news.item_id, :user_id, 'read')
    </querytext>
</fullquery>

<fullquery name="item_list">      
      <querytext>
		select item_id,
	       package_id,
	       publish_title,
	       publish_lead,
	       publish_body,
		   publish_date,
           1 as priority,
	       to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi
		from   news_items_approved 
	        $list_of_items_where_clause
        	and 't' = acs_permission__permission_p(item_id, :user_id, 'read')
          and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
	      and (news_items_approved.publish_date < current_timestamp)
		  order by publish_date desc
    </querytext>
</fullquery>


<fullquery name="get_max_priority">
      <querytext>
      select item_id as max_priority_item_id
	  from   news_items_approved
	  where  priority = 0
	  and    package_id = :package_id
      and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
	  and news_items_approved.publish_date < current_timestamp
	  order  by publish_date desc
	  limit 1
      </querytext>
</fullquery>

<fullquery name="get_list">
      <querytext>
		select item_id
		from   news_items_approved 
	 	where  $view_clause
		and    package_id = :package_id
		$category_where_clause
        and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
	    and news_items_approved.publish_date < current_timestamp
        and 't' = acs_permission__permission_p(item_id, :user_id, 'read')
		order by publish_date desc
      </querytext>
</fullquery>


<fullquery name="get_list_with_max_priority">
      <querytext>
                select item_id
                from   news_items_approved
                where  $view_clause
                and    package_id = :package_id
		and item_id <> :max_priority_item
            	and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
	    		and news_items_approved.publish_date < current_timestamp
        	and 't' = acs_permission__permission_p(item_id, :user_id, 'read')
                $category_where_clause
                order by publish_date desc
      </querytext>
</fullquery>




</queryset>
