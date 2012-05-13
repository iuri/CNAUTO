ad_page_contract {
    Resource admin page
} {
    {return_url ""}
    {parent_id ""}
    {category_type:optional}
    {category_id:integer,optional}
} -properties {
    context:onevalue
}


if {[exists_and_not_null category_id]} {
    set title "[_ cnauto-core.Edit_category]"
    set context [list $title]
} else {
    set title "[_ cnauto-core.Add_category]"
    set context [list $title]
}    

  

set parent_options [list]

if {[exists_and_not_null category_type]} {
    
    lappend parent_options [list [_ cnauto-core.Select] ""]

    db_foreach select_parent_info {
	SELECT pretty_name, category_id FROM cn_categories WHERE category_type = :category_type ORDER BY pretty_name
    } {
	lappend parent_options [list $pretty_name $category_id]
    }
}
    

ad_form -name category_ae -cancel_url $return_url -form {
    {category_id:key}
    {name:text(text)
	{label "[_ cnauto-core.Code]"}
	{mode "display"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-core.Name]"}
    }
    {category_type:text(select)
	{label "[_ cnauto-core.Type]"}
	{options {{"Selecione" ""} {"Part" cn_part} {"Person" cn_person} {"Order" cn_order}  {"Resource" cn_resource} {"Vehicle" cn_vehicle}}}
	{html {onChange "document.category_ae.__refreshing_p.value='1';document.category_ae.submit();"}}
	
    }
    {parent_id:integer(select),optional
	{label "[_ cnauto-core.Parent]"}
	{options $parent_options}
    }
} -on_request {


} -on_submit {
} -edit_request {

    db_1row category_info {
	SELECT name, pretty_name, category_type, parent_id 
	FROM cn_categories WHERE category_id = :category_id
    }

} -new_data {
    
    cn_categories::category::new \
	-pretty_name $pretty_name \
	-parent_id $parent_id \
	-category_type $category_type

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
	    category_type = :category_type
	    WHERE category_id = :category_id
	    
	}
    }
    
} -after_submit {
    
    ad_returnredirect $return_url
    ad_script_abort
}
