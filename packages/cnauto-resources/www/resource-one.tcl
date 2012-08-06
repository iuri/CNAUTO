ad_page_contract {
    Shows person's info
} {
    {resource_id:integer,optional}
    {email ""}
    {return_url ""}
}

set page_title [_ cnauto-resources.Resource_info]


ad_form -name resource_one -action resource-ae -export {{return_url "resource-one"} resource_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Resource_info]</h2>"}
    }
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {type:text(text)
	{label "[_ cnauto-resources.Type]"}
    }	
    {unit:text(text)
	{label "[_ cnauto-resources.Unit]"}
    }	
    {ncm:text(text),optional
	{label "[_ cnauto-resources.NCM]"}
	{html {size 30} }
    }    
} -on_request {
    
   
    db_1row select_resource_info {
	
	SELECT cr.code, cr.pretty_name, cc.pretty_name AS type, cr.unit, cr.ncm_class
	FROM cn_resources cr, cn_categories cc 
	WHERE cr.type_id = cc.category_id 
	AND cr.resource_id = :resource_id
    }

    set resource_ae_url [export_vars -base "resource-ae" {resource_id return_url}]

}




