ad_page_contract {
    
    Workflow admin page

} {
    {orderby "name,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Workflow]"
set context [list $title]

set return_url [ad_conn url]

set bulk_actions [list]

set actions [list]



template::list::create \
    -name workflow_steps \
    -multirow workflow_steps \
    -key step_id \
    -actions $actions \
    -row_pretty_plural "workflow_steps" \
    -bulk_actions $bulk_actions \
    -elements {
	name {
	    label "[_ cnauto-import.Name]"
	    display_template {
		@workflow_steps.name;noquote@
	    }
	}
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
	name {
	    label "[_ cnauto-import.Name]"
	    orderby "lower(cws.name)"
	}
    } 


db_multirow -extend {} workflow_steps select_workflow {
    SELECT cws.step_id, cws.workflow_id, cws.name, cws.pretty_name, cws.sort_order 
    FROM cn_workflow_steps cws
    ORDER BY cws.sort_order
} {}

