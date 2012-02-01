<?xml version="1.0"?>

<queryset>
  <fullquery name="vehicles_pagination">
    <querytext> 
        SELECT cv.vehicle_id, cv.vin, cv.engine, cv.model, cv.year_of_model, cv.year_of_fabrication, cv.color, cv.purchase_date, cv.arrival_date, cv.billing_date, cv.duration, cv.person_id, cv.distributor_id, cv.resource_id 
	FROM cn_vehicles cv 
	WHERE cv.vehicle_id = cv.vehicle_id
	[template::list::filter_where_clauses -and -name "vehicles"]
    	[template::list::orderby_clause -orderby -name "vehicles"]

    </querytext>
  </fullquery>

  <fullquery name="select_vehicles">
    <querytext> 
        SELECT cv.vehicle_id, cv.vin, cv.engine, cv.model, cv.year_of_model, cv.year_of_fabrication, cv.color, cv.purchase_date, cv.arrival_date, cv.billing_date, cv.duration, cv.person_id, cv.distributor_id, cv.resource_id 
	FROM cn_vehicles cv 
	WHERE cv.vehicle_id = cv.vehicle_id
	[template::list::filter_where_clauses -and -name "vehicles"]
	[template::list::page_where_clause -and -name "vehicles" -key "cv.vehicle_id"]
	[template::list::orderby_clause -orderby -name "vehicles"]
      

    </querytext>
  </fullquery>

</queryset>
