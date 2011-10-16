ad_page_contract {
  Create a new user list to send a newsletters

  @author Alessandro Landim

} {
	field_id
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin
set package_id [ad_conn package_id]
set newsletter_id [newsletters::fields::newsletter_id -field_id $field_id]

ad_form -html { enctype multipart/form-data } -export {field_id} -name newsletters -form {
	{name:text {label "#newsletter.name#"}}
	{sort_order:text(text),optional {label "#newsletter.Sort_Order#"}}
	{ignore:text(radio) {options {{#newsletter.Yes# t} {#newsletter.No# f}}}}
} -on_request {
	db_1row select_field {select name, sort_order,ignore from newsletters_fields where field_id = :field_id}

} -on_submit {

	newsletters::fields::edit -field_id $field_id -name $name -sort_order $sort_order -ignore $ignore

} -after_submit {
    ad_returnredirect "newsletter-fields?newsletter_id=$newsletter_id"
    ad_script_abort
}




	
