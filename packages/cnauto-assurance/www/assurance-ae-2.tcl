ad_page_contract {

} {
    {assurance_id}
    {part_code:array,optional}
    {part_cost:array,optional}
    {part_quantity:array,optional}
    {assurance_cost:array,optional}
    {part_incomes:array,optional}
    {mo_code:array,optional}
    {mo_time:array,optional}
    {third_cost:array,optional}
    {return_url ""}
    {submit.x:optional}
} 



if {[info exists submit.x]} {
    
    cn_assurance::attach_parts \
	-assurance_id $assurance_id \
	-code [array get part_code] \
	-cost [array get part_cost] \
	-quantity [array get part_quantity] \
	-assurance [array get assurance_cost] \
	-income [array get part_incomes] \
	-mo_code [array get mo_code] \
	-mo_time [array get mo_time] \
	-third_cost [array get third_cost]


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


