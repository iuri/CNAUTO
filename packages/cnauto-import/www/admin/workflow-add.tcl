ad_page_contract {

    Add a new workflow step
} {
    {name ""}
    {pretty_name ""}
    {return_url ""}
}

set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}

cn_import::workflow::new \
    -name $name \
    -pretty_name $pretty_name 




ad_returnredirect $return_url
ad_script_abort