ad_page_contract {
} {
    {vehicle_id "" }
}
# ---------------------------------------------------------------
# Create the XML
# ---------------------------------------------------------------
    
# ---------------------------------------------------------------
# Project node

# minimal set of elements in case this hasn't been imported before
if {![info exists xml_elements] || [llength $xml_elements]==0} {
    set xml_elements {model resource_id resource yom yof distributor_id distributor owner_id owner}
}


ns_log Notice "ID# $vehicle_id"

db_1row select_vehicle_info {
    SELECT cv.vin, cc.pretty_name AS model, cv.resource_id, cr.pretty_name AS resource, cv.year_of_model AS yom, cv.year_of_fabrication AS yof, cv.distributor_id, cp1.pretty_name AS distributor, cv.owner_id, cp2.pretty_name AS owner 
    FROM cn_categories cc, cn_vehicles cv
    LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cv.resource_id)
    LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cv.distributor_id)    
    LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cv.owner_id)
    WHERE cv.model_id = cc.category_id
    AND vehicle_id = :vehicle_id

} -column_array vehicle
    
set xml ""

ns_log Notice "TEST"
foreach element $xml_elements { 
	    ns_log Notice "TEST"

    switch $element {
	"owner"          {  
	    set  owner_xml "<vehicle name=$vehicle_id>"
	    
	    set owner_options [db_list_of_lists select_client_info {
		SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
		WHERE cp.type_id = cc.category_id
		AND cc.name = 'clientes'
		
	    }]
	    
	    foreach owner $owner_options {
		append owner_xml "
                <owner id='[lindex $owner 0]'>[lindex $owner 1]</owner>
                "
	    }
	    append owner_xml "</vehicle>"
	    append xml $owner_xml
	}	    
    }
    
}


ns_log Notice "$xml"


set doc [dom createDocument VehicleInfo]
set root_node [$doc documentElement]
$root_node appendChild $xml

ns_return 200 application/octet-stream "<?xml version=\"1.0\" encoding=\"UTF-8\"?>[$doc asXML -indent 2 -escapeNonASCII]"