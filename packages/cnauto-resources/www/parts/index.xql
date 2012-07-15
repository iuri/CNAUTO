<?xml version="1.0"?>

<queryset>
  <fullquery name="parts_pagination">
    <querytext> 
        SELECT cp.part_id, cp.code, cp.pretty_name, cp.resource_id, cr.pretty_name AS resource	
	FROM cn_parts cp
	LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cp.resource_id)
	[template::list::filter_where_clauses -and -name "parts"]
    	[template::list::orderby_clause -orderby -name "parts"]

    </querytext>
  </fullquery>

  <fullquery name="select_parts">
    <querytext> 

        SELECT cp.part_id, cp.code, cp.pretty_name, cp.resource_id, cr.pretty_name AS resource
	FROM cn_parts cp 
	LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cp.resource_id)
	[template::list::filter_where_clauses -and -name "parts"]
    	[template::list::page_where_clause -and -name "parts" -key "cp.part_id"]
    	[template::list::orderby_clause -orderby -name "parts"]


    </querytext>
  </fullquery>

</queryset>
