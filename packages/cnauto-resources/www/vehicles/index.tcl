ad_page_contract {
    Vehicles main page
} {
    {page ""}
}

set title "[_ cnauto-resources.Vehicles]"
set context [list $title]

set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

if {$admin_p} {
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}
set return_url [ad_conn url]

set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}]


set actions ""
set bulk_actions ""


set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]



if {$admin_p} {
    set bulk_actions {"#cnauto-resources.Delete#" "vehicle-bulk-delete" "#cnauto-resources.Delete_selected_vehicles#"}
}

template::list::create \
    -name vehicles \
    -multirow vehicles \
    -key vehicle_id \
    -actions $actions \
    -row_pretty_plural "vehicles" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name vehicles_pagination \
    -elements {
	vin {
	    label "[_ cnauto-resources.Chassis]"
	    display_template {
		<a href="@vehicles.vehicle_url@">@vehicles.vin;noquote@
	    }
	}
	purchase_date {
	    label "[_ cnauto-resources.Engine]"
	    display_template {
		<a href="@vehicles.vehicle_url@">@vehicles.purchase_date;noquote@</a>
	    }
	}
    } -orderby {
	model {
	    label "[_ cnauto-resources.Resource]"
	    orderby "lower(cv.model)"
	}
    } 


db_multirow -extend {vehicle_url} vehicles select_vehicles {} {

    set vehicle_url [export_vars -base vehicle-one {return_url vehicle_id}]
}

