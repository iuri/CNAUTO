ad_page_contract {

    Order's Info page
} {
    {order_id:integer,notnull}
    {workflow_id:integer,notnull}
    {return_url ""}
}

set title "[_ cnauto-orders.Order_info]"
set context [list $title]


set return_url [ad_return_url]
set map_url [export_vars -base order-workflow-map {return_url order_id}]





# Gets all the workflow steps
db_multirow -extend {} steps select_workflow_steps {
    SELECT cws.pretty_name AS step, cws.sort_order, cws.assigner_id, cws.assignee_id,  cws.department_id, cws.estimated_days, cws.estimated_date, cws.executed_date
    FROM cn_workflow_steps cws 
    WHERE cws.workflow_id = :workflow_id
    ORDER BY cws.sort_order
}



# Gets order info
db_1row select_order_info {
    SELECT co.order_id, co.code, cp.pretty_name AS provider, cii.name AS incoterm, co.incoterm_value, o.creation_date
    FROM cn_orders co, cn_persons cp, cn_import_incoterms cii, acs_objects o
    WHERE co.code = co.code
    AND co.provider_id = cp.person_id
    AND co.incoterm_id = cii.incoterm_id
    AND co.order_id = o.object_id
    AND order_id = :order_id
}
