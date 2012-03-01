ad_page_contract {
    Resources main page
} {
    {page ""}
}

set title "[_ cnauto-resources.Resources]"
set context [list $title]

set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

if {$admin_p} {
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}
set return_url [ad_return_url]


set actions ""

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]


set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-resources.Delete#" "resource-bulk-delete" "#cnauto-resources.Delete_selected_resources#"}
}

template::list::create \
    -name resources \
    -multirow resources \
    -key resource_id \
    -actions $actions \
    -row_pretty_plural "resources" \
    -bulk_actions $bulk_actions \
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
	class {
	    label "[_ cnauto-resources.Class]"
	    display_template {
		<a href="@resources.resource_url@">@resources.class;noquote@</a>
	    }
	}
    } -orderby {
	class {
	    label "[_ cnauto-resources.Class]"
	    orderby "lower(cr.class)"
	}
    } 


db_multirow -extend {resource_url} resources select_resources {
    
} {

    set resource_url [export_vars -base resource-one {return_url resource_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-core.Search]"}
    }    
} 