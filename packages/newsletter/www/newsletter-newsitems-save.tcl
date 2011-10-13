ad_page_contract {
  See newsletter list

  @author Alessandro Landim

} {
	{newsletter_id}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set site_url [ad_url]
set package_url [apm_package_url_from_id $package_id]



permission::require_permission -party_id $user_id -object_id $package_id -privilege admin

	
ad_form -name newsletters -export {newsletter_id} 

array set package_info [lindex [site_node::get_all_from_object_id -object_id $package_id] 0]
array set parent_info [site_node::get -node_id $package_info(parent_id)]
set news_package_id [lindex [site_node_apm_integration::get_child_package_id  -package_id $parent_info(package_id) -package_key news] 0]
#set news_html_options [news_get_latest_news_html_options -package_id $news_package_id]

set listnames [parameter::get -parameter "listAmsName" -package_id $package_id]
set newsletter_title [parameter::get -parameter "NewsletterTitle" -package_id $package_id]

set email_template ""
set email_templates [parameter::get -parameter "EmailTemplate" -package_id $package_id]
foreach template $email_templates {
	switch [lindex $template 1] {
		"news" {
			set email_template [lindex $template 0]
		}
		default {
		}
	}
}




db_multirow get_items get_news_items {
            select	news_items_approved.publish_title as title,
					to_char(publish_date, 'DD-MM-YYYY') as date,
            		news_items_approved.item_id
            from 	news_items_approved
            where 	package_id = :news_package_id
            order by 	news_items_approved.publish_date desc
            limit 38
} {
	set category_id [category::get_mapped_categories $item_id]
	set category_name ""
	if {[exists_and_not_null category_id]} {
		set category_name "[category::get_name  $category_id] -"
	}
	set title [util_close_html_tags $title "25" "25" "..." ""]
	lappend news_html_options [list "$category_name $date - $title"  $item_id]
}


ad_form -extend -name newsletters -form {
	{news_items:integer(checkbox),multiple {label "#newsletter.News_items#"} {options $news_html_options}}
}

foreach listname $listnames {
	ad_form -extend -name newsletters -form [ams::ad_form::elements -package_key "newsletter" -object_type "newsletter_item" -list_name  $listname]
}


ad_form -extend -name newsletters -on_submit {

	set current_news_number [db_string get_newsnumber {select max(item_number) from newsletters_items where newsletter_id = :newsletter_id} -default 1]
	if {$current_news_number == ""} {
		set current_news_number 1
	} else {
		incr current_news_number
	}





	set news_item [lindex $news_items 0]
	set newsletter_name [db_string get {select publish_title from news_items_live_or_submitted where item_id = :news_item}]

	set title "$newsletter_title n°$current_news_number - $newsletter_name"

	## TODO: add it in a parameter



	##Save
	set email_list ""	
	set newsletter_item_id [newsletters::items::save -content "" -title $title -item_number $current_news_number -newsletter_id $newsletter_id -email_list $email_list]

	foreach listname $listnames {
		 ams::ad_form::save \
        	    -package_key "newsletter" \
	            -object_type "newsletter_item" \
        	    -list_name $listname \
	            -form_name "newsletters" \
	            -object_id $newsletter_item_id

	}

	set t [template::adp_parse "[acs_root_dir]/packages/newsletter/templates/$email_template" [list  news_items $news_items item_number $current_news_number news_package_id $news_package_id package_id $package_id newsletter_id $newsletter_id newsletter_item_id $newsletter_item_id]]

	newsletters::items::update_content -newsletter_item_id $newsletter_item_id -content $t

} -after_submit {
    ad_returnredirect "newsletter-items?newsletter_id=$newsletter_id"
    ad_script_abort
}
