ad_page_contract {

} {
    {code ""}
}



if {$code ne ""} {

    set code_list [db_list select_codes "
	SELECT code FROM cn_parts WHERE code LIKE '%$code%' LIMIT 100
    "]


    ns_log Notice "PAGE Autocomplete1 $code_list"
    

    set html "<ul>"
    
    foreach element $code_list {
	append html "<li>$element</li>" 
    }
    
    
    append html "</ul>"
    
    
#    ad_return_template  -string $html
#    doc_return $html

    ns_return 200 "$html" "$html"
}