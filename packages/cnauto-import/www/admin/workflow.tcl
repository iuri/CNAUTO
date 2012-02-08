ad_page_contract {
    
    Workflow admin page

} {
    {orderby "pretty_name,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Workflow_steps]"
set context [list $title]

set package_id [ad_conn package_id]
set return_url [ad_conn url]

set workflow_id [db_string select_workflow_id {
    SELECT workflow_id FROM cn_workflows WHERE package_id = :package_id
} -default null]

if {$workflow_id == "null"} {
    ad_returnredirect [export_vars -base workflow-ae {return_url}]
}


set package_id [ad_conn package_id]
set map_orders_url [export_vars -base map-orders {workflow_id return_url}]

set bulk_actions [list]
set actions {}


template::list::create \
    -name workflow_steps \
    -multirow workflow_steps \
    -key step_id \
    -actions $actions \
    -row_pretty_plural "workflow_steps" \
    -bulk_actions $bulk_actions \
    -elements {
	pretty_name {
	    label "[_ cnauto-import.Pretty_name]"
	    display_template {
		@workflow_steps.pretty_name;noquote@
	    }
	}
	sort_order {
	    label "[_ cnauto-import.Sort_order]"
	    display_template {
		<input type="integer" size=2 name="steps.@workflow_steps.step_id@" value="@workflow_steps.sort_order@">
	    }
	}
    } -orderby {
	pretty_name {
	    label "[_ cnauto-import.Name]"
	    orderby "lower(cws.pretty_name)"
	}
    } 



db_multirow -extend {} workflow_steps select_workflow {
    SELECT cws.step_id, cws.pretty_name, cws.sort_order 
    FROM cn_workflow_steps cws
    WHERE cws.workflow_id = :workflow_id
    ORDER BY cws.sort_order
} {}

