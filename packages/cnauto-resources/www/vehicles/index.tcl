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
set return_url [ad_return_url]

set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}]


set actions ""
set bulk_actions ""

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
	model {
	    label "[_ cnauto-resources.Model]"
	    display_template {
		@vehicles.model;noquote@</a>
	    }
	}
	engine {
	    label "[_ cnauto-resources.Engine]"
	    display_template {
		<a href="@vehicles.vehicle_url@">@vehicles.engine;noquote@</a>
	    }
	}
    } -orderby {
	model {
	    label "[_ cnauto-resources.Model]"
	    orderby "lower(cv.model)"
	}
    } 


db_multirow -extend {vehicle_url} vehicles select_vehicle {
        SELECT cv.vehicle_id, cv.vin, cv.engine, cv.model, cv.year_of_model, cv.year_of_fabrication, cv.color, cv.purchase_date, cv.arrival_date, cv.billing_date, cv.duration, cv.person_id, cv.distributor_code, cv.resource_id 
	FROM cn_vehicles cv 
	WHERE cv.vehicle_id = cv.vehicle_id

    
} {

    set vehicle_url [export_vars -base vehicle-one {return_url vehicle_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-core.Search]"}
    }    
} 