ad_page_contract {
    
    Add/Edit Assurance Requirement
    
} {
    {assurance_id:integer,optional}
    {distributor_id ""}
    {code ""}
    {client_id ""}
    {chassis ""}
    {vehicle ""}
    {model ""}
    {year ""}
    {return_url ""}
}

#template::head::add_javascript -src "/resources/cnauto-assurance/js/form-ajax.js"


if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
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

set owner_options [db_list_of_lists select_owner_info {
    SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
    WHERE cp.type_id = cc.category_id
    AND cc.name = 'clientes'
    
}]


set  owner_options_html ""

foreach owner $owner_options {
    lappend owner_options_html "
          <option value='[lindex $owner 0]'>[lindex $owner 1]</option>
        "
}



