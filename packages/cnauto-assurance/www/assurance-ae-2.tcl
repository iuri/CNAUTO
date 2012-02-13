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




set title [_ cnauto-assurance.Add_parts]

set parts_html ""

for {set i 0} {$i < 5} {incr i} {
    
    append parts_html [cn_assurance::part_html_input -name "part_id_${i}" -count $i -assurance_id $assurance_id]
    
}

template::head::add_javascript -script {
    
    function FillFieldsOnChange(i,assuranceId) {
	var partId = document.getElementById("part_id." + i);
	
	// get selected continent from dropdown list
	var selectedPart = partId.options[partId.selectedIndex].value;
	
	// url of page that will send xml data back to client browser
	var requestUrl;
	// use the following line if using asp
	requestUrl = "assurance-ae-2" + "?assurance_id=" + encodeURIComponent(selectedPart);

	//window.location.href = requestUrl;
    }
}
