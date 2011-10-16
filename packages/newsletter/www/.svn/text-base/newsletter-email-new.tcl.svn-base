ad_page_contract {
  Create a new email in newsletter_id list

  @author Alessandro Landim

} {
	newsletter_id
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read

ad_form -name newsletters -export {newsletter_id} -form {
	{email:email {label "#newsletter.email#"}}
} -on_submit {

		newsletters::email::new -name $email -email $email -newsletter_id $newsletter_id
		set fields [newsletters::fields::get_list -newsletter_id $newsletter_id]
	    foreach field $fields {
			util_unlist $field field_id field_name
			newsletters::data::new -field_id $field_id -data 1 -email $email
		}
	

} -after_submit {
    ad_returnredirect -message "Usuário cadastrado com Sucesso." "newsletter-items?newsletter_id=$newsletter_id"
    ad_script_abort
}




	
