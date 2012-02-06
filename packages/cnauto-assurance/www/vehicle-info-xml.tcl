ad_page_contract {
} {
    {vehicle_id "" }
}
# ---------------------------------------------------------------
# Create the XML
# ---------------------------------------------------------------
    
# ---------------------------------------------------------------
# Project node

set doc [dom createDocument VehicleInfo]
set root_node [$doc documentElement]


# minimal set of elements in case this hasn't been imported before
if {![info exists xml_elements] || [llength $xml_elements]==0} {
    set xml_elements {model resource_id resource yom yof distributor_id distributor owner_id owner}
}


ns_log Notice "ID $vehicle_id"

db_1row select_vehicle_info {
    SELECT cv.vin, cc.pretty_name AS model, cv.resource_id, cr.pretty_name AS resource, cv.year_of_model AS yom, cv.year_of_fabrication AS yof, cv.distributor_id, cp1.pretty_name AS distributor, cv.owner_id, cp2.pretty_name AS owner 
    FROM cn_categories cc, cn_vehicles cv
    LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cv.resource_id)
    LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cv.distributor_id)    
    LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cv.owner_id)
    WHERE cv.model_id = cc.category_id
    AND vehicle_id = :vehicle_id

} -column_array vehicle
    

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





set vehicle_node [$doc createElement vehicle id=$vehicle_id]
$root_node appendChild $vehicle_node
    
foreach element $xml_elements { 
	    
    switch $element {
	"model"          { set value $vehicle(model) }
	"resource_id"    { set value $vehicle(resource_id) }
	"resource"       { set value $vehicle(resource) }
	"yom"            { set value $vehicle(yom) }
	"yof"            { set value $vehicle(yof) }
	"distributor_id" { set value $vehicle(distributor_id) }
	"distributor"    { set value $vehicle(distributor) }
	"owner_id"       { set value $vehicle(owner_id) }
	"owner"          { set value $vehicle(owner) }
	default {
	    set attribute_name [plsql_utility::generate_oracle_name "xml_$element"]
	    set value [expr $$attribute_name]
	}
    }
    
    # the following does "<$element>$value</$element>"
    $vehicle_node appendFromList [list $element {} [list [list \#text $value]]]
}



set xml_content "<?xml version=\"1.0\" encoding=\"UTF-8\"?>[$doc asXML -indent 2 -escapeNonASCII]"

set xml $xml_content

set xml_filename "/var/www/iurix/packages/cnauto-assurance/www/resources/vehicle-temp.xml"
set fp [open $xml_filename w]
puts $fp $xml_content
close $fp  


 
ns_return 200 application/octet-stream "<?xml version=\"1.0\" encoding=\"UTF-8\"?>[$doc asXML -indent 2 -escapeNonASCII]"