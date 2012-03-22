ad_page_contract {

} {
    {assurance_id}
    {part_code:array,optional}
    {part_name:array,optional}
    {part_cost:array,optional}
    {part_quantity:array,optional}
    {part_incomes:array,optional}
    {part_assurance_cost:array,optional}
    {part_mo_code:array,optional}
    {part_mo_time:array,optional}
    {part_third_cost:array,optional}
}

set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}
