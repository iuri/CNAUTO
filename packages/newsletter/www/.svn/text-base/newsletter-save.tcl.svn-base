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
set news_html_options [news_get_latest_news_html_options -package_id $news_package_id]

set listnames [parameter::get -parameter "listAmsName" -package_id $package_id]
set newsletter_title [parameter::get -parameter "NewsletterTitle" -package_id $package_id]
set email_template ""
set email_templates [parameter::get -parameter "EmailTemplate" -package_id $package_id]
foreach template $email_templates {
	switch [lindex $template 1] {
		"default" {
			set email_template [lindex $template 0]
		}
		default {
		}
	}
}




ad_form -extend -name newsletters -form {
	{title:text(text) {label "#newsletter.Title#"}}
	{body:richtext(richtext) {label "#newsletter.Body#"}}
}

foreach listname $listnames {
	ad_form -extend -name newsletters -form [ams::ad_form::elements -package_key "newsletter" -object_type "newsletter_item" -list_name  $listname]
}


ad_form -extend -name newsletters -on_submit {
          
	set body [template::util::richtext::get_property contents $body]

	set current_news_number [db_string get_newsnumber {select max(item_number) from newsletters_items where newsletter_id = :newsletter_id} -default 1]
	if {$current_news_number == ""} {
		set current_news_number 1
	} else {
		incr current_news_number
	}





	set newsletter_title $title
	set title "$newsletter_title n°$current_news_number - $title"

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

	set t [template::adp_parse "[acs_root_dir]/packages/newsletter/templates/$email_template" [list  item_number $current_news_number package_id $package_id newsletter_id $newsletter_id newsletter_item_id $newsletter_item_id title $newsletter_title body $body]]

	newsletters::items::update_content -newsletter_item_id $newsletter_item_id -content $t

} -after_submit {
    ad_returnredirect "newsletter-items?newsletter_id=$newsletter_id"
    ad_script_abort
}
