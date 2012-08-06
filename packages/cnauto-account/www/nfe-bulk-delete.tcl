ad_page_contract {
    Display delete confirmation.

} {
    nfe_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_nfes]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set nfe_ids $nfe_id
foreach element $nfe_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set nfe_ids [join $nfe_ids ","]

db_multirow nfes nfes "
        SELECT nfe_id, key, number  FROM cn_nfes cn WHERE nfe_id IN ($nfe_ids)
    "

set hidden_vars [export_form_vars nfe_id return_url]


