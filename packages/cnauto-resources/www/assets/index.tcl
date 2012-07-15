ad_page_contract {
    Assets main page
} {
    {page ""}
    {keyword:optional}
}

auth::require_login

set title "[_ cnauto-resources.Assets]"
set context [list $title]

set return_url [ad_return_url]
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

set actions ""
set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-resources.Delete#" "asset-bulk-delete" "#cnauto-resources.Delete_selected_assets#"}
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}

set where_clause ""
if {[info exists keyword]} {
    set where_clause "AND (
      ca.asset_code = :keyword 
      OR ca.serial_number = lower(:keyword)
      )"
}

template::list::create \
    -name assets \
    -multirow assets \
    -key asset_id \
    -actions $actions \
    -row_pretty_plural "assets" \
    -bulk_actions $bulk_actions \
    -bulk_action_method post \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name assets_pagination \
    -elements {
	resource {
	    label "[_ cnauto-resources.Resource]"
	    display_template {
		<a href="@assets.resource_url@">@assets.resource;noquote@
	    }
	}
	asset_code {
	    label "[_ cnauto-resources.Code]"
	    display_template {
		<a href="@assets.asset_url@">@assets.asset_code;noquote@
	    }
	}
	serial_number {
	    label "[_ cnauto-resources.Name]"
	    display_template {
		<a href="@assets.asset_url@">@assets.serial_number;noquote@</a>
	    }
	}
	quantity {
	    label "[_ cnauto-resources.Quantity]"
	}
	location {
	    label "[_ cnauto-resources.Location]"
	}
    } -orderby {
	type {
	    label "[_ cnauto-resources.Code]"
	    orderby "lower(ca.type)"
	}
    } 


db_multirow -extend {asset_url resource_url} assets select_assets {
    
} {

    set asset_url [export_vars -base "asset-one" {return_url asset_id}]
    set resource_url [export_vars -base "/cnauto/resource" {return_url}]
}

