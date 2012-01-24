ad_library {
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @cretion-date 2012-01-21
    
}


namespace eval cn_import {}
namespace eval cn_import::incoterm {}


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
	

    db_dml insert_workflow {
	INSERT INTO cn_import_workflows (
	    workflow_id,
	    name,
	    pretty_name
        ) VALUES (
		  :workflow_id,
		  :name,
		  :pretty_name
	)
    }

    return $workflow_id
}

namespace eval cn_import::workflow::step {}

ad_proc -public cn_import::workflow::step::new {
    {-name ""}
    {-pretty_name ""}
    {-workflow_id}
} {

    Adds a new step to a workflow
} {

    set step_id [db_nextval acs_object_id_seq]
	

    db_exec_plsql insert_step {
	SELECT cn_workflow_step__new (
				      :step_id,
				      :workflow_id,
				      :name,
				      :pretty_name
				      )
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
	WHERE cp.type_id = cc.category_id AND cc.name = 'fornecedoresdoexterior';
    }]

    lappend providers "{#cn-import.Select_providers#} 0"

    ns_log Notice "$providers"

    return $providers
}