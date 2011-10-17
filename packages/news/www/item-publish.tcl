ad_page_contract {

    Sets news item revision as live

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-07-20
} {
    {revision_id}
    {return_url ""}
}


content::item::set_live_revision -revision_id $revision_id -publish_status "live"

db_1row select_item_id {
    SELECT item_id FROM cr_revisions WHERE revision_id = :revision_id
}

set replicate_item_p [parameter::get -package_id [ad_conn package_id] -parameter "ReplicateNewsItemP" -default 0]

if {$replicate_item_p} {

    set news_ids [db_list select_news_ids {
	SELECT latest_revision FROM cr_items WHERE item_id IN (SELECT object_id_two FROM acs_rels WHERE object_id_one = :item_id)
    }]
    
    foreach news_id $news_ids {
	content::item::set_live_revision -revision_id $news_id -publish_status "live"
    }
}

ad_returnredirect "item?item_id=$item_id"

