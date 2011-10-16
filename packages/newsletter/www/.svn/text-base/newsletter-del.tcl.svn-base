ad_page_contract {
  Delete one newsletter

  @author Alessandro Landim
} {
	newsletter_id
}

permission::require_permission -party_id [ad_conn user_id] -object_id $newsletter_id -privilege admin

ad_form -export {newsletter_id} -name newsletter -form {
	{option:text(radio) {options {{"#newsletter.Yes#" 1} {"#newsletter.No#" 0}}}  {label "#newsletter.Choose_Option_to_delete#"}}
} -on_submit {

	if {$option eq 1} {
		newsletters::delete -newsletter_id $newsletter_id
	}
	
	ad_returnredirect "."

} 




	
