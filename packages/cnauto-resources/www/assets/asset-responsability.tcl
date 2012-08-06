ad_page_contract {
    
    List Assets and users to assign reponsabilities

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-07-15

			  
}

set matrix [db_list_of_lists select_info {
    SELECT caum.asset_id, ca.asset_code, ca.serial_number, cr.pretty_name, caum.user_id, u.screen_name AS user 
    FROM cn_asset_user_map caum, cn_assets ca, cn_resources cr, users u
    WHERE caum.user_id = u.user_id
    AND caum.asset_id = ca.asset_id
    AND ca.resource_id = cr.resource_id
    
}]


template::multirow create columns count
template::multirow create rows user asset code sn

for {set i 0} {$i < [llength matrix]} {incr i} {
    multirow append columns $i
    multirow append rows [lindex [lindex $matrix $i] 5] [lindex [lindex $matrix $i] 3] [lindex [lindex $matrix $i] 2] [lindex [lindex $matrix $i] 1]

} 

