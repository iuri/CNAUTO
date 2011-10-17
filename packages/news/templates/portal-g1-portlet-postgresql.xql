<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_news_items">
        <querytext>
            select news_items_approved.package_id,
                   acs_object__name(apm_package__parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'DD-MM-YYYY') as publish_date_ansi,
                   item_creator,
                   creation_user,
		   news_items_approved.publish_body
                   $content_column
            from news_items_approved
            where news_items_approved.publish_date < current_timestamp
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
	    	$hide_items_where_clause
            order by package_id,
                     parent_name,
                     news_items_approved.publish_date desc,
                     news_items_approved.publish_title	
	    limit 5	

        </querytext>
    </fullquery>
	

	 <fullquery name="select_max_priority_items">
        <querytext>
            select news_items_approved.package_id,
                   acs_object__name(apm_package__parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi,
                   item_creator,
                   creation_user,
		   news_items_approved.publish_body
                   $content_column
            from news_items_approved
            where news_items_approved.publish_date < current_timestamp
		    and $priority_sql 
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])

            order by package_id,
                     parent_name,
                     news_items_approved.publish_date desc,
                     news_items_approved.publish_title
	    limit 3	

        </querytext>
    </fullquery>
    <fullquery name="max_priority_item">
        <querytext>
 
		      select item_id as max_priority_item_id,
		       package_id,
		       publish_title as max_priority_publish_title,	
		       publish_lead  as max_priority_publish_lead,
		       publish_body  as max_priority_publish_body,
		       to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as max_priority_publish_date_ansi
		       from   news_items_approved
		       where  package_id = :package_id
    	       $hide_items_where_clause
               order  by publish_date desc, item_id desc
	           limit 1
	</querytext>
     </fullquery>

    <fullquery name="select_subgroup_package_ids">
        <querytext>
            select package_id
            from apm_packages p right outer join
                 (select n.object_id,
                  n.parent_id,
                  tree_level(n.tree_sortkey) as mylevel
                  from site_nodes n, site_nodes root
                  where (n.object_id is null
                    or acs_permission__permission_p(n.object_id, :user_id, 'read') = 't')
                  and root.node_id = :root_id
                  and n.tree_sortkey
                    between root.tree_sortkey and tree_right(root.tree_sortkey)) site_map
            on site_map.object_id = p.package_id
            where package_key = 'news'
        </querytext>
    </fullquery>

	 <fullquery name="list_items">
        <querytext>
            select news_items_approved.item_id
            from   news_items_approved
            where news_items_approved.publish_date < current_timestamp
		    and $priority_sql 
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
            order by package_id,
                     parent_name,
                     news_items_approved.publish_date desc,
                     news_items_approved.publish_title
		    limit $limit

        </querytext>
    </fullquery>
 



















</queryset>
