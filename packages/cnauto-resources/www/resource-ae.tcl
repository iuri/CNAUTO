ad_page_contract {

    Add/Edit resource
} {
    {resource_id:integer,optional}
    {type_id ""}
    {state_code ""}
    {return_url ""}
}

if {[exists_and_not_null person_id]} {
    set title "[_ cnauto-resources.Edit_resource]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_resource]"
    set context [list $title]
}

set class_options [db_list_of_lists select_classes {
    SELECT cc.pretty_name, cc.category_id
    FROM cn_categories cc 
    WHERE object_type = 'cn_resource' 
}]


ad_form -name resource_ae -form {
    {resource_id:key}
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {class_id:integer(select)
	{label "[_ cnauto-resources.Class]"}
	{options $class_options}
    }
    {unit:text(select)
	{label "[_ cnauto-resources.Unit]"}
	{options { {"Selecione" ""} {"Un" "Un"} }}
    }
} -on_submit {


} -new_data {
    
    set resource_id [cn_resource::resource::new \
			 -code $code \
			 -name $name \
			 -pretty_name $pretty_name \
			 -description "" \
			 -class_id $class_id \
			 -unit $unit]

} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort
}