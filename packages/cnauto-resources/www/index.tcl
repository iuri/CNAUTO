ad_page_contract {
    Resources main page
} {
    {page ""}
    {keyword:optional}
}

auth::require_login

set title "[_ cnauto-resources.Resources]"
set context [list $title]

set return_url [ad_return_url]
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

set actions ""
set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-resources.Delete#" "resource-bulk-delete" "#cnauto-resources.Delete_selected_resources#"}
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}

set where_clause ""
if {[info exists keyword]} {
    set where_clause "WHERE (
      cr.code = :keyword 
      OR cr.name = lower(:keyword) 
      OR cr.pretty_name = :keyword)"
}

template::list::create \
    -name resources \
    -multirow resources \
    -key resource_id \
    -actions $actions \
    -row_pretty_plural "resources" \
    -bulk_actions $bulk_actions \
    -bulk_action_method post \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name resources_pagination \
    -elements {
	code {
	    label "[_ cnauto-resources.Code]"
	    display_template {
		<a href="@resources.resource_url@">@resources.code;noquote@
	    }
	}
	pretty_name {
	    label "[_ cnauto-resources.Name]"
	    display_template {
		<a href="@resources.resource_url@">@resources.pretty_name;noquote@</a>
	    }
	}
	type {
	    label "[_ cnauto-resources.Type]"
	    display_template {
		<a href="@resources.resource_url@">@resources.type;noquote@</a>
	    }
	}
	

    } -orderby {
	type {
	    label "[_ cnauto-resources.Type]"
	    orderby "lower(cr.type)"
	}
    } 


db_multirow -extend {resource_url} resources select_resources {
    
} {

    set resource_url [export_vars -base resource-one {return_url resource_id}]
}

