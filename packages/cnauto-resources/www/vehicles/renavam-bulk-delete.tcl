ad_page_contract {
    Display delete confirmation.

} {
    renavam_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_renavam]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set renavam_ids $renavam_id
foreach element $renavam_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set renavam_ids [join $renavam_ids ","]

db_multirow renavam select_renavam "
        SELECT renavam_id, fabricant,lcvm,  model, version, code  FROM cn_renavam cr 
        WHERE renavam_id IN ($renavam_ids)
    "

set hidden_vars [export_form_vars renavam_id return_url]


