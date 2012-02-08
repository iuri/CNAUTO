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



# Organize the Map in a matrix

# Columns:  Gets all the workflow steps
db_multirow -extend {}  -upvar_level 2 -unclobber steps select_workflow_steps {
    SELECT cws.step_id, cws.pretty_name AS step  
    FROM cn_workflow_steps cws
    WHERE cws.workflow_id = :workflow_id
    ORDER BY cws.sort_order
} {
    
#    ns_log Notice "MAPPED $mapped_p"
}




# Rows: Gets all the orders
db_multirow -extend {mapped_p step_ids order_url} -upvar_level 2 -unclobber orders select_orders {
    SELECT order_id, code FROM cn_orders co
    
} {
    set order_url [export_vars -base "order-one" {workflow_id order_id return_url}]
    set step_ids [db_list select_steps {
	SELECT cws.step_id  
	FROM cn_workflow_steps cws
	WHERE cws.workflow_id = :workflow_id
	ORDER BY cws.sort_order
    }]
  

 

}
