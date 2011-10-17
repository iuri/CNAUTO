ad_page_contract {
    Create a new email in newsletter_id list

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-17
} {
    newsletter_id
    {return_url ""}
}


newsletters::email::new -name $email -email $email -newsletter_id $newsletter_id
set fields [newsletters::fields::get_list -newsletter_id $newsletter_id]
foreach field $fields {
    util_unlist $field field_id field_name
    newsletters::data::new -field_id $field_id -data $name -email $email
}

    
ad_returnredirect -message "Usuário cadastrado com Sucesso." "newsletter-items?newsletter_id=$newsletter_id"
ad_script_abort




	
