ad_page_contract {
  See newsletter list

  @author Alessandro Landim

} {
	{newsletter_id}
	{newsletter_item_id}
} -properties {
    context:onevalue
    title:onevalue
}


set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set site_url [ad_url]
set package_url [apm_package_url_from_id $package_id]

set context [list]
set page_title [db_string get_title {select title from newsletters_items where newsletter_item_id = :newsletter_item_id} -default ""] 


permission::require_permission -party_id $user_id -object_id $package_id -privilege admin

	
ad_form -name newsletters -export {newsletter_id newsletter_item_id} 

array set package_info [lindex [site_node::get_all_from_object_id -object_id $package_id] 0]
array set parent_info [site_node::get -node_id $package_info(parent_id)]
set news_package_id [lindex [site_node_apm_integration::get_child_package_id  -package_id $parent_info(package_id) -package_key news] 0]
set news_html_options [news_get_latest_news_html_options -package_id $news_package_id]

set listnames [parameter::get -parameter "listAmsName" -package_id $package_id]
set email_template [parameter::get -parameter "EmailTemplate" -package_id $package_id]
set newsletter_title [parameter::get -parameter "NewsletterTitle" -package_id $package_id]
set from_address [parameter::get -parameter "FromAddress" -package_id $package_id]




set fields_list [newsletters::fields::get_list -newsletter_id $newsletter_id]
foreach field $fields_list {
	set options_html_list ""
	util_unlist $field field_id field_name
	set options [newsletters::fields::get_values -field_id $field_id]
	lappend options_html_list [list "Todos" "_all"]
	foreach option $options {
		if {$option != 1 && $option != ""} {
			lappend options_html_list [list $option $option]
		}
	}

	set field_option "option_${field_id}"
	ad_form -extend -name newsletters -form {
		{$field_option:text(checkbox),multiple,optional {label $field_name} {options $options_html_list}}
	}

}

ad_form -extend -name newsletters -confirm_template confirm-button -on_submit {
    set current_news_number [db_string get_newsnumber {select item_number from newsletters_items where newsletter_item_id = :newsletter_item_id} -default 1]
    set title [db_string get_newsnumber {select title from newsletters_items where newsletter_item_id = :newsletter_item_id} -default 1]
    
    
    foreach field $fields_list {
	util_unlist $field field_id field_name
	set var_name "option_${field_id}"
		if {[value_if_exists $var_name] != ""} {
			lappend fields_data_list [list $field_id [value_if_exists $var_name]]
		}
    }
    ns_log notice "################################################# \n fields_data_list $fields_data_list"
    
    
    set from_addr $from_address
    set email_list [newsletters::email::get_filtred -fields_data_list $fields_data_list -newsletter_id $newsletter_id]
    
    #send
    set content [db_string get_content {select content from newsletters_items where newsletter_item_id = :newsletter_item_id}] 
    db_dml update_email_list {update newsletters_items set email_list = :email_list where newsletter_item_id = :newsletter_item_id}
    
    foreach email $email_list {
	set extra_headers [ns_set create]
	set message_text ""
	set message_data [build_mime_message $message_text $content utf-8]
	ns_set put $extra_headers Content-Type [ns_set get $message_data Content-Type]
	set message [ns_set get $message_data body]
	
	acs_mail_lite::send -to_addr $email \
	    -from_addr $from_addr \
	    -subject $title \
	    -body $message \
	    -extraheaders $extra_headers
    }
    
    
} -after_submit {
    ad_returnredirect "."
    ad_script_abort
}
