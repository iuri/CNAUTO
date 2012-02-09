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
