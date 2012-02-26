ad_page_contract {
    Resource admin page
} {
    {return_url ""}
    {object_type ""}
    {category_id:integer,optional}
} -properties {
    context:onevalue
}



if {[exists_and_not_null category_id]} {
    set title "[_ cnauto-resources.Edit_category]"
    set context [list $title]

} else {
    set title "[_ cnauto-resources.Add_category]"
    set context [list $title]
}    

set parent_options [db_list_of_lists select_parent_info {
    SELECT pretty_name, category_id FROM cn_categories WHERE object_type = :object_type ORDER BY pretty_name
}]


lappend parent_options "Selecione \"\""  

ad_form -name category_ae -form {
    {category_id:key}
    {name:text(text)
	{label "[_ cnauto-resouces.Code]"}
	{mode "display"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resouces.Name]"}
    }
    {object_type:text(select)
	{label "[_ cnauto-resouces.Type]"}
	{options {{"Selecione" 0} {"Part" cn_part} {"Person" cn_person} {"Order" cn_order}  {"Resource" cn_resource} {"Vehicle" cn_vehicle}}}
	{html {onChange "document.category_ae.__refreshing_p.value='1';document.category_ae.submit();"}}
	
    }
    {parent_id:integer(select),optional
	{label "[_ cnauto-resouces.Parent]"}
	{options $parent_options}
    }
} -on_request {
    set parent_id ""
} -on_submit {
} -edit_request {
    db_1row category_info {
	SELECT name, pretty_name, object_type 
	FROM cn_categories WHERE category_id = :category_id
    }
} -new_data {
    
    cn_core::category::new \
	-pretty_name $pretty_name \
	-parent_id $parent_id \
	-object_type $object_type

} -edit_data {

    set name [util_text_to_url -replacement "" -text $pretty_name]
    set package_id [ad_conn package_id]
    
    db_transaction {
	db_dml update_category {
	    UPDATE cn_categories SET 
	    package_id = :package_id,
	    parent_id = :parent_id,
	    pretty_name = :pretty_name,
	    name = :name,
	    object_type = :object_type
	    WHERE category_id = :category_id
	    
	}
    }
    
} -after_submit {
    
    ad_returnredirect $return_url
    ad_script_abort
}
