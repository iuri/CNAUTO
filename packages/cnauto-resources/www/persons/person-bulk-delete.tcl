ad_page_contract {
    Display delete confirmation.

} {
    person_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_vehicles]"]

ns_log Notice "$action"

set delete_p [permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set person_ids $person_id
foreach element $person_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set person_ids [join $person_ids ","]

db_multirow persons persons "
        SELECT person_id, cr.pretty_name  FROM cn_persons cv, cn_resources cr 
        WHERE cv.resource_id = cr.resource_id
        AND person_id IN ($person_ids)
    "

set hidden_vars [export_form_vars person_id return_url]


