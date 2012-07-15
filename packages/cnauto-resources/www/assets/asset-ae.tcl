ad_page_contract {

    Add/Edit asset
} {
    {asset_id:integer,optional}
    {type_id:integer 2611}
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
    {quantity:integer(text),optional
	{label "[_ cnauto-resources.Quantity]"}
	{html {size 5}}
    }	
    {location:text(text),optional
	{label "[_ cnauto-resources.Location]"}
    }	
} -on_submit {} -new_data {
    
    set asset_id [cn_assets::asset::new \
		      -asset_code $asset_code \
		      -serial_number $serial_number \
		      -resource_id $resource_id \
		      -quantity $quantity \
		      -location $location \
		      -creation_ip [ad_conn peeraddr] \
		      -creation_user [ad_conn user_id] \
		      -context_id [ad_conn package_id]
		 ]
    
    
} -edit_request {

    
} -edit_data {
    
    

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}