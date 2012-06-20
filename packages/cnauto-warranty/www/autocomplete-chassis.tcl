ad_page_contract {

} {
    {chassis ""}
}

#template::head::add_css -href "/resources/cnauto-warranty/warranty.css"
template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/prototype.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/effects.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/controls.js"



ns_log Notice "PAGE $chassis"
if {$chassis ne ""} {

    set chassis_list [db_list select_chassis "
	SELECT vin FROM cn_vehicles WHERE vin LIKE '%$chassis%' LIMIT 100
    "]


    ns_log Notice "PAGE Autocomplete1 $chassis_list"
    

    set html "<ul>"
    
    foreach element $chassis_list {
	append html "<li>$element</li>" 
    }
    
    
    append html "</ul>"
    
    
#    ad_return_template  -string $html
#    doc_return $html

    ns_return 200 "$html" "$html"
}