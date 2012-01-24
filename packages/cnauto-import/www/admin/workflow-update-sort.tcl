ad_page_contract {
} {
    {steps:array}
    {return_url ""}
}

set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}

ns_log Notice "[parray steps]"
foreach step [array names steps] {
    
    ns_log Notice "Step: $step | Pos: $steps($step)"

    set workflow_id $step
    set sort_order $steps($step)

    db_dml update_sort { 
	UPDATE cn_import_workflows 
	SET sort_order = :sort_order 
	WHERE workflow_id = :workflow_id
    }
}

ad_returnredirect $return_url
