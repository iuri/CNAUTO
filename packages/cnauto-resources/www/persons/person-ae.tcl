ad_page_contract {

    Add/Edit person
} {
    {person_id:integer,optional}
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


if {[exists_and_not_null state_code]} {
    set where_clause1 "WHERE abbrev = :state_code"
} else {
    set where_clause1 " "
}



if {[exists_and_not_null state_code]} {
    set where_clause2 "WHERE state_code = :state_code"
} else {
    set where_clause2 " "
}

set state_options [db_list_of_lists select_state_info "
    SELECT state_name, abbrev FROM br_states $where_clause1 ORDER BY state_name 
"]


set city_options [db_list_of_lists select_city_info "
    SELECT name, ibge_code FROM br_ibge_municipality $where_clause2 ORDER BY name
"]
       

set type_options [db_list_of_lists select_types {
	SELECT pretty_name, category_id
	FROM cn_categories WHERE object_type = 'cn_person' ORDER BY pretty_name
}]
    

ad_form -name person_ae -form {
    {person_id:key}
    {inform1:text(inform)
	    {label "<b>[_ cnauto-resources.Company_info]</b>"}
    }
    {cpf_cnpj:text(text)
	{label "[_ cnauto-resources.CPF_CNPJ]"}
    }
    {legal_name:text(text)
	{label "[_ cnauto-resources.Legal_name]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
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

if {$type_id != ""} {
    ad_form -extend -name person_ae -form {
	{inform2:text(inform)
	    {label "<b>[_ cnauto-resources.Contact_info]</b>"}
	}
	{email:text(text),optional
	    {label "[_ cnauto-resources.Email]"}
	}
 	{first_names:text(text),optional
	    {label "[_ cnauto-resources.First_names]"}
	}
	{last_name:text(text),optional
	    {label "[_ cnauto-resources.Last_names]"}
	}
	{phone:text(text),optional
	    {label "[_ cnauto-resources.Phone]"}
	}
	{postal_address:text(text),optional
	    {label "[_ cnauto-resources.Postal_address]"}
	}
	{postal_address2:text(text),optional
	    {label "[_ cnauto-resources.Postal_address]"}
	}
	{postal_code:text(text),optional
	    {label "[_ cnauto-resources.Postal_code]"}
	}
	{state_code:text(select),optional
	    {label "[_ cnauto-resources.State]"}
	    {options $state_options}
	    {html {onChange "document.person_ae.__refreshing_p.value='1';document.person_ae.submit();"}}
	}
	{city_code:text(select),optional
	    {label "[_ cnauto-resources.City_names]"}
	    {options $city_options}
	}
	{country_code:text(select),optional
	    {label "[_ cnauto-resources.Country]"}
	    {options {{"Select" ""} {"Brazil" "BR"} {"Foreign Country" "EX"}}}
	}
    }
}

ad_form -extend -name person_ae -form {
    {return_url:text(hidden)
	{value $return_url}
    }
} -on_submit {
} -edit_request {

    db_1row select_person_info {


	SELECT DISTINCT cp.cpf_cnpj, cp.code, cp.legal_name, cp.pretty_name, cc.pretty_name AS type, cp.email, postal_address, cp.postal_address2, cp.postal_code, cp.state_code, cp.city_code, cp.country_code, cp.phone, u.first_names, u.last_name 
	FROM cn_categories cc, cn_persons cp 
	LEFT OUTER JOIN cc_users u ON (u.user_id = cp.contact_id)
	WHERE cp.person_id = :person_id
	AND cp.type_id = cc.category_id
    }
} -edit_data {

    cn_resources::person::edit \
	-cpf_cnpj $cpf_cnpj \
	-legal_name $legal_name \
	-pretty_name $pretty_name \
	-code $code \
	-type_id $type_id \
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

    catch {
	email_image::edit_email_image \
	    -user_id $contact_id \
	    -new_email $email
    } errmsg

    acs_user::get -user_id $contact_id -array user

    set user_info(authority_id) $user(authority_id)
    set user_info(email) $email
    set user_info(first_names) $first_names
    set user_info(last_name) $last_name
    set user_info(username) [util_text_to_url  -replacement "" -text "${first_names} ${last_name}"]


    auth::update_local_account \
	-authority_id $contact_id \
	-username $username \
	-array user_info]



} -new_data {
    
    
    if {$email != ""} {
	
	set contact_id [db_nextval acs_object_id_seq]
	
	array set creation_info [auth::create_user \
				     -user_id $contact_id \
				     -email $email \
				     -first_names $first_names \
				     -last_name $last_name \
				    ]	
    } else {
	set contact_id ""
    }

    
    
    
    
    cn_resources::person::new \
	-cpf_cnpj $cpf_cnpj \
	-legal_name $legal_name \
	-pretty_name $pretty_name \
	-code $code \
	-type_id $type_id \
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
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}
