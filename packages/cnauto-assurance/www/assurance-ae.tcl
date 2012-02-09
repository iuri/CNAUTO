ad_page_contract {
    
    Add/Edit Assurance Requirement
    
} {
    {assurance_id:integer,optional}
    {vehicle_id ""}
    {distributor_id ""}
    {assurance_number ""}
    {assurance_date:array,optional}
    {service_order ""}
    {km ""}
    {status ""}
    {submit.x:optional}
    {return_url ""}
}
	


if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
}


if {[info exists submit.x]} { 

    set date "$assurance_date(year) $assurance_date(month) $assurance_date(day)"
    
    set assurance_id [cn_assurance::new \
			  -assurance_number $assurance_number \
			  -assurance_date $date \
			  -service_order $service_order \
			  -vehicle_id $vehicle_id \
			  -kilometers $km \
			  -status "pending" \
			  -creation_ip  [ad_conn peeraddr] \
			  -creation_user [ad_conn user_id] \
			  -context_id [ad_conn package_id] \
			 ]
    
    ad_returnredirect [export_vars -base "assurance-ae-2" {return_url assurance_id}]
    
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



if {$vehicle_id != ""} {
    set assurance_number [cn_assurance::generate_assurance_number -vehicle_id $vehicle_id] 
    
}

set assurance_date_html [cn_assurance::input_date_html -name "assurance_date"]



template::head::add_javascript -script {
    
    function FillFieldsOnChange() {
	var vehicleID = document.getElementById("vehicle_id");
	
	// get selected continent from dropdown list
	var selectedVehicle = vehicleID.options[vehicleID.selectedIndex].value;
	
	// url of page that will send xml data back to client browser
	var requestUrl;
	// use the following line if using asp
	requestUrl = "assurance-ae" + "?vehicle_id=" + encodeURIComponent(selectedVehicle);
	window.location.href = requestUrl;
    }
}
