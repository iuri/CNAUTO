<?xml version="1.0"?>

<queryset>
  <fullquery name="assets_pagination">
    <querytext> 
        SELECT ca.asset_id, ca.asset_code, ca.serial_number, ca.quantity, ca.location, cr.resource_id, cr.pretty_name AS resource	
    	FROM cn_assets ca, cn_resources cr 
	WHERE ca.resource_id = cr.resource_id
	$where_clause
	[template::list::filter_where_clauses -and -name "assets"]
    	[template::list::orderby_clause -orderby -name "assets"]

    </querytext>
  </fullquery>

  <fullquery name="select_assets">
    <querytext> 
        SELECT ca.asset_id, ca.asset_code, ca.serial_number, ca.quantity, ca.location, cr.resource_id, cr.pretty_name AS resource	
    	FROM cn_assets ca, cn_resources cr 
	WHERE ca.resource_id = cr.resource_id
	$where_clause
      [template::list::orderby_clause -orderby -name "assets"]


    </querytext>
  </fullquery>

</queryset>
