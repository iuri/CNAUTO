ad_page_contract {
    Display delete confirmation.

} {
    order_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_orders]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set order_ids $order_id
foreach element $order_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set order_ids [join $order_ids ","]

db_multirow orders orders "
        SELECT order_id, code FROM cn_orders WHERE order_id IN ($order_ids)
    "

set hidden_vars [export_form_vars order_id return_url]


