ad_page_contract {
    
    Assurance main page

} {
    {orderby "person,asc"}
    page:optional
}


set return_url [ad_return_url]
set assurance_ae_url [export_vars -base "assurance-ae" {return_url}] 
set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}] 
set person_ae_url [export_vars -base "person-ae" {return_url}] 



set actions {
    "#cnauto-assurance.Add_assurance#" "assurance-ae?return_url=/cnauto-assurance" "#cnauto-assurance.Add_a_new_assurance#"
    "#cnauto-assurance.Add_vehicle#" "vehicle-ae?return_url=/cnauto-assurance" "#cnauto-assurance.Add_a_new_vehicle#"
    "#cnauto-assurance.Add_person#" "person-ae?return_url=/cnauto-assurance" "#cnauto-assurance.Add_a_new_person#"

}

set bulk_actions [list]




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
		<a href="assurances.person_url">@assurances.person_name;noquote@</a>
	    }
	}
    } -orderby {
	person {
	    label "[_ cnauto-assurance.Person]"
	    orderby "lower(cp.first_names || ' ' || cp.last_name)"
	}
    } 


db_multirow -extend {assurance_url vehicle_url person_url} assurances select_assurances {
    
} {

    set assurance_url [export_vars -base assurance-one {assurance_id}]
    set vehicle_url [export_vars -base vehicle-one {vehicle_id}]
    set person_url [export_vars -base person-one {person_id}]
}