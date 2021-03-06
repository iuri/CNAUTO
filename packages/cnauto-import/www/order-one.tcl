ad_page_contract {

    Order's Info page
} {
    {order_id:integer,notnull}
    {return_url ""}
}

set title "[_ cnauto-import.Order_info]"
set context [list $title]


set return_url [export_vars -base [ad_conn url] {order_id}]

db_1row select_order_info {
    SELECT cio.parent_id, cio.cnimp_number, cio.provider_id, cp.pretty_name AS provider, cio.fabricant_id, cp1.pretty_name AS fabricant, cio.cnimp_date, cio.approval_date, cio.li_need_p,payment_date, cio.manufactured_date, cio.departure_date, cio.awb_bl_number, cio.arrival_date, cio.order_quantity, cio.numerary_date, cio.di_date, cio.di_status, cio.di_number, cio.nf_date, cio.delivery_date, cio.incoterm_id, cii.pretty_name AS incoterm_pretty, cio.transport_type, cio.order_cost, cio.exchange_rate_type, cio.lc_number, cio.start_date
    FROM cn_import_orders cio
    LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
    LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cio.fabricant_id)
    LEFT OUTER JOIN cn_import_incoterms cii ON (cio.incoterm_id = cii.incoterm_id)
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


switch $exchange_rate_type {
    1 { set exchange_rate_type "TT"}
    2 { set exchange_rate_type "LC"}
}


switch $transport_type {
    1 { set transport_type "[_ cnauto-import.Seaport]"}
    2 { set transport_type "[_ cnauto-import.Airport]"}
}

# General Comments                                                                                   
set comment_add_url "
    [general_comments_package_url]comment-add?[export_vars {
	{ object_id $order_id }
	{ object_name $$cnimp_number }
	{ return_url "[ad_conn url]?[ad_conn query]"}
    }]"

set comments_html [general_comments_get_comments -print_content_p 1 $order_id]


