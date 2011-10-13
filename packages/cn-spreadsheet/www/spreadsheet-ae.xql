<?xml version="1.0"?>
<queryset>

<fullquery name="get_data_info">      
  <querytext>

    SELECT name, description 
    FROM cn_spreadsheets
    WHERE spreadsheet_id = :spreadsheet_id

  </querytext>
</fullquery>

</queryset>
