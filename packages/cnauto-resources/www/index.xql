<?xml version="1.0"?>

<queryset>
  <fullquery name="resources_pagination">
    <querytext> 
        SELECT cr.resource_id, cr.code, cr.pretty_name, cr.type_id, cc.category_type, cc.pretty_name AS type
    	FROM cn_resources cr, cn_categories cc
	WHERE cr.type_id = cc.category_id
	$where_clause
    	[template::list::orderby_clause -orderby -name "resources"]

    </querytext>
  </fullquery>

  <fullquery name="select_resources">
    <querytext> 
      SELECT cr.resource_id, cr.code, cr.pretty_name, cr.type_id, cc.category_type, cc.pretty_name AS type
      FROM cn_resources cr, cn_categories cc
      WHERE cr.type_id = cc.category_id
      $where_clause  
      [template::list::page_where_clause -and -name "resources" -key "cr.resource_id"]
      [template::list::orderby_clause -orderby -name "resources"]


    </querytext>
  </fullquery>

</queryset>
