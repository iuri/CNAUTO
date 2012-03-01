<?xml version="1.0"?>

<queryset>
  <fullquery name="parts_pagination">
    <querytext> 
        SELECT cp.part_id, cp.code, cp.pretty_name, cp.resource_id, cr.pretty_name AS resource,	
	CASE WHEN (
	  SELECT cc.pretty_name
	  FROM cn_parts cp1, cn_categories cc 
	  WHERE cp1.part_id = cp.part_id
	  AND cc.category_id = cp1.model_id
	) != ' ' THEN cp.pretty_name END 
	FROM cn_parts cp, cn_resources cr
	WHERE cp.resource_id = cr.resource_id
	[template::list::filter_where_clauses -and -name "parts"]
    	[template::list::orderby_clause -orderby -name "parts"]

    </querytext>
  </fullquery>

  <fullquery name="select_parts">
    <querytext> 

        SELECT cp.part_id, cp.code, cp.pretty_name, cp.resource_id, cr.pretty_name AS resource,
	CASE WHEN (
	  SELECT cc.pretty_name
	  FROM cn_parts cp1, cn_categories cc 
	  WHERE cp1.part_id = cp.part_id
	  AND cc.category_id = cp1.model_id
	) != ' ' THEN cp.model_id END AS model
	FROM cn_parts cp, cn_resources cr
	WHERE cp.resource_id = cr.resource_id
	[template::list::filter_where_clauses -and -name "parts"]
    	[template::list::page_where_clause -and -name "parts" -key "cp.part_id"]
    	[template::list::orderby_clause -orderby -name "parts"]


    </querytext>
  </fullquery>

</queryset>
