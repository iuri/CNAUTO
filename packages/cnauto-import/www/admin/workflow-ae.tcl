ad_page_contract {

    Add/Edit workflow
} {
    {workflow_id:integer,optional}
    {return_url ""}
}

if { [exists_and_not_null workflow_id] } {
    set title [_ cnauto-import.Edit_workflow]
    set context [list $title]
    #set ad_form_mode display
} else {
    set title [_ cnauto-import.Add_workflow]
    set context [list $title]
    #set ad_form_mode edit
}


ad_form -name workflow_ae -form {
    {workflow_id:key}
    {pretty_name:text(text)
	{label "[_ cnauto-import.Name]"}
    }
} -on_submit {
} -new_data {
    
    set workflow_id [db_nextval acs_object_id_seq]
    set package_id [ad_conn package_id]
    set name [util_text_to_url -replacement "" -text $pretty_name]

    db_exec_plsql insert_workflow {
	SELECT cn_workflow__new (
				 :workflow_id,
				 :package_id,
				 :name,
				 :pretty_name
				 )
    }

} -edit_data {

    set name [util_text_to_url -replacement "" -text $pretty_name]

    db_exec_plsql edit_workflow {
	SELECT cn_workflow__edit (
				 :workflow_id,
				 :package_id,
				 :name,
				 :pretty_name
				 )
    }









#    cn_import::workflow::step::edit \
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