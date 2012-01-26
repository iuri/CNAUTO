ad_page_contract {
    Import CSV file Assurance Requires
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-01-12
} {
    {return_url ""}
}

set title "#cnauto-resources.Import_CSV_file#"
set context $title


ad_form -html { enctype multipart/form-data } -name import_file -form {
    {input_file:file {label "#cnauto-resources.Input_file#"} {html "size 30"}}
} -on_submit {
    
    set mime_type [list [template::util::file::get_property mime_type $input_file]]
    set tmp_file [list [template::util::file::get_property tmp_filename $input_file]]
    
    ns_log Notice "$input_file | $mime_type"

    if {[string equal $mime_type "application/vnd.ms-excel"] || [string equal $mime_type "text/csv"]} {
	cn_resources::persons::import_csv_file -input_file $tmp_file
    } else {
	ad_return_complaint 0 "Wrong file extension: <b> [lindex $input_file 0] </b> <br \>  You can upload only CSV files!!"

    }

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}