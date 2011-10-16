<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="get_news_items">
        <querytext>
            select news_items_approved.package_id,
		   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   news_items_approved.priority,
                   to_char(news_items_approved.publish_date, 'DD/MM/YYYY') as publish_date_ansi,
                   item_creator,
                   creation_user,
		   news_items_approved.publish_body
            from news_items_approved
            where package_id = :news_package_id
	    and    item_id in ([join $news_items ,])
            order by news_items_approved.priority, news_items_approved.publish_date desc
        </querytext>
    </fullquery>
</queryset>
