ad_page_contract {
    Parts main page
} {
    {page ""}
}

set title "[_ cnauto-resources.Parts]"
set context [list $title]

set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

if {$admin_p} {
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}
set return_url [ad_conn url]

set part_ae_url [export_vars -base "part-ae" {return_url}]


set actions ""
set bulk_actions ""

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]


set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-resources.Delete#" "part-bulk-delete" "#cnauto-resources.Delete_selected_resources#"}
}

template::list::create \
    -name parts \
    -multirow parts \
    -key part_id \
    -actions $actions \
    -row_pretty_plural "parts" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name parts_pagination \
    -elements {
	code {
	    label "[_ cnauto-resources.Code]"
	    display_template {
		<a href="@parts.part_url@">@parts.code;noquote@
	    }
	}
	pretty_name {
	    label "[_ cnauto-resources.Name]"
	    display_template {
		<a href="@parts.part_url@">@parts.pretty_name;noquote@</a>
	    }
	}
	resource {
	    label "[_ cnauto-resources.Resource]"
	    display_template {
		<a href="@parts.part_url@">@parts.resource;noquote@</a>
	    }
	}
    } -orderby {
	model {
	    label "[_ cnauto-resources.Model]"
	    orderby "lower(cp.pretty_type)"
	}
    } 


db_multirow -extend {part_url} parts select_parts {
    
} {

    set part_url [export_vars -base part-one {return_url part_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-core.Search]"}
    }    
} 