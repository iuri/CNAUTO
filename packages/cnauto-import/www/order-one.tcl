ad_page_contract {

    Order's Info page
} {
    {order_id:integer,notnull}
    {workflow_id:integer,notnull}
    {return_url ""}
}

set title "[_ cnauto-orders.Order_info]"
set context [list $title]


set return_url [ad_conn url]




# Gets all the workflow steps
db_multirow -extend {} order select_workflow_steps {
    SELECT cws.pretty_name AS step, 
    wsom.department_id, 
    wsom.assignee_id, 
    wsom.estimated_date, 
    wsom.executed_date
    co.code, 
    cp.pretty_name AS provider, 
    cii.name AS incoterm, 
    co.incoterm_value, 
    o.creation_date
    FROM cn_workflow_steps cws, 
    cn_workflow_step_order_map wsom, 
    cn_orders co, 
    cn_persons cp, 
    cn_import_incoterms cii, 
    acs_objects o
    WHERE wsom.workflow_id = :workflow_id
    AND wsom.step_id = cws.step_id
    AND wsom.order_id = co.order_id
    AND wsom.order_id = :order_id
    AND co.provider_id = cp.person_id
    AND co.incoterm_id = cii.incoterm_id
    AND co.order_id = o.object_id
    AND order_id = :order_id

    ORDER BY cws.sort_order
}

