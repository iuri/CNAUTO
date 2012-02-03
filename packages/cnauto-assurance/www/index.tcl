ad_page_contract {
    
    Assurance main page

} {
    {orderby "person,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-assurances.Assurances]"
set context [list $title]

set return_url [ad_return_url]
set assurance_ae_url [export_vars -base "assurance-ae" {return_url}] 
set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}] 
set person_ae_url [export_vars -base "person-ae" {return_url}] 



set actions {
    "#cnauto-assurance.Add_assurance#" "assurance-ae?return_url=/cnauto-assurance" "#cnauto-assurance.Add_a_new_assurance#"
    "#cnauto-assurance.Import_CSV_file#" "import-csv-file?return_url=/cnauto-assurance" "#cnauto-assurance.Import_csv_file#"
}

set bulk_actions [list]


set where_clause ""

if {[exists_and_not_null keyword]} {
    set where_clause "AND (cv.vin = :keyword OR ca.assurance_number = :keyword)"
}



template::list::create \
    -name assurances \
    -multirow assurances \
    -key assurance_id \
    -actions $actions \
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
	person {
	    label "[_ cnauto-assurance.Person]"
	    display_template {
		<a href="@assurances.person_url@">@assurances.person_name;noquote@</a>
	    }
	}
    } -orderby {
	person {
	    label "[_ cnauto-assurance.Person]"
	    orderby "lower(cp.pretty_name)"
	}
    } 


db_multirow -extend {assurance_url vehicle_url person_url} assurances select_assurances {
    
} {

    set assurance_url [export_vars -base assurance-one {return_url assurance_id}]
    set vehicle_url [export_vars -base vehicle-one {return_url vehicle_id}]
    set person_url [export_vars -base person-one {return_url person_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-assurance.Search]"}
    }    
} 