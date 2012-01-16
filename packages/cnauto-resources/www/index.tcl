ad_page_contract {
    Resources main page
}


set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

if {$admin_p} {
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}
set return_url [ad_return_url]

set person_ae_url [export_vars -base "person-ae" {return_url}]