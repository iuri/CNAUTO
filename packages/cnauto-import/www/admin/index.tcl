ad_page_contract {
    
    Import admin page

} {
    { return_url "" }
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Admin]"
set context [list $title]


set node_id [db_string select_node_id {
    SELECT node_id 
    FROM site_nodes sn, apm_packages ap 
    WHERE ap.package_id = sn.object_id 
    AND package_key = 'cnauto-resources'
}]

set resources_url [site_node::get_url -node_id $node_id]

set type_id 826

ns_log Notice "TEDST $resources_url"
set person_ae_url [export_vars -base "${resources_url}persons/person-ae"  {return_url type_id}]
