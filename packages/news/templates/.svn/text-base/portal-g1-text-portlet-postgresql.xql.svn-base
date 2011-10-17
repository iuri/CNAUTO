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
                   news_items_approved.priority,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi,
                   item_creator,
                   creation_user,
				   news_items_approved.publish_body
            from news_items_approved
			where news_items_approved.item_id in ([join $list_of_items ", " ])
            order by news_items_approved.publish_date desc
        </querytext>
    </fullquery>
	
	 <fullquery name="list_of_items">
        <querytext>
            select news_items_approved.item_id
            from   news_items_approved
            where news_items_approved.publish_date < current_timestamp
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
			$hide_item
            order by package_id,
                     news_items_approved.publish_date desc
		    limit $limit
        </querytext>
    </fullquery>
 
	 <fullquery name="get_max_priority_item">
        <querytext>
            select news_items_approved.item_id
            from   news_items_approved
            where news_items_approved.publish_date < current_timestamp
		    and priority = 0
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
            order by package_id,
                     news_items_approved.publish_date desc
		    limit 1
        </querytext>
    </fullquery>
 
</queryset>
