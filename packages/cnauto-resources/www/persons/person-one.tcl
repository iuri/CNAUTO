ad_page_contract {
    Shows person's info
} {
    {person_id:integer,optional}
    {type_id:integer,optional}
    {email ""}
    {return_url ""}
}

set page_title [_ cnauto-assurance.Person_info]

if {[info exists person_id]} {
    set type_id [db_string select_type_id {
	SELECT type_id FROM cn_persons WHERE person_id = :person_id
    }]
}

ns_log Notice "$return_url"

ad_form -name person_one -action person-ae -export {return_url person_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Company_info]</h2>"}
    }
    {cpf_cnpj:text(text)
	{label "[_ cnauto-resources.CPF_CNPJ]"}
    }
    {pretty_name:text(text)
	{label "[_ cnauto-resources.Name]"}
    }
    {legal_name:text(text)
	{label "[_ cnauto-resources.Legal_name]"}
    }	
    {type:text(text)
	{label "[_ cnauto-resources.Type]"}
    }
    {inform2:text(inform)
	{label "<h2>[_ cnauto-resources.Contact_info]</h2>"}
    }
    {email:text(text)
	{label "[_ cnauto-resources.Email]"}
    }

}

set type [db_string select_type {
    SELECT name FROM cn_categories WHERE category_id = :type_id
} -default null]


if {$type != "pessoafisica"} {

    ad_form -extend -name person_one -form {
	{first_names:text(text),optional
	    {label "[_ cnauto-resources.First_names]"}
	}
	{last_name:text(text),optional
	    {label "[_ cnauto-resources.Last_names]"}
	}
    }
}

ad_form -extend -name person_one -form {
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
    {state:text(text)
	{label "[_ cnauto-resources.State]"}
    } 
    {city:text(text)
	{label "[_ cnauto-resources.Municipality]"}
    } 
    {country:text(text)
	{label "[_ cnauto-resources.Country]"}
    }
}

ad_form -extend -name person_one -on_request {
    
   
    db_1row select_person_info {
	
	SELECT DISTINCT cp.cpf_cnpj, cp.code, cp.legal_name, cp.pretty_name, cp.type_id, cc.pretty_name AS type, cp.email, postal_address, cp.postal_address2, cp.postal_code, bs.state_name AS state, bim.name AS city, c.default_name AS country, cp.phone, u.first_names, u.last_name 
	FROM cn_categories cc, cn_persons cp 
	LEFT OUTER JOIN cc_users u ON (u.user_id = cp.contact_id)
	LEFT OUTER JOIN br_states bs ON (cp.state_code = bs.abbrev)
	LEFT OUTER JOIN br_ibge_municipality bim ON (cp.city_code = bim.ibge_code)
	LEFT OUTER JOIN countries c ON (cp.country_code = c.iso)
	WHERE cp.person_id = :person_id
	AND cp.type_id = cc.category_id
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




