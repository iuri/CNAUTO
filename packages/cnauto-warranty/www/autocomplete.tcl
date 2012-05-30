ad_page_contract {

} {
    {chassis ""}
}

#template::head::add_css -href "/resources/cnauto-warranty/warranty.css"



ns_log Notice "PAGE $chassis"
if {$chassis ne ""} {

    set chassis_list [db_list select_chassis "
	SELECT vin FROM cn_vehicles WHERE vin LIKE '%$chassis%' 
    "]


    ns_log Notice "PAGE Autocomplete1 $chassis_list"
    

    set html "<ul>"
    
    foreach element $chassis_list {
	append html "<li>$element</li>" 
    }
    
    
    append html "</ul>"
    
  
    ns_return 200 "$html" "$html"
}