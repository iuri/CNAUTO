ad_page_contract {
    
    Warranties main page / List of claims

} {
    {orderby "claim_date,desc"}
    page:optional
    {keyword ""}
    {distributor ""}
    {owner ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-warranty.Claims]"
set context [list $title]

set return_url [ad_return_url]

set resources_pkg_id [db_string select_package_id { SELECT package_id FROM apm_packages WHERE package_key = 'cnauto-resources' }]
set resources_url [site_node::get_url_from_object_id  -object_id $resources_pkg_id]

set actions {
    "#cnauto-warranty.Add_claim#" "claim-ae?return_url=/cnauto-warranty" "#cnauto-warranty.Add_a_new_claim#"
    "#cnauto-warranty.Import_CSV_file#" "import-csv-file?return_url=/cnauto-warranty" "#cnauto-warranty.Import_csv_file#"
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
    -name claims \
    -multirow claims \
    -actions $actions \
    -key claim_id \
    -row_pretty_plural "claims" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name claims_pagination \
    -elements {
	claim_number {
	    label "[_ cnauto-warranty.Number]"
	    display_template {
		<a href="@claims.claim_url@">@claims.claim_number;noquote@
	    }
	}
	chassis {
	    label "[_ cnauto-warranty.Chassis]"
	    display_template {
		<a href="@claims.vehicle_url@">@claims.chassis;noquote@</a>
	    }
	}
	owner {
	    label "[_ cnauto-warranty.Owner]"
	    display_template {
		<a href="@claims.owner_url@">@claims.owner_name;noquote@</a>
	    }
	}
	distributor {
	    label "[_ cnauto-warranty.Distributor]"
	    display_template {
		<a href="@claims.distributor_url@">@claims.distributor_name;noquote@</a>
	    }
	}
	total_cost {
	    label "[_ cnauto-warranty.Total]"
	}
	claim_date {
	    label "[_ cnauto-warranty.Date]"
	}
    } -orderby { 
	owner {
	    label "[_ cnauto-warranty.Owner]"
	    orderby owner_name
	    orderby_asc {owner_name asc}
	    orderby_desc {owner_name desc}
	}
	distributor {
	    label "[_ cnauto-warranty.Distributor]"
	    orderby distributor_name
	    orderby_asc {distributor_name asc}
	    orderby_desc {distributor_name desc}
	}
	total_cost {
	    label "[_ cnauto-warranty.Total]"
	    orderby total_cost
	    orderby_asc {total_cost asc}
	    orderby_desc {total_cost desc}
	}
	claim_date {
	    label "[_ cnauto-warranty.Date]"
	    orderby claim_date
	    orderby_asc {claim_date asc}
	    orderby_desc {claim_date desc}
	}

    }


db_multirow -extend {claim_url vehicle_url owner_url distributor_url} claims select_claims {
    
} {

    set claim_url [export_vars -base claim-one {return_url claim_id}]
    set vehicle_url [export_vars -base ${resources_url}/vehicles/vehicle-one {return_url vehicle_id}]
    set owner_url [export_vars -base ${resources_url}persons/person-one {return_url {person_id $owner_id}}]
    set distributor_url [export_vars -base ${resources_url}persons/person-one {return_url {person_id $distributor_id}}]
    
    set claim_date [split [lindex $claim_date 0] "-"]
    set claim_date "[lindex $claim_date 2]/[lindex $claim_date 1]/[lindex $claim_date 0]"
    ns_log Notice "$claim_date "
}

