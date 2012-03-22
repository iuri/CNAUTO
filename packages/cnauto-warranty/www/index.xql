<?xml version="1.0" encoding="utf-8"?>


<queryset>
  <fullquery name="claims_pagination">
    <querytext> 
      SELECT cc.claim_id, cc.claim_number, cv.vehicle_id, cv.vin AS chassis, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name, cc.total_cost, cc.claim_date 
      FROM cn_claims cc 
      LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cc.owner_id)
      LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cc.distributor_id)
      LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = cc.vehicle_id)
      $where_clause
      [template::list::orderby_clause -orderby -name "claims"]

    </querytext>
  </fullquery>

  <fullquery name="select_claims">
    <querytext> 

      SELECT cc.claim_id, cc.claim_number, cv.vehicle_id, cv.vin AS chassis, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name, cc.total_cost, cc.claim_date 
      FROM cn_claims cc
      LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cc.owner_id)
      LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cc.distributor_id)
      LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = cc.vehicle_id)
      $where_clause
      [template::list::page_where_clause -and -name "claims" -key cc.claim_id]
      [template::list::orderby_clause -orderby -name "claims"]
      

    </querytext>
  </fullquery>

</queryset>
