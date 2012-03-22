ad_page_contract {
    
    Add/Edit Assurance Requirement
    
} {
    {assurance_id ""}
    {vehicle_id ""}
    {distributor_id ""}
    {owner_id ""}
    {assurance_number ""}
    {assurance_date:array,optional}
    {service_order ""}
    {km ""}
    {status ""}
    {new.x:optional}
    {edit.x:optional}
    {return_url ""}
}
	

ns_log Notice "VEHI $vehicle_id"
if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
}


if {[info exists new.x]} { 

    set date "$assurance_date(year) $assurance_date(month) $assurance_date(day)"
    
    set assurance_id [cn_assurance::new \
			  -assurance_number $assurance_number \
			  -assurance_date $date \
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
    
    ad_returnredirect [export_vars -base "assurance-ae-2" {return_url assurance_id}]
    
}



if {[info exists edit.x]} { 

    set date "$assurance_date(year) $assurance_date(month) $assurance_date(day)"


    ns_log Notice "$assurance_id \n $date \n $service_order \n $vehicle_id \n $km"
    cn_assurance::edit \
	-assurance_id $assurance_id \
	-assurance_date $date \
	-service_order $service_order \
	-vehicle_id $vehicle_id \
	-kilometers $km \
	-owner_id $owner_id \
	-distributor_id $distributor_id
       
    
    ad_returnredirect [export_vars -base "assurance-ae-2" {return_url assurance_id}]
    
}




if {$assurance_id != ""} {
    set submit_name "edit"
    set submit_value "#cnauto-assurance.Edit#"

    db_1row select_assurance_info {
	SELECT ca.assurance_number, ca.service_order, ca.vehicle_id, ca.kilometers AS km
	FROM cn_assurances ca
	WHERE assurance_id = :assurance_id
    }
} else { 

    if {$vehicle_id != ""} {
	set assurance_number [cn_assurance::generate_assurance_number -vehicle_id $vehicle_id] 
    }

    set submit_name "new"
    set submit_value "#cnauto-assurance.New#"
}


set vehicle_select_html [cn_assurance::vehicle_select_widget_html -name "vehicle_id" -key $vehicle_id]

set model_select_html [cn_assurance::model_select_widget_html -name "model_id" -key $vehicle_id] 

set purchase_date [db_string select_purchase_date {
    SELECT cv.purchase_date FROM cn_vehicles cv WHERE vehicle_id = :vehicle_id
} -default 0]

set purchase_date_html [cn_assurance::input_date_html -name "purchase_date" -date $purchase_date]


set distributor_select_html [cn_assurance::distributor_select_widget_html -name "distributor_id" -key $vehicle_id]


set owner_select_html [cn_assurance::owner_select_widget_html -name "owner_id" -key $vehicle_id]


set year [db_string select_year {
    SELECT year_of_fabrication || '/' || year_of_model AS year FROM cn_vehicles WHERE vehicle_id = :vehicle_id
} -default null]


set code [db_string select_code {
    SELECT cp.code 
    FROM cn_persons cp, cn_vehicles cv 
    WHERE cp.person_id = cv.distributor_id
    AND cv.vehicle_id = :vehicle_id
} -default null]



set assurance_date_html [cn_assurance::input_date_html -name "assurance_date"]



template::head::add_javascript -script {
    
    function FillFieldsOnChange() {
	var vehicleID = document.getElementById("vehicle_id");
	var assuranceID = document.getElementById("assurance_id").value;
	
	// get selected continent from dropdown list
	var selectedVehicle = vehicleID.options[vehicleID.selectedIndex].value;
	
	// url of page that will send xml data back to client browser
	var requestUrl;
	// use the following line if using asp
	requestUrl = "assurance-ae" + "?vehicle_id=" + encodeURIComponent(selectedVehicle) + "&assurance_id=" + encodeURIComponent(assuranceID);

	window.location.href = requestUrl;
    }
}
