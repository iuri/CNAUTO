ad_page_contract {
    Attaches a file to a bug
} {
    uploadfile:trim,optional
    uploadfile.tmpfile:tmpfile,optional
    {file_id ""}
}


set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}

# User needs to be logged in here
auth::require_login

set tmp_filename ${uploadfile.tmpfile}
set filename [template::util::file::get_property filename $uploadfile] 



if {[catch { cn_core::attach_file \
		 -parent_id [ad_conn package_id] \
		 -tmp_filename $tmp_filename \
		 -filename "${filename}-${file_id}" } errmsg] } {
    ad_return_complaint 1 "[_ cnauto-resources.Delete_part_failed]: $errmsg"
}

