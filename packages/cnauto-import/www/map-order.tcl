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
db_multirow -extend {mapped_p} steps select_workflow_steps {
    SELECT cws.step_id, cws.pretty_name AS step  
    FROM cn_workflow_steps cws
    WHERE cws.workflow_id = :workflow_id
    ORDER BY cws.sort_order
} {
    if {[info exists order_id]} {
	
	set mapped_p [db_0or1row select_map_id {
	    SELECT map_id FROM cn_workflow_step_order_map wsom
	    WHERE wsom.step_id = :step_id
	    AND order_id = :order_id
	}]

    	ns_log Notice "MAPPED $mapped_p"

    }
}


# Rows: Gets all the orders
db_multirow -extend {mapped_p} orders select_orders {
    SELECT order_id, code FROM cn_orders co
    
} {
    set step_ids [db_list select_steps {
	SELECT cws.step_id  
	FROM cn_workflow_steps cws
	WHERE cws.workflow_id = :workflow_id
	ORDER BY cws.sort_order
    }]
   
    
}
