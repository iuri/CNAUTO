ad_page_contract {
    Import Categories from CSV file 
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-01-12
} {
    {return_url ""}
}

set title "#cnauto-resources.Import_CSV_file#"
set context $title

set category_types [list \
			[list "[_ cnauto-core.Claim]" "cn_claim"] \
			[list "[_ cnauto-core.Part]" "cn_part"] \
			[list "[_ cnauto-core.Resource]" "cn_resource"] \
			[list "[_ cnauto-core.Vehicle]" "cn_vehicle"] \
			[list "[_ cnauto-core.Warranty]" "cn_warranty"] \
		       ]
		    
set parent_options [db_list_of_lists select_parent {
    SELECT pretty_name, category_id FROM cn_categories WHERE parent_id IS NULL
}]

ad_form -html { enctype multipart/form-data } -name import_file -form {
    {input_file:file {label "#cnauto-resources.Input_file#"} {html "size 30"}}
    {type:text(select)
	{label "#cnauto-core.Category_type#"}
	{options $category_types}
    }
    {parent_id:integer(select)
	{label "#cnauto-core.Parent#"}
	{options $parent_options}
    }	
} -on_submit {
    
    set mime_type [list [template::util::file::get_property mime_type $input_file]]
    set tmp_file [list [template::util::file::get_property tmp_filename $input_file]]
    
    ns_log Notice "$input_file | $mime_type"

    if {[string equal $mime_type "application/vnd.ms-excel"] || [string equal $mime_type "text/csv"]} {
	cn_categories::import_csv_file -input_file $tmp_file -type $type
    } else {
	ad_return_complaint 0 "Wrong file extension: <b> [lindex $input_file 0] </b> <br \>  You can upload only CSV files!!"

    }

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}