ad_page_contract {
    
    Add/Edit Assurance Requirement
    
} {
    {assurance_id:integer,optional}
    {vehicle_id ""}
    {assurance_number ""}
    {return_url ""}
}



template::head::add_javascript -src "/resources/cnauto-assurance/js/form-ajax.js"


if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
}


set vehicle_select_html [cn_assurance::vehicle_select_widget_html -name "vehicle_id" -key $vehicle_id]

set model_select_html [cn_assurance::model_select_widget_html -name "model_id" -key $vehicle_id] 

set purchase_date [db_string select_purchase_date {
    SELECT cv.purchase_date FROM cn_vehicles cv WHERE vehicle_id = :vehicle_id
} -default null]

set purchase_date_html [cn_assurance::input_date_html -name "purchase_date" -date $purchase_date]


ns_log Notice "VEHICLE $vehicle_id"
if {$vehicle_id != ""} {
    set assurance_number [cn_assurance::generate_assurance_number -vehicle_id $vehicle_id]

    ns_log Notice "ASSURANCE $assurance_number"
}


set assurance_date_html [cn_assurance::input_date_html -name "assurance_date"]



set distributor_select_html [cn_assurance::distributor_select_widget_html -name "distributor_id" -key $vehicle_id]


set owner_select_html [cn_assurance::owner_select_widget_html -name "owner_id" -key $vehicle_id]

