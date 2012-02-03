<?xml version="1.0"?>

<queryset>

<fullquery name="categories_pagination">
      <querytext>
      
	SELECT cc.category_id, cc.pretty_name, ot.pretty_name AS prety_type
	FROM cn_categories cc, acs_object_types ot
	WHERE ot.object_type = cc.object_type
	[template::list::filter_where_clauses -and -name "categories"]
	[template::list::orderby_clause -orderby -name "categories"]
	
      </querytext>
</fullquery>

<fullquery name="select_categories">
      <querytext>

	SELECT cc.category_id, cc.pretty_name, ot.pretty_name AS pretty_type
	FROM cn_categories cc, acs_object_types ot
	WHERE ot.object_type = cc.object_type
	[template::list::filter_where_clauses -and -name "categories"]
	[template::list::page_where_clause -and -name "categories" -key "cc.category_id"]
	[template::list::orderby_clause -orderby -name "categories"]

      </querytext>
</fullquery>

</queryset>
