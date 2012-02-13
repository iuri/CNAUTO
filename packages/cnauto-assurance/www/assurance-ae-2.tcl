ad_page_contract {

} {
    {assurance_id}
    {part_code:array,optional}
    {part_name:array,optional}
    {part_cost:array,optional}
    {part_quantity:array,optional}
    {assurance_cost:array,optional}
    {part_incomes:array,optional}
    {mo_code:array,optional}
    {mo_time:array,optional}
    {third_cost:array,optional}
    {description:optional}
    {parts_total_cost:optional}
    {assurance_total_cost:optional}
    {third_total_cost:optional}
    {mo_total_cost:optional}
    {total_cost:optional}
    {return_url ""}
    {submit.x:optional}
} 

set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}


if {[info exists submit.x]} {
    
    for {set i 0} {$i < [array size part_code]} {incr i} {
	
	ns_log Notice "$part_code($i) | $part_name($i)"
	
	
	set code $part_code($i)
	if {![string equal $code ""]} {
	    set part_id [db_string select_part_id {
		SELECT part_id FROM cn_parts WHERE code = :code
	    } -default null]
	    
	    if {[string equal $part_id "null"]} {
		ad_return_complaint 1 "The part insert does not exist on the database $part_code($i) - $part_name($i) <br /> Please <a href='javascript:history.go(-1)'><b>go back</b></a> and fix the error."
	    }
	    
	    cn_assurance::attach_parts \
		-assurance_id $assurance_id \
		-part_id $part_id \
		-cost  $part_cost($i) \
		-quantity $part_quantity($i) \
		-assurance $assurance_cost($i) \
		-income $part_incomes($i) \
		-mo_code $mo_code($i) \
		-mo_time $mo_time($i) \
		-third_cost $third_cost($i)
	    
	}
    }
    
    cn_assurance::update_costs \
	-assurance_id $assurance_id \
	-description $description \
	-parts_total_cost $parts_total_cost \
	-assurance_total_cost $assurance_total_cost \
	-third_total_cost $third_total_cost \
	-mo_total_cost $mo_total_cost \
	-total_cost $total_cost
    

    ad_returnredirect [export_vars -base "index" {}]
}



set title [_ cnauto-assurance.Add_parts]

db_1row select_assurance_number {
    SELECT assurance_number FROM cn_assurances WHERE assurance_id = :assurance_id
}


set parts_html ""

template::multirow create parts i


for {set i 0} {$i < 5} {incr i} {
    template::multirow append parts $i
}


template::head::add_javascript -src "/resources/cnauto-assurance/js/js-library.js"


