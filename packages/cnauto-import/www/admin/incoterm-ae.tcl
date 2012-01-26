ad_page_contract {

} {
    {name ""}
    {pretty_name ""}
    {return_url ""}
}

cn_import::incoterm::new \
    -name $name \
    -pretty_name $pretty_name 


ad_returnredirect $return_url
ad_script_abort