<?xml version="1.0"?>

<queryset>
  <fullquery name="vehicles_pagination">
    <querytext> 
        SELECT cv.vehicle_id, cv.vin, cc.pretty_name AS model ,cv.purchase_date, cv.resource_id, cr.pretty_name AS resource 
	FROM cn_vehicles cv, cn_resources cr, cn_categories cc 
	WHERE cv.resource_id = cr.resource_id
	AND cv.model_id = cc.category_id
	[template::list::filter_where_clauses -and -name "vehicles"]
    	[template::list::orderby_clause -orderby -name "vehicles"]

    </querytext>
  </fullquery>

  <fullquery name="select_vehicles">
    <querytext> 
        SELECT cv.vehicle_id, cv.vin, cc.pretty_name AS model ,cv.purchase_date, cv.resource_id, cr.pretty_name AS resource 
	FROM cn_vehicles cv, cn_resources cr, cn_categories cc 
	WHERE cv.resource_id = cr.resource_id
	AND cv.model_id = cc.category_id
	[template::list::filter_where_clauses -and -name "vehicles"]
	[template::list::page_where_clause -and -name "vehicles" -key "cv.vehicle_id"]
	[template::list::orderby_clause -orderby -name "vehicles"]
      

    </querytext>
  </fullquery>

</queryset>
