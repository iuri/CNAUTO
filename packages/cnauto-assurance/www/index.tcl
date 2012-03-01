ad_page_contract {
    
    Assurance main page

} {
    {orderby "assurance_date,desc"}
    page:optional
    {keyword ""}
    {distributor ""}
    {owner ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-assurance.Assurances]"
set context [list $title]

set return_url [ad_return_url]

set resources_pkg_id [db_string selectpackage_id { SELECT package_id FROM apm_packages WHERE package_key = 'cnauto-resources' }]
set resources_url [site_node::get_url_from_object_id  -object_id $resources_pkg_id]

set actions {
    "#cnauto-assurance.Add_assurance#" "assurance-ae?return_url=/cnauto-assurance" "#cnauto-assurance.Add_a_new_assurance#"
    "#cnauto-assurance.Import_CSV_file#" "import-csv-file?return_url=/cnauto-assurance" "#cnauto-assurance.Import_csv_file#"
}

set bulk_actions [list]


set where_clause ""

if {[exists_and_not_null keyword]} {
    if {[string length $keyword] ne 17} {
	ad_return_complaint 1 "Chassis must a string of 17 characters"
    }

    set where_clause "WHERE cv.vin = :keyword"
}



template::list::create \
    -name assurances \
    -multirow assurances \
    -actions $actions \
    -key assurance_id \
    -row_pretty_plural "assurances" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name assurances_pagination \
    -elements {
	assurance_number {
	    label "[_ cnauto-assurance.Number]"
	    display_template {
		<a href="@assurances.assurance_url@">@assurances.assurance_number;noquote@
	    }
	}
	chassis {
	    label "[_ cnauto-assurance.Chassis]"
	    display_template {
		<a href="@assurances.vehicle_url@">@assurances.chassis;noquote@</a>
	    }
	}
	owner {
	    label "[_ cnauto-assurance.Owner]"
	    display_template {
		<a href="@assurances.owner_url@">@assurances.owner_name;noquote@</a>
	    }
	}
	distributor {
	    label "[_ cnauto-assurance.Distributor]"
	    display_template {
		<a href="@assurances.distributor_url@">@assurances.distributor_name;noquote@</a>
	    }
	}
	total_cost {
	    label "[_ cnauto-assurance.Total]"
	}
	assurance_date {
	    label "[_ cnauto-assurance.Date]"
	}
    } -orderby { 
	owner {
	    label "[_ cnauto-assurance.Owner]"
	    orderby owner_name
	    orderby_asc {owner_name asc}
	    orderby_desc {owner_name desc}
	}
	distributor {
	    label "[_ cnauto-assurance.Distributor]"
	    orderby distributor_name
	    orderby_asc {distributor_name asc}
	    orderby_desc {distributor_name desc}
	}
	total_cost {
	    label "[_ cnauto-assurance.Total]"
	    orderby total_cost
	    orderby_asc {total_cost asc}
	    orderby_desc {total_cost desc}
	}
	assurance_date {
	    label "[_ cnauto-assurance.Date]"
	    orderby assurance_date
	    orderby_asc {assurance_date asc}
	    orderby_desc {assurance_date desc}
	}

    }


db_multirow -extend {assurance_url vehicle_url owner_url distributor_url} assurances select_assurances {
    
} {

    set assurance_url [export_vars -base assurance-one {return_url assurance_id}]
    set vehicle_url [export_vars -base ${resources_url}/vehicles/vehicle-one {return_url vehicle_id}]
    set owner_url [export_vars -base ${resources_url}persons/person-one {return_url {person_id $owner_id}}]
    set distributor_url [export_vars -base ${resources_url}persons/person-one {return_url {person_id $distributor_id}}]
    
    set assurance_date [split [lindex $assurance_date 0] "-"]
    set assurance_date "[lindex $assurance_date 2]/[lindex $assurance_date 1]/[lindex $assurance_date 0]"
    ns_log Notice "$assurance_date "
}

