<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_news_items">
        <querytext>
            select news_items_approved.package_id,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   news_items_approved.priority,
                   to_char(news_items_approved.publish_date, 'DD/MM/YYYY') as publish_date_ansi,
                   item_creator,
                   creation_user,
				   news_items_approved.publish_body
            from news_items_approved
			where package_id = :package_id
            order by news_items_approved.priority, news_items_approved.publish_date desc
			
			limit $limit
        </querytext>
    </fullquery>
</queryset>
