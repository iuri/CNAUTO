ad_page_contract {
    
    Add/Edit Import Order

} {
    {order_id:integer,optional}
    {return_url ""}
}


if { [exists_and_not_null order_id] } {
    set page_title [_ cnauto-import.Edit_order]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-import.Add_order]
    #set ad_form_mode edit
}


set provider_options [cn_import::get_provider_options]
set incoterm_options [cn_import::get_incoterm_options]

ad_form -name order_ae -form {
    {order_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-import.Order_info]</h2>"}
    }
    {code:text(text)
	{label "[_ cnauto-import.Code]"}
	{html {size 10} maxlength 10}
    }
    {provider_id:integer(select)
	{label "[_ cnauto-import.Provider]"}
	{options $provider_options}
    }
    {incoterm_id:integer(select)
	{label "[_ cnauto-import.Incoterm]"}
	{options $incoterm_options}
    }	
    {incoterm_value:text(text)
	{label "[_ cnaut-import.Incoterm_value]"}
    }
    {estimated_days:integer
	{label "[_ cnaut-import.Estimated_days]"}
	{html {size 5} maxlenght 10}
    }
} -on_submit {

   

} -new_request {
     set provider_id 0
} -new_data {
    
    
    set type_id [cn_categories::get_category_id -name "importorder" -type "cn_order"]

    set order_id [cn_order::new \
		      -code $code \
		      -type_id $type_id \
		      -provider_id $provider_id \
		      -incoterm_id $incoterm_id \
		      -incoterm_value $incoterm_value \
		      -estimated_days $estimated_days \
		      -creation_ip [ad_conn peeraddr] \
		      -creation_user [ad_conn user_id] \
		      -context_id [ad_conn package_id] \
		     ]
    

    set context_id [ad_conn package_id]


    set workflow_id [db_string select_workflow_id {
	SELECT workflow_id FROM cn_workflows WHERE package_id = :context_id
    } -default null]
    
    if {[info exists $order_id] && [info exists $workflow_id]} {

	
	#Maps workflow X order
	set map_id [db_nextval acs_object_id_seq]
	
	db_exec_plsql workflow_order_mapping {
	    SELECT cn_workflow_order_map__new (
					       :map_id,
					       :workflow_id,
					       :order_id
					       )
	}
    
	# Maps Orders X Steps X workflow 
	
	set step_id [db_string select_step_id {
	    SELECT step_id FROM cn_workflow_steps 
	    WHERE name = 'enviodopedido' 
	    AND workflow_id = :workflow_id 
	}]
 
	db_exec_plsql update_step {
	    UPDATE cn_workflow_steps SET 
	    WHERE step_id = :step_id

	}
    }
    
    
} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



