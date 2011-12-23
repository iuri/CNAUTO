ad_page_contract {
    Shows person's info
} {
    {person_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-assurance.Person_info]

#set person_ae_url [export_vars -base person-ae {return_url person_id}]

ad_form -name person_one -action person-ae -export {return_url person_id} -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
        {value ""}
    }
    {cpf_cnpj:text(text)
	{label "[_ cnauto-asssurance.CPF_CNPJ]"}
    }
    {first_names:text(text)
	{label "[_ cnauto-asssurance.First_names]"}
    }
    {last_name:text(text)
	{label "[_ cnauto-assurance.Last_name]"}
    }	
    {type:text(text)
	{label "[_ cnauto-assurance.Type]"}
    }
    {email:text(text)
	{label "[_ cnauto-assurance.Email]"}
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
    {municipality:text(text)
	{label "[_ cnauto-assurance.Municipality]"}
    } 
    {country:text(text)
	{label "[_ cnauto-assurance.Country]"}
    } 
    {phone:text(text)
	{label "[_ cnauto-assurance.Phone]"}
    } 
} -on_request {
    
   
    db_1row select_vehicle_info {

	SELECT DISTINCT cp.cpf_cnpj, cp.first_names, cp.last_name, cp.type, cp.email, postal_address, cp.postal_address2, cp.postal_code, cp.state_abbrev AS state, cp.municipality, cp,country_code AS country, cp.phone FROM cn_persons cp WHERE cp.person_id = person_id

    }
} -on_submit {

    set myform [ns_getform]
    if {[string equal "" $myform]} {
	ns_log Notice "No Form was submited"
    } else {
	ns_log Notice "FORM"
	ns_set print $myform
    }
}