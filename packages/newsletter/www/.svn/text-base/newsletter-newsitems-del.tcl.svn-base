ad_page_contract {
  Delete one newsletter

  @author Alessandro Landim
} {
	newsletter_item_id
	newsletter_id
}

permission::require_permission -party_id [ad_conn user_id] -object_id $newsletter_id -privilege admin

ad_form -export {newsletter_item_id newsletter_id} -name newsletter -form {
	{option:text(radio) {options {{"#newsletter.Yes#" 1} {"#newsletter.No#" 0}}}  {label "#newsletter.Choose_Option_to_delete#"}}
} -on_submit {

	if {$option eq 1} {
		 newsletters::items::delete -item_id $newsletter_item_id
	}
	
	ad_returnredirect "newsletter-items?newsletter_id=$newsletter_id"

} 




	
