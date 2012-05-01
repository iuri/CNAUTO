ad_page_contract {

    Add/Edit renavam
} {
    {renavam_id:integer,optional}
    {return_url ""}
}

if {[exists_and_not_null renavam_id]} {
    set title "[_ cnauto-resources.Edit_renavam]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_renavam]"
    set context [list $title]
}

ad_form -name renavam_ae -cancel_url $return_url -form {
    {renavam_id:key}
    {fabricant:text(text),optional
	{label "[_ cnauto-resources.Fabricant]"}
	{html {size 30} }
    }
    {lcvm:text(text),optional
	{label "[_ cnauto-resources.LCVM]"}
	{html {size 30} }
    }
    {model:text(text),optional
	{label "[_ cnauto-resources.Model]"}
	{html {size 30} }
    }
    {version:text(text),optional
	{label "[_ cnauto-resources.Version]"}
	{html {size 30} }
    }
    {code:text(text),optional
	{label "[_ cnauto-resources.Code_renavam]"}
	{html {size 30} }
    }
    
} -on_submit {
    

} -new_data {

    set renavam_id [cn_resources::vehicle::renavam_new \
			-code $code \
			-fabricant $fabricant \
			-lcvm $lcvm \
			-model $model \
			-version $version \
		       ]
    
    
} -edit_request {

    db_1row select_renavam {
	SELECT renavam_id, fabricant, lcvm, model, version, code
	FROM cn_renavam
	WHERE renavam_id = :renavam_id
    }
    
} -edit_data {
    
    cn_resources::vehicle::renavam_edit \
	-renavam_id $renavam_id \
	-code $code \
	-fabricant $fabricant \
	-lcvm $lcvm \
	-model $model \
	-version $version 
    
} -after_submit {
    
    ad_returnredirect $return_url
    ad_script_abort
}