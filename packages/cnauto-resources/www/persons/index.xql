<?xml version="1.0"?>

<queryset>
  <fullquery name="persons_pagination">
    <querytext> 
        SELECT cp.person_id, 
	cp.code,
	CASE WHEN (
	  SELECT pretty_name FROM cn_persons WHERE person_id = cp.person_id
	) != ' ' THEN cp.pretty_name 
	ELSE (
	  SELECT u.first_names || ' ' || u.last_name FROM cc_users u WHERE u.user_id = cp.contact_id 
	) END AS pretty_name,
	cp.type_id,
	cc.pretty_name AS pretty_type
    	FROM cn_persons cp, cn_categories cc
	WHERE cc.category_id = cp.type_id
	[template::list::filter_where_clauses -and -name "persons"]
    	[template::list::orderby_clause -orderby -name "persons"]

    </querytext>
  </fullquery>

  <fullquery name="select_persons">
    <querytext> 

        SELECT cp.person_id, 
	cp.code,
	CASE WHEN (
	  SELECT pretty_name FROM cn_persons WHERE person_id = cp.person_id
	) != ' ' THEN cp.pretty_name 
	ELSE (
	  SELECT u.first_names || ' ' || u.last_name FROM cc_users u WHERE u.user_id = cp.contact_id 
	) END AS pretty_name,
	cp.type_id,
	cc.pretty_name AS pretty_type
    	FROM cn_persons cp, cn_categories cc
	WHERE cc.category_id = cp.type_id
	[template::list::filter_where_clauses -and -name "persons"]
    	[template::list::page_where_clause -and -name "persons" -key "cp.person_id"]
    	[template::list::orderby_clause -orderby -name "persons"]


    </querytext>
  </fullquery>

</queryset>
