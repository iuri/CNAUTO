ad_page_contract {
    Display delete confirmation.

} {
    vehicle_id:multiple,notnull
    {action "confirmation"}
    {return_url ""}
} -properties {
    pretty_name:onevalue
    context_bar:onevalue
}

set context_bar [list "[_ cn-orders.Delete_vehicles]"]

ns_log Notice "$action"

set delete_p 1 
#[permission::permission_p -object_id [ad_conn package_id] -privilege "order_delete"]

if {$delete_p eq 0} {
    ad_returnredirect unauthorized-delete
    ad_script_abort
}

set vehicle_ids $vehicle_id
foreach element $vehicle_ids {
    lappend order_ids "'[DoubleApos $element]'"
}

set vehicle_ids [join $vehicle_ids ","]

db_multirow vehicles vehicles "
        SELECT vehicle_id, vin, cr.pretty_name  FROM cn_vehicles cv, cn_resources cr 
        WHERE cv.resource_id = cr.resource_id
        AND vehicle_id IN ($vehicle_ids)
    "

set hidden_vars [export_form_vars vehicle_id return_url]


