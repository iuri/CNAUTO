ad_page_contract {
    Import XML file for Cotia
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
} {
    {return_url ""}
}

set title "#cnauto-core.Import_file# Cotia"
set context $title


ad_form -html { enctype multipart/form-data } -name import_file -form {
    {input_file:file {label "#cnauto-core.Input_file#"} {html "size 30"}}
} -on_submit {

    
    set mime_type [template::util::file::get_property mime_type $input_file]
    set input_file [list [template::util::file::get_property tmp_filename $input_file]]
    
    ns_log Notice "$mime_type | $input_file"
    if {$mime_type eq "text/xml"} {
	cn_core::import_xml -input_file $input_file 
    } else {
	ad_return_complaint 1 "Error: Wrong file extension! The file you are tryng to upload is not an XML file!"
    }

} -after_submit {
    ad_returnredirect /cnauto-core
    ad_script_abort
}