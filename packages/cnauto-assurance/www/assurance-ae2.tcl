ad_page_contract {

} {
    {assurance_number ""}
    {purchase_date ""}
    {service_order_number ""}
} 


set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}
