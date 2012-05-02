ad_page_contract {

    Add/Edit resource
} {
    {resource_id:integer,optional}
    {type_id ""}
    {state_code ""}
    {return_url ""}
}

if {[exists_and_not_null resource_id]} {
    set title "[_ cnauto-resources.Edit_resource]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_resource]"
    set context [list $title]
}

set type_options [db_list_of_lists select_classes {
    SELECT cc.pretty_name, cc.category_id
    FROM cn_categories cc 
    WHERE category_type = 'cn_resource' 
    AND parent_id IS NULL
}]

lappend type_options {"Selecione" 0}


ad_form -name resource_ae -cancel_url $return_url -form {
    {resource_id:key}
    {type_id:integer(select),optional
	{label "[_ cnauto-resources.Type]"}
	{options $type_options}
	{html {onChange "document.resource_ae.__refreshing_p.value='1';document.resource_ae.submit();"}}
    }
}

 

if {[string equal [cn_categories::get_category_name -category_id $type_id] "veiculos"]} {
    set renavam_options [db_list_of_lists select_renavam {
	SELECT 
	CASE WHEN fabricant IS NOT NULL THEN fabricant ELSE '' END || ' ' || 
	CASE WHEN lcvm IS NOT NULL THEN lcvm ELSE '' END || ' ' || 
	CASE WHEN model IS NOT NULL THEN model ELSE '' END || ' ' || 
	CASE WHEN version IS NOT NULL THEN version ELSE '' END AS title, 
	code 
	FROM cn_vehicle_renavam
    }]
    
    ad_form -extend -name resource_ae -form {
	{code:text(select),optional
	    {label "[_ cnauto-resources.Renavam]"}
	    {options $renavam_options}
	}	
	{pretty_name:text(hidden)}
	{unit:text(select),optional
	    {label "[_ cnauto-resources.Unit]"}
	    {options { {"Selecione" ""} {"Un" "Un"} }}
	}
	{ncm:text(text),optional
	    {label "[_ cnauto-resources.NCM]"}
	    {html {size 30} }
	}    
    }
} else {
    ad_form -extend -name resource_ae -form {
	{code:text(text)
	    {label "[_ cnauto-resources.Code]"}
	    {html {size 30} }
	}
	{pretty_name:text(text),optional
	    {label "[_ cnauto-resources.Name]"}
	    {html {size 50} }
	}
	{unit:text(select),optional
	    {label "[_ cnauto-resources.Unit]"}
	    {options { {"Selecione" ""} {"Un" "Un"} }}
	}
	{ncm:text(text),optional
	    {label "[_ cnauto-resources.NCM]"}
	    {html {size 30} }
	}    
    }
}

ad_form -extend -name resource_ae -new_request {
    set type_id 0
    
} -on_submit {
    
    
} -new_data {

    if {[string equal [cn_categories::get_category_name -category_id $type_id] "veiculos"]} {
    
	set pretty_name [db_string select_mmv {
	    SELECT 
	    CASE WHEN fabricant IS NOT NULL THEN fabricant ELSE '' END || ' ' || 
	    CASE WHEN lcvm IS NOT NULL THEN lcvm ELSE '' END || ' ' || 
	    CASE WHEN model IS NOT NULL THEN model ELSE '' END || ' ' || 
	    CASE WHEN version IS NOT NULL THEN version ELSE '' END AS title
	    FROM cn_vehicle_renavam
	    WHERE code = :code
	}]
    }
    
    set resource_id [cn_resources::resource::new \
			 -code $code \
			 -pretty_name $pretty_name \
			 -type_id $type_id \
			 -unit $unit \
			 -creation_ip [ad_conn peeraddr] \
			 -creation_user [ad_conn user_id] \
			 -context_id [ad_conn package_id]
		    ]
    
    
} -edit_request {

    db_1row select_resource_info {	
	SELECT cr.code, cr.pretty_name, cr.type_id, cr.unit, cr.ncm_class
	FROM cn_resources cr
	LEFT OUTER JOIN cn_categories cc
	ON (cc.category_id = cr.type_id)
	WHERE cr.resource_id = :resource_id
    }

} -edit_data {

    cn_resources::resource::edit \
	-resource_id $resource_id \
	-code $code \
	-pretty_name $pretty_name \
	-type_id $type_id \
	-unit $unit 
    
    

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}