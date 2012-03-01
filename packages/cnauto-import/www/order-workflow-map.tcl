ad_page_contract {

    Maps order_id with all inexistent workflow steps
} {
    {order_id}
    {return_url ""}
}

db_foreach map_order_workflow {
    SELECT workflow_id FROM cn_workflows
} {

    set exists_p [db_0or1row exists_mapping {
	SELECT map_id
	FROM cn_import_workflow_order_map
	WHERE workflow_id = :workflow_id 
	AND order_id = :order_id
    }]

    if {!$exists_p} {

	set map_id [db_nextval acs_object_id_seq]

	db_transaction {
	    db_dml insert_mapping {
		INSERT INTO cn_import_workflow_order_map (
							  map_id,
							  workflow_id,
							  order_id
							  ) VALUES (
								    :map_id,
								    :workflow_id,
								    :order_id
								    )
	    }
	}
    }
}

ad_returnredirect $return_url
ad_script_abort