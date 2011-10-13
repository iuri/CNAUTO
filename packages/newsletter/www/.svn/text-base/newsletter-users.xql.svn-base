<?xml version="1.0"?>

<queryset>


<fullquery name="get_newsletter_title">
  <querytext>
    SELECT name FROM newsletters WHERE newsletter_id = :newsletter_id
  </querytext>
</fullquery>

<fullquery name="get_number_of_users">
  <querytext>
    SELECT DISTINCT COUNT(email) FROM newsletters_data nd, newsletters_fields nf 
    WHERE nf.newsletter_id = :newsletter_id AND nf.field_id = nd.field_id
  </querytext>
</fullquery>


<fullquery name="select_elems">
  <querytext>
    SELECT field_id FROM newsletters_fields WHERE newsletter_id = :newsletter_id
  </querytext>
</fullquery>

<fullquery name="select_name">
  <querytext>
    SELECT name FROM newsletters_fields WHERE field_id = :field_id
  </querytext>
</fullquery>

<fullquery name="select_field">
  <querytext>
    SELECT field_id, data FROM newsletters_data nd WHERE nd.email = :email
  </querytext>
</fullquery>

<fullquery name="users_pagination">
      <querytext>
      
	SELECT DISTINCT ne.email FROM newsletters_emails ne 
	WHERE ne.newsletter_id = :newsletter_id AND ne.valid = 't' 
        $where_clause
	[template::list::filter_where_clauses -and -name "users"]
	[template::list::orderby_clause -orderby -name "users"]
	
      </querytext>
</fullquery>

<fullquery name="users_select">      
      <querytext>

	SELECT DISTINCT ne.email FROM newsletters_emails ne
	WHERE ne.newsletter_id = :newsletter_id	AND ne.valid = 't'
	$where_clause
	[template::list::filter_where_clauses -and -name "users"]
	[template::list::page_where_clause -and -name "users" -key "ne.email"]
	[template::list::orderby_clause -orderby -name "users"]
	
      </querytext>
</fullquery>
 
</queryset>
