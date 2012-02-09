ad_page_contract {

} {
    {assurance_id}
} 


set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}




set title [_ cnauto-assurance.Add_parts]


set part_select_html [cn_assurance::part_select_widget_html -name "part_id"]

set parts_html ""

for {set i 0} {$i < 5} {incr i} {
    
    append parts_html "
	<tr>
    	  <td>
            <input type=\"text\" name=\"part_code.${i}\" id=\"part_code.${i}\">
          </td>
	  <td>
            <input type=\"text\" name=\"part_name.${i}\" id=\"part_name.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_cost.${i}\" id=\"part_cost.${i}\">
          </td>
    	  <td>
             <input type=\"text\" name=\"part_quantity.${i}\" id=\"parts_quantity.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_incomes.${i}\" id=\"part_incomes.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_assurance_cost.${i}\" id=\"part_assurance_cost.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_mo_code.${i}\" id=\"part_mo_code.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_mo_time.${i}\" id=\"part_mo_time.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_third_cost.${i}\" id=\"part_third_cost.${i}\">
          </td>
	</tr>
	
"
}

template::head::add_javascript -script {
    
    function FillFieldsOnChange() {
	var partId = document.getElementById("part_id");
	
	// get selected continent from dropdown list
	var selectedPart = partId.options[partId.selectedIndex].value;
	
	// url of page that will send xml data back to client browser
	var requestUrl;
	// use the following line if using asp
	requestUrl = "assurance-ae-2" + "?part_id=" + encodeURIComponent(selectedPart);
	window.location.href = requestUrl;
    }
}
