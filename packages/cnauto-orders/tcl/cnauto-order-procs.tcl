ad_library {
    
    CN Auto Orders Library
}



namespace eval cn_order {}

ad_proc -public cn_order::new {
    {-code}
    {-provider_id ""}
    {-incoterm_id ""}
    {-incoterm_value ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }

    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }

    if {$context_id == ""} {
	set context_id [ad_conn context_id]
    }

    db_transaction {
	set order_id [db_exec_plsql insert_order {
	    SELECT cn_order__new (
				  :code,
				  :provider_id,
				  :incoterm_id,
				  :incoterm_value,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
	}]
	

	db_foreach map_order_workflow {
	    SELECT workflow_id FROM cn_import_workflows
	} {
	    
	    set map_id [db_nextval acs_object_id_seq]
	    
	    db_dml order_workflow_mapping {
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
    
    return $order_id
}