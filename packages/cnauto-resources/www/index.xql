<?xml version="1.0"?>

<queryset>
  <fullquery name="resources_pagination">
    <querytext> 
        SELECT cr.resource_id, cr.code, cr.pretty_name, cc.pretty_name AS class
    	FROM cn_resources cr 
	LEFT OUTER JOIN cn_categories cc
	ON (cr.class_id = cc.category_id)
	$where_clause
	[template::list::filter_where_clauses -and -name "resources"]
    	[template::list::orderby_clause -orderby -name "resources"]

    </querytext>
  </fullquery>

  <fullquery name="select_resources">
    <querytext> 
      SELECT cr.resource_id, cr.code, cr.pretty_name, cc.pretty_name AS class
      FROM cn_resources cr
      LEFT OUTER JOIN cn_categories cc
      ON (cr.class_id = cc.category_id)
      $where_clause  
      [template::list::filter_where_clauses -and -name "resources"]
      [template::list::page_where_clause -and -name "resources" -key "cr.resource_id"]
      [template::list::orderby_clause -orderby -name "resources"]


    </querytext>
  </fullquery>

</queryset>
