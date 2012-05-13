<?xml version="1.0"?>

<queryset>

<fullquery name="select_category_types">
      <querytext>

	SELECT cc.category_type, COUNT(cc.category_id) AS num, ot.pretty_name
	FROM cn_categories cc, acs_object_types ot
	WHERE cc.category_type = ot.object_type
	GROUP BY cc.category_type, ot.pretty_name 
	
      </querytext>
</fullquery>

<fullquery name="categories_pagination">
      <querytext>
      
      SELECT cc.category_id, cc.pretty_name, cc.parent_id, ot.pretty_name AS pretty_type
      FROM acs_object_types ot, cn_categories cc 
      WHERE ot.object_type = cc.category_type
      [template::list::filter_where_clauses -and -name "categories"]
      [template::list::orderby_clause -orderby -name "categories"]

      </querytext>
</fullquery>

<fullquery name="select_categories">
      <querytext>

      SELECT cc.category_id, cc.pretty_name, cc.parent_id, ot.pretty_name AS pretty_type
      FROM acs_object_types ot, cn_categories cc 
      WHERE ot.object_type = cc.category_type
      [template::list::filter_where_clauses -and -name "categories"]
      [template::list::page_where_clause -and -name categories -key category_id]
      [template::list::orderby_clause -orderby -name "categories"]

      </querytext>
</fullquery>

<fullquery name="select_pretty_name">
      <querytext>

	SELECT pretty_name FROM cn_categories WHERE category_id = :parent_id

      </querytext>
</fullquery>


</queryset>
