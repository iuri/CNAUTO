ad_page_contract {
    
    Add/Edit Claim Requirement
    
} {
    {claim_id ""}
    {chassis ""}
    {vehicle_id ""}
    {distributor_id ""}
    {owner_id ""}
    {claim_number ""}
    {claim_date:array,optional}
    {service_order ""}
    {km ""}
    {status ""}
    {new.x:optional}
    {edit.x:optional}
    {return_url ""}
    {search ""}
}
	

if { [exists_and_not_null claim_id] } {
    set page_title [_ cnauto-warranty.Edit_claim]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-warranty.Add_claim]
    #set ad_form_mode edit
}


if {[info exists new.x]} { 

    set date "$claim_date(year) $claim_date(month) $claim_date(day)"
    
    set claim_id [cn_claim::new \
			  -claim_number $claim_number \
			  -claim_date $date \
			  -service_order $service_order \
			  -vehicle_id $vehicle_id \
			  -kilometers $km \
			  -status "pending" \
			  -owner_id $owner_id \
			  -distributor_id $distributor_id \
			  -creation_ip  [ad_conn peeraddr] \
			  -creation_user [ad_conn user_id] \
			  -context_id [ad_conn package_id] \
			 ]
    
    ad_returnredirect [export_vars -base "claim-ae-2" {return_url claim_id}]
    
} elseif {[info exists edit.x]} { 

    set date "$claim_date(year) $claim_date(month) $claim_date(day)"


    ns_log Notice "$claim_id \n $date \n $service_order \n $vehicle_id \n $km"
    cn_claim::edit \
	-claim_id $claim_id \
	-claim_date $date \
	-service_order $service_order \
	-vehicle_id $vehicle_id \
	-kilometers $km \
	-owner_id $owner_id \
	-distributor_id $distributor_id
       
    
    ad_returnredirect [export_vars -base "claim-ae-2" {return_url claim_id}]
    
}



if {$chassis != ""} {

    set vehicle_id [db_string select_vehicle_id {
	SELECT vehicle_id FROM cn_vehicles WHERE vin = :chassis
    } -default ""]
}



if {$claim_id != ""} {
    set submit_name "edit"
    set submit_value "#cnauto-warranty.Edit#"

    db_1row select_claim_info {
	SELECT ca.claim_number, ca.service_order, ca.vehicle_id, ca.kilometers AS km
	FROM cn_claims ca
	WHERE claim_id = :claim_id
    }
} else { 

    if {$vehicle_id != ""} {
	set claim_number [cn_claim::generate_claim_number -vehicle_id $vehicle_id] 
	
    }

    set submit_name "new"
    set submit_value "#cnauto-warranty.New#"
}






########
# Begin Formulary
########

if {$search ne ""} {
    set chassis_list [db_list select_chassis "
        SELECT vin FROM cn_vehicles WHERE vin LIKE '%$search%'
    "]


    ns_log Notice "PAGE Autocomplete1 $chassis_list"


    set html "<ul>"

    foreach element $chassis_list {
        append html "<li>$element</li>"
    }


    append html "</ul>"


#    ad_return_template  -string $html
#    doc_return $html

    ns_return 200 "$html" "$html"
}








set resource_select_html [cn_claim::resource_select_widget_html -name "resource_id" -key $vehicle_id] 

set purchase_date [db_string select_purchase_date {
    SELECT cv.purchase_date FROM cn_vehicles cv WHERE vehicle_id = :vehicle_id
} -default ""]

set purchase_date_html [cn_claim::input_date_html -name "purchase_date" -date $purchase_date]


set distributor_select_html [cn_claim::distributor_select_widget_html -name "distributor_id" -key $vehicle_id]


set owner_select_html [cn_claim::owner_select_widget_html -name "owner_id" -key $vehicle_id]


set year [db_string select_year {
    SELECT year_of_fabrication || '/' || year_of_model AS year FROM cn_vehicles WHERE vehicle_id = :vehicle_id
} -default ""]


set code [db_string select_code {
    SELECT cp.code 
    FROM cn_persons cp, cn_vehicles cv 
    WHERE cp.person_id = cv.distributor_id
    AND cv.vehicle_id = :vehicle_id
} -default ""]



set claim_date_html [cn_claim::input_date_html -name "claim_date"]


template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/prototype.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/effects.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/controls.js"


template::head::add_javascript -script {
    
    function FillFieldsOnChange() {
	var chassis = document.getElementById("chassis").value;
	var claimID = document.getElementById("claim_id").value;
	
	// get selected continent from dropdown list
	// var selectedVehicle = vehicleID.options[vehicleID.selectedIndex].value;

	alert (chassis);
	// url of page that will send xml data back to client browser
	var requestUrl;
	// use the following line if using asp
	requestUrl = "claim-ae" + "?chassis=" + encodeURIComponent(chassis) + "&claim_id=" + encodeURIComponent(claimID);

	window.location.href = requestUrl;
    }
}
