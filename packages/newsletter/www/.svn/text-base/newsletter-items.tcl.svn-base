ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} {
	{newsletter_id}
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id $newsletter_id -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""
set title [db_string get_newsletter_title {select name from newsletters where newsletter_id = :newsletter_id}]

set email_templates [parameter::get -parameter "EmailTemplate" -package_id $package_id]

foreach template $email_templates {
	switch [lindex $template 1] {
		"news" {
			append buttons "<li><a class=\"button\" href=\"newsletter-newsitems-save?newsletter_id=$newsletter_id\" title=\"#newsletter.New_Items_from_news#\" alt=\"#newsletter.New_Items_from_news#\">#newsletter.New_Items_from_news#</a></li>"
		}
		default {
			append buttons "<li><a class=\"button\" href=\"newsletter-save?newsletter_id=$newsletter_id\" title=\"#newsletter.New_Item#\" alt=\"#newsletter.New_Item#\">#newsletter.New_Item#</a></li>"
		}
	}
}


template::head::add_css -href "/resources/newsletter/newsletter.css"


db_multirow -extend {num_email_list} newsletter_list select_newsletter {
       select ni.title,
	      ni.content,
	      newsletter_item_id,
	      newsletter_id,
	      to_char(ao.creation_date, 'DD-MM-YYYY') as publish_date,
		  email_list
           from newsletters_items ni,
		acs_objects ao 
	    where newsletter_id = :newsletter_id
	    and	  ao.object_id = ni.newsletter_item_id 
	    order by item_number desc
} {
	set num_email_list [llength $email_list]

}
