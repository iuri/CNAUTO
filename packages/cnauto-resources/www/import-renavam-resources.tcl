ad_page_contract {}


db_foreach select_renavam {
    SELECT code FROM cn_vehicle_renavam
} {

    set pretty_name [db_string select_mmv {
	SELECT 
	CASE WHEN fabricant IS NOT NULL THEN fabricant ELSE '' END || ' ' || 
	CASE WHEN lcvm IS NOT NULL THEN lcvm ELSE '' END || ' ' || 
	CASE WHEN model IS NOT NULL THEN model ELSE '' END || ' ' || 
	CASE WHEN version IS NOT NULL THEN version ELSE '' END AS title
	FROM cn_vehicle_renavam
	WHERE code = :code
    }]
    
    
    
    set resource_id [cn_resources::resource::new \
			 -code $code \
			 -pretty_name $pretty_name \
			 -type_id 1214 \
			 -unit "Un" \
			 -creation_ip [ad_conn peeraddr] \
			 -creation_user [ad_conn user_id] \
			 -context_id [ad_conn package_id]
		    ]

    ns_log Notice "$resource_id"
}