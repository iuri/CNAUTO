ad_page_contract {

    Map orders 
} {
    {maps:array}
    {workflow_id}
    {return_url ""}
}


set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}

ns_log Notice "[parray maps]"

foreach map [array names maps] {
    set step_id $map
    set order_id $maps($map)
    
    set mapped_p [db_0or1row select_map_id {
	SELECT map_id 
	FROM cn_workflow_step_order_map 
	WHERE step_id = :step_id 
	AND order_id = :order_id
    }]
    set map_id [db_nextval acs_object_id_seq]

    db_transaction { 
	db_exec_plsql insert_map {
	    SELECT cn_wsom__new (
				 :map_id,
				 :workflow_id,
				 :step_id,
				 :order_id,
				 null,
				 null,
				 null,
				 null,
				 null
				 )
	}
    }

}


ad_returnredirect $return_url

