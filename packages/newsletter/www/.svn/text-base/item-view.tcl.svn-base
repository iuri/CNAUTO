ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} {
	{newsletter_item_id}
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id $newsletter_item_id -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""


set content [db_string select_newsletter {select 
	      content
           from newsletters_items 
	    where newsletter_item_id = :newsletter_item_id
} -default ""]
set title [db_string select_newsletter {select 
	      title
           from newsletters_items 
	    where newsletter_item_id = :newsletter_item_id
} -default ""]
set newsletter_id [db_string select_newsletter {select
              newsletter_id
           from newsletters_items
            where newsletter_item_id = :newsletter_item_id
} -default ""]

set context [list [list "./newsletter?newsletter_id=$newsletter_id" "forum_name"]]

