ad_page_contract {
    Display delete confirmation.

} {
    part_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_parts]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set part_ids $part_id
foreach element $part_ids {
    lappend part_ids "'[DoubleApos $element]'"
}

set part_ids [join $part_ids ","]

db_multirow parts parts "
        SELECT part_id, code, pretty_name FROM cn_parts WHERE part_id IN ($part_ids)
    "

set hidden_vars [export_form_vars part_id return_url]


