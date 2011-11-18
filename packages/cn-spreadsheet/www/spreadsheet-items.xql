<?xml version="1.0"?>

<queryset>


<fullquery name="get_spreadsheet_title">
  <querytext>
    SELECT name FROM cn_spreadsheets WHERE spreadsheet_id = :spreadsheet_id
  </querytext>
</fullquery>

<fullquery name="get_number_of_items">
  <querytext>
    SELECT DISTINCT COUNT(element) FROM cn_spreadsheet_data sd, cn_spreadsheet_fields sf 
    WHERE sf.spreadsheet_id = :spreadsheet_id AND sf.field_id = sd.field_id
  </querytext>
</fullquery>


<fullquery name="select_elems">
  <querytext>
    SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id
  </querytext>
</fullquery>

<fullquery name="select_name">
  <querytext>
    SELECT name FROM cn_spreadsheet_fields WHERE field_id = :field_id
  </querytext>
</fullquery>

<fullquery name="select_field">
  <querytext>
    SELECT field_id, data FROM cn_spreadsheet_data sd WHERE sd.element = :element
  </querytext>
</fullquery>

<fullquery name="users_pagination">
      <querytext>
      
	SELECT DISTINCT se.element FROM cn_spreadsheet_elements se 
	WHERE se.spreadsheet_id = :spreadsheet_id AND se.valid = 't' 
        $where_clause
	[template::list::filter_where_clauses -and -name "items"]
	[template::list::orderby_clause -orderby -name "items"]
	
      </querytext>
</fullquery>

<fullquery name="select_items">      
      <querytext>

	SELECT DISTINCT se.element FROM cn_spreadsheet_elements se
	WHERE se.spreadsheet_id = :spreadsheet_id AND se.valid = 't'
	$where_clause
	[template::list::filter_where_clauses -and -name "items"]
	[template::list::page_where_clause -and -name "items" -key "se.element"]
	[template::list::orderby_clause -orderby -name "items"]
	
      </querytext>
</fullquery>
 
</queryset>
