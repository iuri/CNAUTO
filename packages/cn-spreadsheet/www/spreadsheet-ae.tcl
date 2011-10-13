ad_page_contract {
    Create a new spreadsheet

    @author Iuri Sampaio
    @creation-date 2011-09-18

} {
    spreadsheet_id:optional
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin
set package_id [ad_conn package_id]


ad_form -html { enctype multipart/form-data } -name spreadsheet -form {
	{spreadsheet_id:key}
	{name:text {label "#cn-spreadsheet.name#"}}
	{description:text(textarea),optional {label "#cn-spreadsheet.description#"}}
	{base:file {label "#cn-spreadsheet.File#"}}
}


ad_form -extend -name spreadsheet -select_query_name get_data_info -on_submit {
	if {[exists_and_not_null base]} {
		set tmp_filename [template::util::file::get_property tmp_filename $base]
	}


} -new_data {
	db_transaction {
		cn_spreadsheet::new -spreadsheet_id $spreadsheet_id -name $name -description $description -tmp_file $tmp_filename 
	}
} -edit_data {
	cn_spreadsheet::edit -spreadsheet_id $spreadsheet_id -name $name -description $description 
	if {[exists_and_not_null base]} {
		cn_spreadsheet::import_csv -spreadsheet_id $spreadsheet_id -tmp_file $tmp_filename -update_p 1 
	}
} -after_submit {
    ad_returnredirect "."
    ad_script_abort
}


	
