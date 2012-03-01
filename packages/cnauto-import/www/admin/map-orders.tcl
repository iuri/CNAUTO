ad_page_contract {

    Maps orders to workflow steps
} {
    {workflow_id:integer,notnull}
    {order_id:integer,optional}
    {return_url ""}
    
}


set title "[_ cnauto-orders.Order_info]"
set context [list $title]

set return_url [export_vars -base $return_url {workflow_id order_id}]

# Organize the Map in a matrix

# Columns:  Gets all the workflow steps
db_multirow -extend {} steps select_workflow_steps {
    SELECT cws.step_id, cws.pretty_name AS step  
    FROM cn_workflow_steps cws
    WHERE cws.workflow_id = :workflow_id
    ORDER BY cws.sort_order
} 


set html ""

db_foreach order {
    SELECT order_id, code FROM cn_orders WHERE enabled_p = 't'
} {
    set order_url [export_vars -base "../order-one" {workflow_id order_id return_url}]

    append html "<tr><td><a href=\"$order_url\">$code</a></td>"
    
    set step_ids [db_list select_step_ids {
	SELECT step_id FROM cn_workflow_steps WHERE workflow_id = :workflow_id
    }]

    ns_log Notice "STEPIDS $step_ids"

    foreach step_id $step_ids {
	set mapped_p [db_0or1row select_map_id {
	    SELECT map_id FROM cn_workflow_step_order_map
	    WHERE workflow_id = :workflow_id
	    AND step_id = :step_id
	    AND order_id = :order_id
	}]
	
	switch $mapped_p {
	    0 {
		append html "<td><input type=\"checkbox\" name=\"maps.$order_id.$step_id\" value=\"$order_id\"></td>"
	    }
	    1 {
		append html "<td><input type=\"checkbox\" name=\"maps.$order_id.$step_id\" value=\"$order_id\" checked></td>"
	    }		
	}
    }
    
    append html "<tr>"
}

