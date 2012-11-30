ad_page_contract {
    Import file from FENABRAVE
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
} {
    {return_url ""}
    {insert_vehicles_p:boolean,optional}
}

set title "#cnauto-core.Export_file# Brasil Assistencia"
set context $title


ad_form -html { enctype multipart/form-data } -name import_file -form {
    {input_file:file {label "#cnauto-core.Input_file#"} {html "size 30"}}
    {insert_vehicles_p:boolean(checkbox),optional 
	{label "#cnauto-core.Insert_vehicles#"} 
	{options {{"" t}}}
    }
} -on_submit {

    set input_file [list [template::util::file::get_property tmp_filename $input_file]]
    
    cn_core::fenabrave::import_csv_file -input_file $input_file -insert_vehicles_p $insert_vehicles_p

} -after_submit {
    ad_returnredirect /cnauto/cnauto-core
    ad_script_abort
}