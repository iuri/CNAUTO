ad_page_contract {

    @author Iuri Sampaio (iuri.sampaio@gmail.com)
    @creation-date 2011-06-14
} {
    { email ""}
    { return_url ""}
}

ns_log Notice "REUTURN 1 $return_url"
    
ad_form -name user -cancel_url $return_url -form {
    {email:text
	{label "[_ newsletter.Email]"}
	{value $email}
	{mode display}
    }
}




db_foreach select_fields {
    SELECT nd.field_id, nd.data, nf.name 
    FROM newsletters_data nd, newsletters_fields nf 
    WHERE nf.field_id = nd.field_id AND email = :email
} {
    ad_form -extend -name user -form { 
	{$field_id:text
	    {label $name}
	    {value $data}
	}
    }
}


ad_form -extend -name user -form { 
    {return_url:text(hidden)
	{value $return_url}
    }
} -on_submit {
    
    set fields [db_list select_fields {
	SELECT field_id FROM newsletters_data WHERE email = :email
    }] 
    
    foreach field $fields {
	set value ":${field}"

	db_dml update_user "
	    UPDATE newsletters_data SET data = $value WHERE field_id = $field AND email = :email"
    }
} -after_submit {

    ad_returnredirect $return_url
    ad_script_abort

}
