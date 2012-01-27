ad_library {
    
    CN Auto Orders Library
}



namespace eval cn_order {}

ad_proc -public cn_order::new {
    {-code}
    {-type_id ""}
    {-provider_id ""}
    {-incoterm_id ""}
    {-incoterm_value ""}
    {-estimated_days ""}
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
	set context_id [ad_conn package_id]
    }
    
    ns_log Notice "$code | $provider_id | $incoterm_id | $incoterm_value | $context_id" 
    
    db_transaction {
	set order_id [db_exec_plsql insert_order {
	    SELECT cn_order__new (
				  :code,
				  :type_id,
				  :provider_id,
				  :incoterm_id,
				  :incoterm_value,
				  :estimated_days,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
	}]
    }
    
    return $order_id
}