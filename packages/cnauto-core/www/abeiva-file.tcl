ad_page_contract {
    Import file from abeiva spreadsheet
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-03-16
} {
    {return_url ""}
}

set title "#cnauto-core.Import_file# ABEIVA"
set context $title


ad_form -html { enctype multipart/form-data } -name import_file -form {
    {input_file:file {label "#cnauto-core.Input_file#"} {html "size 30"}}
} -on_submit {

    set input_file [list [template::util::file::get_property tmp_filename $input_file]]
    cn_core::import_csv_file_abeiva -input_file $input_file

} -after_submit {
    ad_returnredirect /cnauto-core
    ad_script_abort
}