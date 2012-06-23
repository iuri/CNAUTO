ad_page_contract {
    NFe Manager list
} {
    {page ""}
    {keyword:optional}
}

auth::require_login

set title "[_ cnauto-account.NFE_manager]"
set context [list $title]

set return_url [ad_return_url]
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

set actions ""
set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-account.Delete#" "nfe-bulk-delete" "#cnauto-account.Delete_selected_nfes#"}
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}

set where_clause ""
if {[info exists keyword]} {
    set where_clause "WHERE (
      cn.nfe_key = :keyword 
      OR cn.nfe_protocol = :keyword)
    "
}

template::list::create \
    -name nfes \
    -multirow nfes \
    -key nfe_id \
    -actions $actions \
    -row_pretty_plural "nfes" \
    -bulk_actions $bulk_actions \
    -bulk_action_method post \
    -elements {
	nfe_key {
	    label "[_ cnauto-account.Key]"
	    display_template {
		<a href="@nfes.nfe_url@">@nfes.nfe_key;noquote@
	    }
	}
	nfe_prot {
	    label "[_ cnauto-account.Protocol]"
	}
	nfe_date {
	    label "[_ cnauto-account.Date]"
	}
	actions {
	    #action buttons: Visualize Download Email
	}
    } -orderby {
	nfe_date {
	    label "[_ cnauto-account.Date]"
	    orderby "lower(cn.date)"
	}
    } 


db_multirow -extend {nfe_url} nfes select_nfes {
    SELECT * FROM cn_nfes
} {

    set nfe_url [export_vars -base "nfe-one" {return_url nfe_id}]
}

