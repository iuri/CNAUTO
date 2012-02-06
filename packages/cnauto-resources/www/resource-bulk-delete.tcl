ad_page_contract {
    Display delete confirmation.

} {
    resource_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_resources]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set resource_ids $resource_id
foreach element $resource_ids {
    lappend resource_ids "'[DoubleApos $element]'"
}

set resource_ids [join $resource_ids ","]

db_multirow resources resources "
        SELECT resource_id, pretty_name FROM cn_resources WHERE resource_id IN ($resource_ids)
    "

set hidden_vars [export_form_vars resource_id return_url]


