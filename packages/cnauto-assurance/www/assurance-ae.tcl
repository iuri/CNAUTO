ad_page_contract {
    
    Add/Edit Assurance Requirement

} {
    {assurance_id:integer,optional}
    {return_url ""}
}


if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
}

set distributor_options [db_list_of_lists select_distributor_info {
    SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
    WHERE cp.type_id = cc.category_id
    AND cc.name = 'concessionarias'
 
}]

set distributor_options_html ""

foreach distributor $distributor_options {
    lappend distributor_options_html "
          <option value='[lindex $distributor 0]'>[lindex $distributor 1]</option>
        "
}

set client_options [db_list_of_lists select_client_info {
    SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
    WHERE cp.type_id = cc.category_id
    AND cc.name = 'clientes'
 
}]


set  client_options_html ""

foreach client $client_options {
    lappend client_options_html "
          <option value='[lindex $client 0]'>[lindex $client 1]</option>
        "
}



set vehicle_options [db_list_of_lists select_vehicle_info {
    SELECT cv.vehicle_id, cv.vin FROM cn_vehicles cv ORDER BY cv.vin
}]

set vehicle_options_html ""
foreach vehicle $vehicle_options {
    lappend vehicle_options_html "
          <option value='[lindex $vehicle 0]'>[lindex $vehicle 1]</option>
        "
}


