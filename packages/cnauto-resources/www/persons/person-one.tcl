ad_page_contract {
    Shows person's info
} {
    {person_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-assurance.Person_info]

ns_log Notice "$return_url"

ad_form -name person_one -action person-ae -export {return_url person_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Company_info]</h2>"}
    }
    {cpf_cnpj:text(text)
	{label "[_ cnauto-asssurance.CPF_CNPJ]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-asssurance.Name]"}
    }
    {legal_name:text(text)
	{label "[_ cnauto-assurance.Legal_name]"}
    }	
    {type:text(text)
	{label "[_ cnauto-assurance.Type]"}
    }
    {inform2:text(inform)
        {label "<h2>[_ cnauto-assurance.Contact_info]</h2>"}
    }
    {email:text(text)
	{label "[_ cnauto-assurance.Email]"}
    } 
    {first_names:text(text),optional
	{label "[_ cnauto-resources.First_names]"}
    }
    {last_name:text(text),optional
	{label "[_ cnauto-resources.Last_names]"}
    }
    {phone:text(text)
	{label "[_ cnauto-assurance.Phone]"}
    } 
    {postal_address:text(text)
	{label "[_ cnauto-assurance.Postal_address]"}
    } 
    {postal_address2:text(text)
	{label "[_ cnauto-assurance.Postal_address]"}
    } 
    {postal_code:text(text)
	{label "[_ cnauto-assurance.Postal_code]"}
    } 
    {state:text(text)
	{label "[_ cnauto-assurance.State]"}
    } 
    {city:text(text)
	{label "[_ cnauto-assurance.Municipality]"}
    } 
    {country:text(text)
	{label "[_ cnauto-assurance.Country]"}
    }
} -on_request {
    
   
    db_1row select_person_info {
	
	SELECT DISTINCT cp.cpf_cnpj, cp.code, cp.legal_name, cp.pretty_name, cp.type_id, cc.pretty_name AS type, cp.email, postal_address, cp.postal_address2, cp.postal_code, bs.state_name AS state, bim.name AS city, c.default_name AS country, cp.phone, u.first_names, u.last_name 
	FROM cn_categories cc, br_states bs, br_ibge_municipality bim, countries c, cn_persons cp 
	LEFT OUTER JOIN cc_users u ON (u.user_id = cp.contact_id)
	WHERE cp.person_id = :person_id
	AND cp.type_id = cc.category_id
	AND cp.state_code = bs.abbrev
	AND cp.city_code = bim.ibge_code
	AND cp.country_code = c.iso
    }


    set person_ae_url [export_vars -base "person-ae" {person_id {type_id $type_id} return_url}]

} -on_submit {

    set myform [ns_getform]
    if {[string equal "" $myform]} {
	ns_log Notice "No Form was submited"
    } else {
	ns_log Notice "FORM"
	ns_set print $myform
    }
}




