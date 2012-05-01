ad_page_contract {

    Order's Info page
} {
    {order_id:integer,notnull}
    {return_url ""}
}

set title "[_ cnauto-import.Order_info]"
set context [list $title]


set return_url [ad_conn url]

db_1row select_order_info {
	SELECT cio.parent_id, cio.cnimp_number, cio.provider_id, cp.pretty_name AS provider, cio,cnimp_date, cio.approval_date, cio.li_need_p,payment_date, cio.manufactured_date, cio.departure_date, cio.awb_bl_number, cio.arrival_date, cio.numerary_date, cio.di_date, cio.di_status, cio.nf_date, cio.delivery_date, cio.incoterm_id, cio.transport_type, cio.order_cost, cio.exchange_rate_type, cio.lc_number, cio.start_date, cio.notes 
	FROM cn_import_orders cio
	LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
	WHERE order_id = :order_id

}




if {$cnimp_date ne ""} {
    set date [lindex $cnimp_date 0]
    set date [split $date "-"]
    set cnimp_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$approval_date ne ""} {
    set date [lindex $approval_date 0]
    set date [split $date "-"]
    set approval_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$payment_date ne ""} {
    set date [lindex $payment_date 0]
    set date [split $date "-"]
    set payment_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$manufactured_date ne ""} {
    set date [lindex $manufactured_date 0]
    set date [split $date "-"]
    set manufactured_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$departure_date ne ""} {
    set date [lindex $departure_date 0]
    set date [split $date "-"]
    set departure_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$arrival_date ne ""} {
    set date [lindex $arrival_date 0]
    set date [split $date "-"]
    set arrival_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$numerary_date ne ""} {
    set date [lindex $numerary_date 0]
    set date [split $date "-"]
    set numerary_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$di_date ne ""} {
    set date [lindex $di_date 0]
    set date [split $date "-"]
    set di_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$nf_date ne ""} {
    set date [lindex $nf_date 0]
    set date [split $date "-"]
    set nf_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$delivery_date ne ""} {
    set date [lindex $delivery_date 0]
    set date [split $date "-"]
    set delivery_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}

if {$start_date ne ""} {
    set date [lindex $start_date 0]
    set date [split $date "-"]
    set start_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
}    
