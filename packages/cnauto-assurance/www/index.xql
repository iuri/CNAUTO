<?xml version="1.0"?>

<queryset>
  <fullquery name="assurances_pagination">
    <querytext> 
        SELECT ca.assurance_id, ca.assurance_number, cv.vehicle_id, cv.vin AS chassis, cp.person_id, cp.pretty_name AS person_name
    	FROM cn_assurances ca, cn_persons cp, cn_vehicles cv
	WHERE ca.vehicle_id = cv.vehicle_id
	AND cp.person_id = cv.owner_id
	[template::list::filter_where_clauses -and -name "assurances"]
    	[template::list::orderby_clause -orderby -name "assurances"]

    </querytext>
  </fullquery>

  <fullquery name="select_assurances">
    <querytext> 

        SELECT ca.assurance_id, ca.assurance_number, cv.vehicle_id, cv.vin AS chassis, cp.person_id, cp.pretty_name AS person_name
    	FROM cn_assurances ca, cn_persons cp, cn_vehicles cv
	WHERE ca.vehicle_id = cv.vehicle_id
	AND cp.person_id = cv.owner_id
	$where_clause
	[template::list::filter_where_clauses -and -name "assurances"]
    	[template::list::page_where_clause -and -name "assurances" -key "ca.assurance_id"]
    	[template::list::orderby_clause -orderby -name "assurances"]


    </querytext>
  </fullquery>

</queryset>
