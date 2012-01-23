ad_page_contract {

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-26

} {
    {return_url ""}
}


ad_form -name order_add -form {
    {order_id:key}
    {name:text(text) 
	{label "[_ cnauto-import.Name]"}
    }
    {legal_name:text(text)
	{label "[_ cnauto-import.Legal_name]"}
    }
    {state_number:text
	{label "[_ cnauto-import.State_number]"}
    }
    {cnpj:text
	{label "[_ cnauto-import.CNPJ]"}
    }
    {importer_id:integer 
	{label "[_ cnauto-import.Importer]"}
    }
    {exporter_id:integer
	{label "[_ cnauto-import.Exporter]"}
    }
    {manufacturer_id:integer
	{label "[_ cnauto-import.Fabricant]"}
    }
    {postal_address:text(text)
	{label "[_ cnauto-import.Address]"}
    }
    {postal_address2:text(text)
	{label "[_ cnauto-import.Address]"}
    }
    {postal_code:text(text)
	{label "[_ cnauto-import.Postal_code]"}
    }
    {country_code:text(text)
	{label "[_ cnauto-import.Country]"}
    }
    {state_abbrev:text(text)
	{label "[_ cnauto-import.State]"}
    }
    {municipality:text(text)
	{label "[_ cnauto-import.Municipality]"}  
    }
    {email:text(text)
	{label "[_ cnauto-import.Email]"}
    }
    {phone:text(text)
	{label "[_ cnauto-import.Phone]"}
    }
    {notes:text(textarea)
	{label "[_ cnauto-import.Notes]"}
    }
} -on_submit {

    

} -after_submit {

    ad_returnredirect $return_url
    ad_scrit_abort
}
