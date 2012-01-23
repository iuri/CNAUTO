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

set provider_options [cn_import::get_provider_options]

ad_form -name order_ae -form {
    {order_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-import.Order_info]</h2>"}
    }
    {code:text(text)
	{label "[_ cnauto-import.Code]"}
	{html {size 10} maxlength 10}
    }
    {provider_id:integer(select)
	{label "[_ cnauto-import.Provider]"}
	{options $provider_options}
    }
    {incoterm_value:text(text)
	{label "[_ cnaut-import.Incoterm_value]"}
    }
} -on_submit {

   

} -new_request {
     set provider_id 0
} -new_data {
    
    set incoterm_id [db_string select_incoterm_id {
	SELECT incoterm_id FROM cn_import_incoterms WHERE name = 'FOB'
    }]
    
    set order_id [cn_order::new \
		      -code $code \
		      -provider_id $provider_id \
		      -incoterm_id $incoterm_id \
		      -incoterm_value $incoterm_value \
		      -creation_ip [ad_conn peeraddr] \
		      -creation_user [ad_conn user_id] \
		      -context_id [ad_conn package_id] \
		     ]

    
} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



