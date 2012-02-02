ad_page_contract {
    Display delete confirmation.

} {
    category_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_categories]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set category_ids $category_id
foreach element $category_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set category_ids [join $category_ids ","]

db_multirow categories categories "
        SELECT category_id, pretty_name FROM cn_categories WHERE category_id IN ($category_ids)
    "

set hidden_vars [export_form_vars category_id return_url]


