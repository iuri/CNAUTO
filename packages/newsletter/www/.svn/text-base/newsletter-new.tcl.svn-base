ad_page_contract {
  Create a new user list to send a newsletters

  @author Alessandro Landim

} {
	newsletter_id:optional
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin
set package_id [ad_conn package_id]


ad_form -html { enctype multipart/form-data } -name newsletters -form {
	{newsletter_id:key}
	{name:text {label "#newsletter.name#"}}
	{description:text(textarea),optional {label "#newsletter.description#"}}
	{base:file {label "#newsletter.File#"}}
}


ad_form -extend -name newsletters -select_query_name get_data_info -on_submit {
	if {[exists_and_not_null base]} {
		set tmp_filename [template::util::file::get_property tmp_filename $base]
	}


} -new_data {
	db_transaction {
		newsletters::new -newsletter_id $newsletter_id -name $name -description $description -tmp_file $tmp_filename 
	}
} -edit_data {
	newsletters::edit -newsletter_id $newsletter_id -name $name -description $description 
	if {[exists_and_not_null base]} {
		newsletters::import_csv -newsletter_id $newsletter_id -tmp_file $tmp_filename -update_p 1 
	}
} -after_submit {
    ad_returnredirect "."
    ad_script_abort
}


	
