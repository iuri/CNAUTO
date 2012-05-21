ad_page_contract {
    Create file for Brasil Assistencia
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
} {
    {return_url ""}
}

set title "#cnauto-core.Export_file# Brasil Assistencia"
set context $title


ad_form -html { enctype multipart/form-data } -name export_file -form {
    {input_file:file {label "#cnauto-core.Input_file#"} {html "size 30"}}
    {output_file:text {label "#cnauto-core.Output_file#"} {html "size 30"}}
} -on_submit {

    set input_file [list [template::util::file::get_property tmp_filename $input_file]]
    cn_core::abeiva::import_csv_file -input_file $input_file -output_file $output_file

} -after_submit {
    ad_returnredirect /cnauto-core
    ad_script_abort
}