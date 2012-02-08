ad_page_contract {
    Shows part's info
} {
    {part_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-resource.Part_info]


ad_form -name part_one -action part-ae -export {return_url part_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Part_info]</h2>"}
    }
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {resource:text(text)
	{label "[_ cnauto-resources.Resource]"}
    }
    {model:text(text)
	{label "[_ cnauto-resources.Model]"}
    }
    {quantity:integer
	{label "[_ cnauto-resources.Quantity]"}
    }
    {price:text(text)
	{label "[_ cnauto-resources.Price]"}
    }
    {width:text(text)
	{label "[_ cnauto-resources.Width]"}
    }
    {height:text(text)
	{label "[_ cnauto-resources.Height]"}
    }
    {depth:text(text)
	{label "[_ cnauto-resources.Depth]"}
    }
    {weight:text(text)
	{label "[_ cnauto-resources.Weight]"}
    }
    {volume:text(text)
	{label "[_ cnauto-resources.Volume]"}
    }
    {dimensions:text(text)
	{label "[_ cnauto-resources.Dimensions]"}
    }
}

ad_form -extend -name part_one -on_request {
    
   
    db_1row select_part_info {
	
	SELECT cp.code, cp.pretty_name, cr.pretty_name AS resource, cc.pretty_name AS model, cp.quantity, cp.price, cp.width, cp.height, cp.depth, cp.weight, cp.volume, cp.dimensions 
	FROM cn_categories cc, cn_parts cp 
	LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cp.resource_id)
	WHERE cp.part_id = :part_id
	AND cp.model_id = cc.category_id
    }

    set part_ae_url [export_vars -base "part-ae" {part_id return_url}]

} -on_submit {

    set myform [ns_getform]
    if {[string equal "" $myform]} {
	ns_log Notice "No Form was submited"
    } else {
	ns_log Notice "FORM"
	ns_set print $myform
    }
}




