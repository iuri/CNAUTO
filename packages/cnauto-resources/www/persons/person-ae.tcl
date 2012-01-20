ad_page_contract {

    Add/Edit person
} {
    {person_id ""}
    {type_id ""}
    {state_code ""}
    {return_url ""}
}

if {[exists_and_not_null person_id]} {
    set title "[_ cnauto-resources.Edit_person]"
    set context [list $title]
} else {
    set title "[_ cnauto-resources.Add_person]"
    set context [list $title]
}



set state_options [db_list_of_lists select_state_info {
    SELECT state_name, abbrev FROM br_states  
}]



if {[exists_and_not_null state_code]} {
    set where_clause "WHERE state_code = :state_code"
} else {
    set where_clause " "
}

set city_options [db_list_of_lists select_city_info "
    SELECT name, ibge_code FROM br_ibge_municipality $where_clause
"]
       

set type_options [db_list_of_lists select_types {
    SELECT pretty_name, category_id
    FROM cn_categories WHERE object_type = 'cn_person'
}]


ad_form -name person_ae -cancel_url $return_url -form {
    {person_id:key}
    {inform1:text(inform)
	{label "<b>[_ cnauto-resources.Person_Info]</b>"}
    }
    {first_names:text(text)
	{label "[_ cnauto-resources.First_names]"}
    }
    {last_name:text(text)
	{label "[_ cnauto-resources.Last_names]"}
    }
    {email:text(text)
	{label "[_ cnauto-resources.Email]"}
    }
    {code:text(text)
	{label "[_ cnauto-resources.Code]"}
    }
    {type_id:integer(select)
	{label "[_ cnauto-resources.Type]"}
	{options $type_options}
	{html {onChange "document.person_ae.__refreshing_p.value='1';document.person_ae.submit();"}}
    }
}

if {[exists_and_not_null type_id] } {
    ad_form -extend -name person_ae -form {
	{inform2:text(inform)
	    {label "<b>[_ cnauto-resources.Company_info]</b>"}
	}
	{cpf_cnpj:text(text)
	    {label "[_ cnauto-resources.CPF_CNPJ]"}
	}
	{legal_name:text(text)
	    {label "[_ cnauto-resources.Legal_name]"}
	}
	{corporate_name:text(text)
	    {label "[_ cnauto-resources.Corporate_name]"}
	}

    }
}





ad_form -extend -name person_ae -form {
    {inform3:text(inform)
	{label "<b>[_ cnauto-resources.Contact_info]</b>"}
    }
    {phone:text(text)
	{label "[_ cnauto-resources.Phone]"}
    }
    {postal_address:text(text)
	{label "[_ cnauto-resources.Postal_address]"}
    }
    {postal_address2:text(text)
	{label "[_ cnauto-resources.Postal_address]"}
    }
    {postal_code:text(text)
	{label "[_ cnauto-resources.Postal_code]"}
    }
    {state_code:text(select)
	{label "[_ cnauto-resources.State]"}
	{options $state_options}
	{html {onChange "document.person_ae.__refreshing_p.value='1';document.person_ae.submit();"}}
    }
    {city_code:text(select)
	{label "[_ cnauto-resources.City_names]"}
	{options $city_options}
    }
    {country_code:text(select)
	{label "[_ cnauto-resources.Country]"}
	{options {{"Select" ""} {"Brazil" "BR"} {"Foreign Country" "EX"}}}
    }
} -on_submit {
} -new_data {

	cn_resources::person::new \
	    -cpf_cnpj $cpf_cnpj \
	    -legal_name $legal_name \
	    -corporate_name $corporate_name \
	    -code $code \
	    -type $type \
	    -contact_id $contact_id \
	    -email $email \
	    -phone $phone \
	    -postal_address $postal_address \
	    -postal_address2 $postal_address2 \
	    -postal_code $postal_code \
	    -state_code $state_code \
	    -city_code $city_code \
	    -country_code $country_code \
	    -creation_ip [ad_conn peeraddr] \
	    -creation_user [ad_conn user_id] \
	    -context_id [ad_conn package_id]         	
    

} -edit_request {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}