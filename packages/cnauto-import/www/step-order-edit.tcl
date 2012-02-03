ad_page_contract {
    Edits a step of an order
} {
    {map_id}
    {workflow_id ""}
    {step_id ""}
    {order_id ""}
    {return_url ""}
}



set title "#cnauto-import.Edit_step#"
set context [list $title]


set department_options ""
set assignee_options ""

set step_pretty_name [db_string select_pretty_name {
    SELECT cws.pretty_name FROM cn_workflow_steps cws, cn_workflow_step_ordeR_map wsom
    WHERE cws.step_id = wsom.step_id
    AND wsom.map_id = :map_id
}]

ad_form -name step_order_edit -form {
    {map_id:key}
    {workflow_id:integer(hidden)
	{value $workflow_id}
    }
    {step_id:integer(hidden)
	{value $step_id}
    }
    {order_id:integer(hidden)
	{value $order_id}
    }
    {department_id:integer(select)
	{label "[_ cnauto-import.Department]"}
	{options $department_options}
    }
    {assignee_id:integer(select)
	{label "[_ cnauto-import.Assignee]"}
	{options $assignee_options}
    }
    {estimated_date:date
	{label "[_ cnauto-import.Estimated_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('estimated_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} } }
    }
    {executed_date:date
	{label "[_ cnauto-import.Executed_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('executed_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} } }
    }
} -on_submit {
} -edit_request {
    
    db_1row select_step_order_info {
	SELECT wsom.workflow_id, wsom.step_id, wsom.order_id, wsom.department_id, wsom.assignee_id, wsom.estimated_date, wsom.executed_date
	FROM cn_workflow_step_order_map wsom
	WHERE wsom.map_id = :map_id
    }
} -edit_data {
    
    set estimated_date "[template::util::date::get_property year $estimated_date] [template::util::date::get_property month $estimated_date] [template::util::date::get_property day $estimated_date]"

    set executed_date "[template::util::date::get_property year $executed_date] [template::util::date::get_property month $executed_date] [template::util::date::get_property day $executed_date]"



    db_exec_plpsql edit_step_order {
	SELECT sn_wsom__edit (
			      :map_id,
			      :workflow_id,
			      :step_id,
			      :order_id,
			      :assigner_id,
			      :assignee_id,
			      :department_id,
			      :estimated_date,
			      :executed_date
			      )
    }
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}
			      
	
