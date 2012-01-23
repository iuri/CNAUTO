<?xml version="1.0"?>

<queryset>
  <fullquery name="orders_pagination">
    <querytext>

    	SELECT co.order_id, co.code, cp.pretty_name AS provider, cii.name || ' - ' || cii.pretty_name AS incoterm, co.incoterm_value
    	FROM cn_orders co, cn_persons cp, cn_import_incoterms cii
    	WHERE co.code = co.code
	AND co.provider_id = cp.person_id
	AND co.incoterm_id = cii.incoterm_id
	[template::list::filter_where_clauses -and -name "orders"]
	[template::list::orderby_clause -orderby -name "orders"]
 
    </querytext>
  </fullquery>

  <fullquery name="select_orders">
    <querytext> 

    	SELECT co.order_id, co.code, cp.pretty_name AS provider, cii.name || ' - ' || cii.pretty_name AS incoterm, co.incoterm_value, o.creation_date
    	FROM cn_orders co, cn_persons cp, cn_import_incoterms cii, acs_objects o
    	WHERE co.code = co.code
	AND co.provider_id = cp.person_id
	AND co.incoterm_id = cii.incoterm_id
	AND co.order_id = o.object_id
    	[template::list::filter_where_clauses -and -name "orders"]
    	[template::list::page_where_clause -and -name "orders" -key "co.order_id"]
    	[template::list::orderby_clause -orderby -name "orders"]
    </querytext>
  </fullquery>


</queryset>
