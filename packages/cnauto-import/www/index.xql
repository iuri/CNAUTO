<?xml version="1.0"?>

<queryset>
  <fullquery name="orders_pagination">
    <querytext>

	SELECT co.code, co.provider_id, co.incoterm_id, co.incoterm_value
	FROM cn_orders co
	WHERE co.code = co.code
	[template::list::filter_where_clauses -and -name "orders"]
	[template::list::orderby_clause -orderby -name "orders"]
 
    </querytext>
  </fullquery>

  <fullquery name="select_orders">
    <querytext> 

    	SELECT co.code, co.provider_id, co.incoterm_id, co.incoterm_value
    	FROM cn_orders co
    	WHERE co.code = co.code
    	[template::list::filter_where_clauses -and -name "orders"]
    	[template::list::page_where_clause -and -name "orders" -key "co.order_id"]
    	[template::list::orderby_clause -orderby -name "orders"]
    </querytext>
  </fullquery>


</queryset>
