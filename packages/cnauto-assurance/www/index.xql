<?xml version="1.0" encoding="utf-8"?>


<queryset>
  <fullquery name="assurances_pagination">
    <querytext> 
      SELECT ca.assurance_id, ca.assurance_number, cv.vehicle_id, cv.vin AS chassis, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name, ca.total_cost, ca.assurance_date 
      FROM cn_assurances ca 
      LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = ca.owner_id)
      LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = ca.distributor_id)
      LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = ca.vehicle_id)
      $where_clause
      [template::list::orderby_clause -orderby -name "assurances"]

    </querytext>
  </fullquery>

  <fullquery name="select_assurances">
    <querytext> 

      SELECT ca.assurance_id, ca.assurance_number, cv.vehicle_id, cv.vin AS chassis, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name, ca.total_cost, ca.assurance_date 
      FROM cn_assurances ca 
      LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = ca.owner_id)
      LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = ca.distributor_id)
      LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = ca.vehicle_id)
      $where_clause
      [template::list::page_where_clause -and -name "assurances" -key ca.assurance_id]
      [template::list::orderby_clause -orderby -name "assurances"]
      

    </querytext>
  </fullquery>

</queryset>
