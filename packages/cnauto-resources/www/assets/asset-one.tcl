ad_page_contract {
    Shows asset's info
} {
    {asset_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-resources.Asset_info]

set assign_asset_url [export_vars -base "assign-asset" {asset_id return_url}]

ad_form -name asset_one -action asset-ae -export {{return_url "asset-one"} asset_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Asset_info]</h2>"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {asset_code:text(text)
	{label "[_ cnauto-resources.Asset_code]"}
    }
    {serial_number:text(text),optional
	{label "[_ cnauto-resources.Serial_number]"}
    }	
    {location:text(text),optional
	{label "[_ cnauto-resources.Location]"}
    }	
} -on_request {
    
   
    db_1row select_asset_info {
	
	SELECT ca.asset_code, ca.serial_number, cr.pretty_name, ca.location
	FROM cn_assets ca, cn_resources cr
	WHERE ca.resource_id = cr.resource_id 
	AND ca.asset_id = :asset_id
    }

    set asset_ae_url [export_vars -base "asset-ae" {asset_id return_url}]

}




