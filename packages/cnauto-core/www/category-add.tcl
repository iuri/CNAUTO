ad_page_contract {
    Resource admin page
} {
    {return_url ""}
    {category_id:integer,optional}
}


set title "[_ cnauto-resources.Add_category]"
set context [list $title]


ad_form -name category_ae -form {
    {category_id:key}
    {pretty_name:text(text)
	{label "[_ cnauto-resouces.Name]"}
    }
    {object_type:text(select)
	{label "[_ cnauto-resouces.Type]"}
	{options {{"Person" cn_person}}}
    }
} -on_submit {
} -new_data {
    
    set category_id [db_nextval acs_object_id_seq]
    set name [cn_core::util::treat_string -str $pretty_name]
    set package_id [ad_conn package_id]

    db_transaction {
	    db_dml insert_category {
		INSERT INTO cn_categories (
		   category_id,
		   package_id,
		   pretty_name,
		   name,
		   object_type
		) VALUES (
		     :category_id,
		     :package_id,
		     :pretty_name,
		     :name,
		     :object_type
		)
	    }
	}
	
} -after_submit {
    
    ad_returnredirect $return_url
    ad_script_abort
}
