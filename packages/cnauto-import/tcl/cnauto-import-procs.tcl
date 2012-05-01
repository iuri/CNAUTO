ad_library {
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @cretion-date 2012-01-21
    
}


namespace eval cn_import {}

##########################
###  Orders
##########################
namespace eval cn_import::order {}

ad_proc -public cn_import::order::new {
    {-cnimp_number:required}
    {-parent_id ""}
    {-provider_id ""}
    {-cnimp_date null}
    {-approval_date null} 
    {-li_need_p ""}
    {-payment_date null}
    {-manufactured_date null}
    {-departure_date null}
    {-arrival_date null}
    {-awb_bl_number ""}
    {-numerary_date null}
    {-di_date null}
    {-di_status ""}
    {-nf_date null}
    {-delivery_date null}
    {-incoterm_id ""}
    {-transport_type ""}
    {-order_cost  ""}
    {-exchange_rate_type  ""} 
    {-lc_number ""}
    {-start_date null} 
    {-notes ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {

    Creates a new order
} {


    if {$cnimp_date ne ""} {
	set cnimp_date "[template::util::date::get_property year $cnimp_date] [template::util::date::get_property month $cnimp_date] [template::util::date::get_property day $cnimp_date]"
    }

    if {$approval_date ne ""} {
	set approval_date "[template::util::date::get_property year $approval_date] [template::util::date::get_property month $approval_date] [template::util::date::get_property day $approval_date]"

    }

    if {$payment_date ne ""} {
	set payment_date "[template::util::date::get_property year $payment_date] [template::util::date::get_property month $payment_date] [template::util::date::get_property day $payment_date]"
    }

    if {$manufactured_date ne ""} {
	set manufactured_date "[template::util::date::get_property year $manufactured_date] [template::util::date::get_property month $manufactured_date] [template::util::date::get_property day $manufactured_date]"
    }

    if {$departure_date ne ""} {
	set departure_date "[template::util::date::get_property year $departure_date] [template::util::date::get_property month $departure_date] [template::util::date::get_property day $departure_date]"
    }

    if {$arrival_date ne ""} {
	set arrival_date "[template::util::date::get_property year $arrival_date] [template::util::date::get_property month $arrival_date] [template::util::date::get_property day $arrival_date]"
    }
    
    if {$numerary_date ne ""} {
	set numerary_date "[template::util::date::get_property year $numerary_date] [template::util::date::get_property month $numerary_date] [template::util::date::get_property day $numerary_date]"
    }
    
    if {$di_date ne ""} {
	set di_date "[template::util::date::get_property year $di_date] [template::util::date::get_property month $di_date] [template::util::date::get_property day $di_date]"
    }

    if {$nf_date ne ""} {
	set nf_date "[template::util::date::get_property year $nf_date] [template::util::date::get_property month $nf_date] [template::util::date::get_property day $nf_date]"
    }

    if {$delivery_date ne ""} {
	set delivery_date "[template::util::date::get_property year $delivery_date] [template::util::date::get_property month $delivery_date] [template::util::date::get_property day $delivery_date]"
    }

    if {$start_date ne ""} {
	set start_date "[template::util::date::get_property year $start_date] [template::util::date::get_property month $start_date] [template::util::date::get_property day $start_date]"
    }   

    db_transaction {
	set order_id [db_exec_plsql insert_order {
	    SELECT cn_import_order__new (
					 :cnimp_number,
					 :parent_id,
					 :provider_id,
					 :cnimp_date,
					 :approval_date, 
					 :li_need_p,
					 :payment_date,
					 :manufactured_date,
					 :departure_date,
					 :arrival_date,
					 :awb_bl_number,
					 :numerary_date,
					 :di_date,
					 :di_status,
					 :nf_date,
					 :delivery_date,
					 :incoterm_id,
					 :transport_type,
					 :order_cost,
					 :exchange_rate_type, 
					 :lc_number,
					 :start_date, 
					 :notes,
					 :creation_ip,
					 :creation_user,
					 :context_id
					 )
	}]
    }
    
    return $order_id
}


ad_proc -public cn_import::order::edit {
    {-order_id:required}
    {-cnimp_number:required}
    {-parent_id ""}
    {-provider_id ""}
    {-cnimp_date null}
    {-approval_date null} 
    {-li_need_p ""}
    {-payment_date null}
    {-manufactured_date null}
    {-departure_date null}
    {-arrival_date null}
    {-awb_bl_number ""}
    {-numerary_date null}
    {-di_date null}
    {-di_status ""}
    {-nf_date null}
    {-delivery_date null}
    {-incoterm_id ""}
    {-transport_type ""}
    {-order_cost  ""}
    {-exchange_rate_type  ""} 
    {-lc_number ""}
    {-start_date null} 
    {-notes ""}
} {

    Amends an order
} {

    if {$cnimp_date ne ""} {
	set cnimp_date "[template::util::date::get_property year $cnimp_date] [template::util::date::get_property month $cnimp_date] [template::util::date::get_property day $cnimp_date]"
    }

    if {$approval_date ne ""} {
	set approval_date "[template::util::date::get_property year $approval_date] [template::util::date::get_property month $approval_date] [template::util::date::get_property day $approval_date]"

    }

    if {$payment_date ne ""} {
	set payment_date "[template::util::date::get_property year $payment_date] [template::util::date::get_property month $payment_date] [template::util::date::get_property day $payment_date]"
    }

    if {$manufactured_date ne ""} {
	set manufactured_date "[template::util::date::get_property year $manufactured_date] [template::util::date::get_property month $manufactured_date] [template::util::date::get_property day $manufactured_date]"
    }

    if {$departure_date ne ""} {
	set departure_date "[template::util::date::get_property year $departure_date] [template::util::date::get_property month $departure_date] [template::util::date::get_property day $departure_date]"
    }

    if {$arrival_date ne ""} {
	set arrival_date "[template::util::date::get_property year $arrival_date] [template::util::date::get_property month $arrival_date] [template::util::date::get_property day $arrival_date]"
    }
    
    if {$numerary_date ne ""} {
	set numerary_date "[template::util::date::get_property year $numerary_date] [template::util::date::get_property month $numerary_date] [template::util::date::get_property day $numerary_date]"
    }
    
    if {$di_date ne ""} {
	set di_date "[template::util::date::get_property year $di_date] [template::util::date::get_property month $di_date] [template::util::date::get_property day $di_date]"
    }

    if {$nf_date ne ""} {
	set nf_date "[template::util::date::get_property year $nf_date] [template::util::date::get_property month $nf_date] [template::util::date::get_property day $nf_date]"
    }

    if {$delivery_date ne ""} {
	set delivery_date "[template::util::date::get_property year $delivery_date] [template::util::date::get_property month $delivery_date] [template::util::date::get_property day $delivery_date]"
    }

    if {$start_date ne ""} {
	set start_date "[template::util::date::get_property year $start_date] [template::util::date::get_property month $start_date] [template::util::date::get_property day $start_date]"
    }


    ns_log Notice "
	-order_id $order_id \n
	-cnimp_number $cnimp_number \n
	-parent_id $parent_id \n
	-provider_id $provider_id \n
	-cnimp_date $cnimp_date \n
	-approval_date $approval_date \n
	-li_need_p $li_need_p \n
	-payment_date $payment_date \n
	-manufactured_date $manufactured_date \n
	-departure_date $departure_date \n
	-arrival_date $arrival_date \n
	-awb_bl_number $awb_bl_number \n
	-numerary_date $numerary_date \n
	-di_date $di_date \n
	-di_status $di_status \n
	-nf_date $nf_date \n
	-delivery_date $delivery_date \n
	-incoterm_id $incoterm_id \n
	-transport_type $transport_type \n
	-order_cost $order_cost \n
	-exchange_rate_type $exchange_rate_type \n
	-lc_number $lc_number \n
	-start_date343 $start_date \n
	-notes $notes "
       

    
    db_transaction {
	db_exec_plsql update_order {
	    SELECT cn_import_order__edit (
					  :order_id,
					  :cnimp_number,
					  :parent_id,
					  :provider_id,
					  :cnimp_date,
					  :approval_date, 
					  :li_need_p,
					  :payment_date,
					  :manufactured_date,
					  :departure_date,
					  :arrival_date,
					  :awb_bl_number,
					  :numerary_date,
					  :di_date,
					  :di_status,
					  :nf_date,
					  :delivery_date,
					  :incoterm_id,
					  :transport_type,
					  :order_cost,
					  :exchange_rate_type, 
					  :lc_number,
					  :start_date, 
					  :notes
					  )
	}
    }
    
    return
}






##########################
###  Incoterms
##########################
namespace eval cn_import::incoterm {}

ad_proc -public cn_import::get_incoterm_options {} {
    Returns a list of incoterms to a ad_form select widget

} {

    return [db_list_of_lists select_incomterms {
	SELECT name, incoterm_id FROM cn_import_incoterms
    }]
}

ad_proc -public cn_import::incoterm::new {
    {-name ""}
    {-pretty_name ""}
} {

    Adds a new incoterm
} {

    set incoterm_id [db_nextval acs_object_id_seq]
	

    db_dml insert_incoterm {
	INSERT INTO cn_import_incoterms (
	    incoterm_id,
	    name,
	    pretty_name
        ) VALUES (
		  :incoterm_id,
		  :name,
		  :pretty_name
	)
    }

    return 
}



##########################
###  Workflow
##########################

namespace eval cn_import::workflow {}

# There is a design error on the workflow structure created. 
# cn_import_workflows are actually the steps of an workflow . Plus each step of the workflow has details / attributes / carachteristics such as estimated_days, estimated_date, executed_date. Those are related with table cn_import_workflow_order_map.
# It would be a properly design if the tables were cn_import_workflows, cn_import_workflow_steps and the relations would be 
# (worflow_id, step_id) and (order_id, workflow_id) that is the best way to link an order with the steps of a workflow 
 
ad_proc -public cn_import::workflow::new {
    {-name ""}
    {-pretty_name ""}
} {

    Adds a new workflow
} {

    set workflow_id [db_nextval acs_object_id_seq]
	

    db_transaction {
	db_dml insert_workflow {
	    INSERT INTO cn_workflows (
				      workflow_id,
				      name,
				      pretty_name
				      ) VALUES (
						:workflow_id,
						:name,
						:pretty_name
						)
	}
    }

    return $workflow_id
}








##########################
###  Workflow Steps
##########################




namespace eval cn_import::workflow::step {}

ad_proc -public cn_import::workflow::step::new {
    {-workflow_id}
    {-pretty_name ""}
} {

    Adds a new step to a workflow
} {

    set step_id [db_nextval acs_object_id_seq]
	
    set name [util_text_to_url -replacement "" -text $pretty_name]

    db_transaction {
	db_exec_plsql insert_step {
	    SELECT cn_workflow_step__new (
					  :step_id,
					  :workflow_id,
					  :name,
					  :pretty_name
					  )
	}
    }
    
    return $step_id
}


ad_proc -public cn_import::workflow::step::edit {
    {-step_id}
    {-workflow_id ""}
    {-name ""}
    {-pretty_name ""}
    {-assigner_id ""}
    {-assignee_id ""}
    {-department_id ""}
    {-estimated_days ""}
    {-estimated_date ""}
    {-executed_date ""}
    {-sort_order ""}
} {

    Adds a new step to a workflow
} {

    set step_id [db_nextval acs_object_id_seq]
	
    db_transaction {
	db_exec_plsql update_step {
	    SELECT cn_workflow_step__edit (
					   :step_id,
					   :workflow_id,
					   :name,
					   :pretty_name,
					   :assigner_id,
					   :assignee_id,
					   :department_id,
					   :estimated_days,
					   :estimated_date,
					   :executed_date,
					   :sort_order
					   )
	
	}
    }

    return
}
























ad_proc -public cn_import::get_provider_options {} {
    Returns a list of providers for a seletc widget
} {
   

    set providers [db_list_of_lists select_providers {
	SELECT cp.pretty_name, cp.person_id 
	FROM cn_persons cp, cn_categories cc 
	WHERE cp.type_id = cc.category_id AND cc.category_type = 'cn_person';
    }]

    lappend providers "{[_ cnauto-import.Select]} 0"

    ns_log Notice "$providers"

    return $providers
}