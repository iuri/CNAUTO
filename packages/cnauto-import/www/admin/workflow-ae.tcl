ad_page_contract {

    Add/Edit workflow step
} {
    {workflow_id ""}
    {return_url ""}
}

if { [exists_and_not_null order_id] } {
    set page_title [_ cnauto-import.Edit_step]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-import.Add_step]
    #set ad_form_mode edit
}


ad_form name step_ae -form {
} -on_submit {
} -new_data {
} -edit_data {

    cn_import::workflow::step::edit \
	-step_id $step_id \
	-workflow_id $workflow_id \
	-name $name \
	-pretty_name $pretty_name \
	-assigner_id $assigner_id \
	-assignee_id $assignee_id \
	-department_id $department_id \
	-estimated_days $estimated_days \
	-estimated_date $estimatd_date \
	-executed_date $executed_date \
	-sort_order $sort_order
    
} -after_submit {
    
    ad_returnredirect $return_url
    ad_script_abort
}