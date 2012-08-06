ad_page_contract {

    Add/Edit asset
} {
    {asset_id:integer,optional}
    {type_id 2611}
    {return_url ""}
}

if {[exists_and_not_null asset_id]} {
    set title "[_ cnauto-resources.Edit_asset]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_asset]"
    set context [list $title]
}

set resource_options [cn_resources::get_options -type_id $type_id]

ad_form -name asset_ae -cancel_url $return_url -form {
    {asset_id:key}
    {resource_id:integer(select)
	{label "[_ cnauto-resources.Resource]"}
	{options $resource_options}
    }
    {asset_code:text(text),optional
	{label "[_ cnauto-resources.Code]"}
    }	
    {serial_number:text(text),optional
	{label "[_ cnauto-resources.Serial_number]"}
    }	
    {location:text(text),optional
	{label "[_ cnauto-resources.Location]"}
    }	
} -on_submit {} -new_data {
    
    set asset_id [cn_assets::asset::new \
		      -asset_code $asset_code \
		      -serial_number $serial_number \
		      -resource_id $resource_id \
		      -location $location \
		      -creation_ip [ad_conn peeraddr] \
		      -creation_user [ad_conn user_id] \
		      -context_id [ad_conn package_id]
		 ]
    
    
} -edit_request {

    db_1row select_asset_info {
	
	SELECT ca.asset_code, ca.serial_number, cr.resource_id, cr.pretty_name, ca.location
	FROM cn_assets ca, cn_resources cr
	WHERE ca.resource_id = cr.resource_id 
	AND ca.asset_id = :asset_id
    }

} -edit_data {
    
    

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}