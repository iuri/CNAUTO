ad_page_contract {

    Order's Info page
} {
    {order_id:integer,notnull}
    {workflow_id:integer,optional}
    {return_url ""}
}

set title "[_ cnauto-orders.Order_info]"
set context [list $title]


set return_url [ad_conn url]
set map_order_url [export_vars -base "admin/map-orders" {return_url workflow_id order_id}]

if {![info exists workflow_id]} {
    set workflow_id [db_string select_workflow_id {
	SELECT workflow_id FROM cn_workflows WHERE order_id = :order_id
    } -default null]
}


db_multirow -extend {step_order_url} steps select_steps {
    SELECT cws.step_id, cws.pretty_name 
    FROM cn_workflow_steps cws, cn_workflow_step_order_map wsom 
    WHERE cws.step_id = wsom.step_id
    AND wsom.order_id = :order_id
    ORDER BY cws.sort_order
} {

    set map_id [db_string select_map_id {
	SELECT wsom.map_id 
	FROM cn_workflow_step_order_map wsom 
	WHERE wsom.workflow_id = :workflow_id
	AND wsom.step_id = :step_id
	AND wsom.order_id = :order_id
    } -default null]

    set step_order_url [export_vars -base "step-order-edit" {return_url map_id}]
} 

db_1row select_order_info {
    SELECT co.code, 
    cp.pretty_name AS provider, 
    cii.name AS incoterm, 
    co.incoterm_value, 
    o.creation_date
    FROM
    cn_orders co, 
    cn_persons cp, 
    cn_import_incoterms cii, 
    acs_objects o
    WHERE 
    co.provider_id = cp.person_id
    AND co.incoterm_id = cii.incoterm_id
    AND co.order_id = o.object_id
    AND order_id = :order_id

}

db_multirow -extend {} columns select_columns {
    SELECT wsom.department_id, wsom.assignee_id, wsom.estimated_date, wsom.executed_date, cws.sort_order
    FROM cn_workflow_step_order_map wsom, cn_workflow_steps cws
    WHERE wsom.workflow_id = :workflow_id
    AND wsom.step_id = cws.step_id
    AND wsom.order_id = :order_id
    ORDER BY cws.sort_order
}