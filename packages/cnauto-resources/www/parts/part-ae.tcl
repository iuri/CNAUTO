ad_page_contract {
    
    Add/Edit part
} {
    {part_id:integer,optional}
    {return_url ""}
}

if {[exists_and_not_null part_id]} {
    set title "[_ cnauto-resources.Edit_part]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_part]"
    set context [list $title]
}


set model_options [db_list_of_lists select_model {
	SELECT pretty_name, category_id
	FROM cn_categories WHERE object_type = 'cn_part' ORDER BY pretty_name
}]
    
lappend model_options {"Selecione" ""}


set resource_options [db_list_of_lists select_resources {
    SELECT cr.pretty_name, cr.resource_id FROM cn_resources cr, cn_categories cc WHERE cr.class_id = cc.category_id AND cc.name = 'parts'
}]

lappend resource_options {"Selecione" ""}

ad_form -name part_ae -form {
    {part_id:key}
    {inform1:text(inform)
	{label "<b>[_ cnauto-resources.Part_info]</b>"}
    }
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {resource_id:integer(select)
	{label "[_ cnauto-resources.Resource]"}
	{options $resource_options}
    }
    {model_id:integer(select),optional
	{label "[_ cnauto-resources.Model]"}
	{options $model_options}
    }
    {quantity:integer,optional
	{label "[_ cnauto-resources.Quantity]"}
	{html {size 3}}
    }
    {price:text(text),optional
	{label "[_ cnauto-resources.Price]"}
	{html {size 5}}
    }
    {width:text(text),optional
	{label "[_ cnauto-resources.Width]"}
    }
    {height:text(text),optional
	{label "[_ cnauto-resources.Height]"}
    }
    {depth:text(text),optional
	{label "[_ cnauto-resources.Depth]"}
    }
    {weight:text(text),optional
	{label "[_ cnauto-resources.Weight]"}
    }
    {volume:text(text),optional
	{label "[_ cnauto-resources.Volume]"}
    }
    {dimensions:text(text),optional
	{label "[_ cnauto-resources.Dimensions]"}
    }
    {return_url:text(hidden)
	{value $return_url}
    }
} -on_submit {
} -new_request {   
} -edit_request {


    db_1row select_part_info {
	
	
	SELECT cp.code, cp.pretty_name, cr.pretty_name AS resource, cc.pretty_name AS model, cp.quantity, cp.price, cp.width, cp.height, cp.depth, cp.weight, cp.volume, cp.dimensions 
	FROM cn_parts cp 
	LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cp.resource_id)
	LEFT JOIN cn_categories cc ON (cc.category_id = cp.model_id)
	WHERE cp.part_id = :part_id
    }
} -edit_data {
    
    set name [util_text_to_url -replacement "" -text $pretty_name]
    
    set part_id [cn_resources::part::edit \
		     -part_id $part_id \
		     -code $code \
		     -name $name \
		     -pretty_name $pretty_name \
		     -resource_id $resource_id \
		     -model_id $model_id \
		     -quantity $quantity \
		     -price $price \
		     -width $width \
		     -height $height \
		     -depth $depth \
		     -weight $weight \
		     -volume $volume \
		     -dimensions $dimensions \
		 ]
    
    
} -new_data {

    set part_exists_p [db_0or1row select_part_id {
	SELECT part_id FROM cn_parts WHERE code = :code
    }]
    
    
    if {$part_exists_p} {
	ad_return_complaint 1 "The chassis already exists on the database! Please <a href=\"javascript:history.go(-1);\">go back and fix it!</a> "
    } else {
	
	set name [util_text_to_url -replacement "" -text $pretty_name]
	
	set part_id [cn_resources::part::new \
			 -code $code \
			 -name $name \
			 -pretty_name $pretty_name \
			 -resource_id $resource_id \
			 -model_id  $model_id \
			 -quantity $quantity \
			 -price $price \
			 -width $width \
			 -height $height \
			 -depth $depth \
			 -weight $weight \
			 -volume $volume \
			 -dimensions $dimensions \
			 -creation_ip [ad_conn peeraddr] \
			 -creation_user [ad_conn user_id] \
			 -context_id [ad_conn package_id] \
			]
    }
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}
