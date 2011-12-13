ad_page_contract {
    Assurance Detailed Info
} {
    assurance_id
}

set page_title [_ cnauto-assurance.Assurance_info]

db_1row select_assurance_info {
    SELECT ca.dcn, ca.assurance_number, ca.assurance_date, ca.status, ca.lp, ca.lp_date, ca.lp_2, ca.lp_2_date, ca.service_order, ca.service_order_date, ca.vehicle_id, cv.vin, ca.kilometers, ca.part_group, ca.part_code, ca.part_quantity, ca.damage_description, ca.third_service, ca.cost_price, ca.assurance_price, ca.tmo_code, ca.tmo_duration, ca.cost, ca.ttl_sg
    FROM cn_assurances ca, cn_vehicles cv
    WHERE cv.vehicle_id = ca.vehicle_id 
    AND ca.assurance_id = :assurance_id
}
    


