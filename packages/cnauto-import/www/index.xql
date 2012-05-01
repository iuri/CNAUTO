<?xml version="1.0"?>

<queryset>
  <fullquery name="orders_pagination">
    <querytext>
      SELECT DISTINCT cio.order_id, cio.parent_id, cio.cnimp_number, cp.pretty_name AS provider_pretty, cio.cnimp_date, cio.di_status 
      FROM cn_import_orders cio 
      LEFT JOIN cn_import_orders cio2 ON (cio2.parent_id = cio.order_id)
      LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
      $where_clause
      [template::list::filter_where_clauses -and -name "orders"]
      [template::list::orderby_clause -orderby -name "orders"]
      
    </querytext>
  </fullquery>

  <fullquery name="select_orders">
    <querytext> 
      SELECT DISTINCT cio.order_id, cio.parent_id, cio.cnimp_number, cp.pretty_name AS provider_pretty, cio.cnimp_date, cio.di_status 
      FROM cn_import_orders cio 
      LEFT JOIN cn_import_orders cio2 ON (cio2.parent_id = cio.order_id)
      LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
      $where_clause
      [template::list::filter_where_clauses -and -name "orders"]
      [template::list::page_where_clause -and -name "orders" -key "cio.order_id"]
      [template::list::orderby_clause -orderby -name "orders"]
    </querytext>
  </fullquery>


</queryset>
