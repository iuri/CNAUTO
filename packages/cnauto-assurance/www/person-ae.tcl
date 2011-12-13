ad_page_contract {
    Add/Edit person
} {
    {person_id:integer,optional}
    {state ""}
    {return_url ""}
}


if { [exists_and_not_null person_id] } {
    set page_title [_ cnauto-assurance.Edit_Person]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_Person]
    #set ad_form_mode edit
}

set where_clause ""
if {[exists_and_not_null state]} {
    set where_clause "WHERE state_code = :state"
}


set municipality_options [db_list_of_lists select_municipality "
    SELECT name, ibge_code FROM br_ibge_municipality $where_clause ORDER BY name
"]

set state_options [db_list_of_lists select_states { SELECT state_name, abbrev FROM br_states }]


ad_form -name person_ae -form {
    {person_id:key}
    {return_url:text(hidden)
	{value $return_url}
    }
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Person_info]</h2>"}
        {value ""}
    }
    {first_names:text(text)
	{label "[_ cnauto-assurance.First_name]"}
	{html {size 30} maxlength 30}
    }
    {last_name:text(text)
	{label "[_ cnauto-assurance.Last_name]"}
	{html {size 30} maxlength 30}
    }
    {email:text(text)
	{label "[_ cnauto-assurance.Email]"}
	{html {size 20} maxlength 30}
    }	
    {cpf_cnpj:text(text)
	{label "[_ cnauto-assurance.CPF_CNPJ]"}
	{html {size 20} maxlength 15}
    }	
    {type:integer(select)
	{label "[_ cnauto-assurance.Type]"}
	{options {{"Select" 0} {"Client" 1}}}
    }	
    {phone:text(text)
	{label "[_ cnauto-assurance.Phone]"}
	{html {size 20} maxlength 15}
    }	
    {postal_address:text(text)
	{label "[_ cnauto-assurance.Postal_address]"}
	{html {size 60} maxlength 255}
    }
    {postal_address2:text(text)
	{label "[_ cnauto-assurance.Postal_address2]"}
	{html {size 60} maxlength 255}
    }
    {postal_code:text(text)
	{label "[_ cnauto-assurance.Postal_code]"}
	{html {size 10} maxlength 50}
    }
    {state:text(select)
	{label "[_ cnauto-assurance.State]"}
	{options $state_options}
	{html {onChange "document.person_ae.__refreshing_p.value='1';document.person_ae.submit()"}}
    }
    {municipality_code:text(select)
	{label "[_ cnauto-assurance.Countries]"}
	{options $municipality_options}
    }
    {country_code:text(hidden)
	{value "BR"}
    }
    
} -on_submit {
    
} -new_data {
    
    db_transaction {
	
	cn_assurance::person::new \
	    -cpf_cnpj $cpf_cnpj \
	    -first_names $first_names \
	    -last_name $last_name \
	    -email $email \
	    -type $type \
	    -phone $phone \
	    -postal_address $postal_address \
	    -postal_address2 $postal_address2 \
	    -postal_code $postal_code \
	    -state $state \
	    -municipality $municipality_code \
	    -country_code $country_code \
	    -creation_ip [ad_conn peeraddr] \
	    -creation_user [ad_conn user_id] \
	    -context_id [ad_conn package_id]
    
    }
}