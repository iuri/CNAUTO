ad_page_contract {

    Add/Edit resource
} {
    {resource_id:integer,optional}
    {class_id ""}
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

set class_options [db_list_of_lists select_classes {
    SELECT cc.pretty_name, cc.category_id
    FROM cn_categories cc 
    WHERE category_type = 'cn_resource' 
    AND parent_id IS NULL
}]

lappend class_options {"Selecione" 0}


ad_form -name resource_ae -cancel_url $return_url -form {
    {resource_id:key}
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
	{html {size 30} }
    }
    {pretty_name:text(text),optional
	{label "[_ cnauto-resources.Name]"}
	{html {size 50} }
    }
    {class_id:integer(select),optional
	{label "[_ cnauto-resources.Class]"}
	{options $class_options}
	{html {onChange "document.resource_ae.__refreshing_p.value='1';document.resource_ae.submit();"}}
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

if {[info exists class_id]} {
    set renavam_options [db_list_of_lists select_renavam {
	SELECT fabricant || ' ' || lcvm || ' ' || model || ' ' || version AS title, code FROM cn_renavam
    }]
    
    ad_form -extend -name resource_ae -form {
	{renavam_id:integer(select),optional
	    {label "[_ cnauto-resources.NCM]"}
	    {options $renavam_options}
	}	
    }
}

ad_form -extend -name resource_ae -new_request {
    set class_id 0
    
} -on_submit {
    
    
} -new_data {
    
    set resource_id [cn_resources::resource::new \
			 -code $code \
			 -pretty_name $pretty_name \
			 -description "" \
			 -class_id $class_id \
			 -unit $unit \
			 -creation_ip [ad_conn peeraddr] \
			 -creation_user [ad_conn user_id] \
			 -context_id [ad_conn package_id]
		    ]


} -edit_request {

    db_1row select_resource_info {	
	SELECT cr.code, cr.pretty_name, cc.pretty_name AS class, cr.unit, cr.ncm_class
	FROM cn_resources cr
	LEFT OUTER JOIN cn_categories cc
	ON (cc.category_id = cr.class_id)
	WHERE cr.resource_id = :resource_id
    }

} -edit_data {

    cn_resources::resource::edit \
	-resource_id $resource_id \
	-code_unum $code \
	-pretty_name $pretty_name \
	-description "" \
	-class_id $class_id \
	-unit $unit 
	    
} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}