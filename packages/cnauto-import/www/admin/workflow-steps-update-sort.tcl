ad_page_contract {
} {
    {steps:array}
    {return_url ""}
}

foreach step [array names steps] {
    
    set step_id $step
    set sort_order $steps($step)

    db_dml update_sort { 
	UPDATE cn_workflow_steps 
	SET sort_order = :sort_order 
	WHERE step_id = :step_id
    }
}

ad_returnredirect $return_url
