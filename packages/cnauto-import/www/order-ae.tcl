ad_page_contract {
    
    Add/Edit Import Order

} {
    {order_id:integer,optional}
    {return_url ""}
}


if { [exists_and_not_null order_id] } {
    set page_title [_ cnauto-import.Edit_order]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-import.Add_order]
    #set ad_form_mode edit
}


set return_url [ad_return_url]
set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}] 
set person_ae_url [export_vars -base "person-ae" {return_url}] 


ad_form -name order_ae -form {
    {order_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-import.Order_info]</h2>"}
    }
    {code:text(text)
	{label "[_ cnauto-import.Code]"}
	{html {size 5} maxlength 10}
    }
    {provider_id:integer
	{label "[_ cnauto-import.Provider]"}
    }
    {type_id:integer(hidden)
	{value ""}
    }
    {incoterm_id:integer(hidden)
	{value ""}
    }
    {incoterm_value:text(text)
	{label "[_ cnaut-import.Incoterm_value]"}
    }
} -on_submit {
} -new_data {
    
} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



