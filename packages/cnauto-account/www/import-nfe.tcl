ad_page_contract {
    Import NFe XML files
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
} {
    {return_url ""}
}

set title "#cnauto-core.Import_NFe#"
set context $title


ad_form -html { enctype multipart/form-data } -name import_nfe -form {
    {input_file:file {label "#cnauto-account.Input_file#"} {html "size 30"} help_txt "The file must br from XML extension"}
} -on_submit {

    set input_file [list [template::util::file::get_property tmp_filename $input_file]]
    cn_account::import_nfe_xml -input_file $input_file

} -after_submit {
    ad_returnredirect /cnauto/account/
    ad_script_abort
}