<?xml version="1.0"?>

<queryset>
  <fullquery name="persons_pagination">
    <querytext> 
        SELECT cp.person_id, cp.code, cp.pretty_name, cp.type_id
    	FROM cn_persons cp
	[template::list::filter_where_clauses -and -name "persons"]
    	[template::list::orderby_clause -orderby -name "persons"]

    </querytext>
  </fullquery>

  <fullquery name="select_persons">
    <querytext> 

        SELECT cp.person_id, cp.code, cp.pretty_name, cc.pretty_name AS pretty_type
    	FROM cn_persons cp, cn_categories cc
	WHERE cc.category_id = cp.type_id
	[template::list::filter_where_clauses -and -name "persons"]
    	[template::list::page_where_clause -and -name "persons" -key "cp.person_id"]
    	[template::list::orderby_clause -orderby -name "persons"]


    </querytext>
  </fullquery>

</queryset>
