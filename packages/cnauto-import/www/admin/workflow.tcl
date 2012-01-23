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

set return_url [ad_return_url]

set bulk_actions [list]

set actions [list]

template::list::create \
    -name workflow_steps \
    -multirow workflow_steps \
    -key workflow_id \
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
    } -orderby {
	name {
	    label "[_ cnauto-import.Name]"
	    orderby "lower(ciw.name)"
	}
    } 


db_multirow -extend {} workflow_steps select_workflow {
    SELECT ciw.name, ciw.pretty_name FROM cn_import_workflows ciw
} {}

