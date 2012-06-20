ad_library {

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-06-14
}




namespace eval cn_resources::person {}
namespace eval cn_resources::persons {}


ad_proc -public cn_resources::person::get_type_options {} {
    Returns a list of type for an ad_form select widget
} {
    set types [list]

    lappend types [list [_ cnauto-resources.Select] ""]

    db_foreach select_types {
	SELECT pretty_name, category_id
	FROM cn_categories WHERE category_type = 'cn_person' ORDER BY pretty_name
    } {

        lappend types [list $pretty_name $category_id]
    }


    return $types
}




ad_proc -public cn_resources::persons::get_type_id {
    {-type}
} {
    Returns type_id 
} {
    
    return [db_string select_type_id {
	SELECT category_id 
	FROM cn_categories 
	WHERE object_type = 'cn_person' 
	AND name = :type
    }]
}



ad_proc -public  cn_resources::persons::import_persons {
    {-type_id}
    {-contact_id ""}
    {-input_file}
} {
    
    Imports CSV files to add assurance requires
} {

    ns_log Notice "Running ad_proc cn_assurance::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    foreach line $lines {
	if {![empty_string_p $line]} {

	    set line [split $line {;}] 
	    ns_log Notice "RAW LINE $line"
	    
	    set city [util_text_to_url -replacement "" -text [lindex $line 0]]
	    set city_code [db_string select_ibge_code {
		SELECT ibge_code, similarity(name, :city) AS bestmatch FROM br_ibge_municipality WHERE name % :city ORDER BY bestmatch DESC, name LIMIT 1
	    } -default ""]
	    
	    set state [lindex $line 1]
	    set state_code [db_string select_ibge_code {
		SELECT abbrev, similarity(abbrev, :state) AS bestmatch FROM br_states WHERE abbrev % :state ORDER BY bestmatch DESC, abbrev LIMIT 1
	    } -default ""]
	    
	    
	    set pretty_name [encoding convertto iso8859-1 [encoding convertfrom utf-8 [lindex $line 2]]]
	    set legal_name [encoding convertto iso8859-1 [encoding convertfrom utf-8 [lindex $line 3]]]
	    set cpf_cnpj [lindex $line 4]	
	    set state_registry [lindex $line 5]
	    set code [lindex $line 6]
	    
	    # Contact Name
	    set first_names ""
	    set contact_name [split [lindex $line 8] {" "}]
	    for {set i 0} {$i < [llength $contact_name]} {incr i} {
		lappend first_names [encoding convertto iso8859-1 [encoding convertfrom utf-8 [lindex $contact_name $i]]]
		
	    }
	    set last_name [lindex $contact_name $i]
	    if {[empty_string_p $last_name]} {
		set last_name $pretty_name
	    }
	    
	    set phone [lindex $line 9]
	    set postal_address [encoding convertto iso8859-1 [encoding convertfrom utf-8 [lindex $line 10]]]
	    set postal_code [lindex $line 11]
	    set email [lindex $line 12]
	    set country_code "BR"
	    
	    ns_log Notice "DADOS \n
	    $city_code \n
	    $state_code \n
	    $pretty_name \n
	    $legal_name \n
	    $cpf_cnpj \n
	    $state_registry \n
	    $code \n
	    $first_names \n
	    $last_name \n
	    $phone \n
	    $postal_address \n
	    $postal_code \n
	    $email \n
            $type_id
"
	    set exists_p [db_string select_cpf_cnpj {
		SELECT cpf_cnpj FROM cn_persons
		WHERE cpf_cnpj = :cpf_cnpj
	    } -default null]

	    if {$exists_p eq "null"} {
		
		set user_id [db_string select_user_id {
		    SELECT user_id FROM cc_users WHERE email = :email
		} -default ""]

		ns_log Notice "INSERT"   
		
		if {$user_id eq ""} {
		    set contact_id [db_nextval acs_object_id_seq]
		    ns_log notice "BREE \n $contact_id \n $email \n $first_names \n $last_name "
		    ns_log Notice "$first_names | $last_name"
	    
		    array set creation_info [auth::create_user \
						 -user_id $contact_id \
						 -email $email \
						 -first_names $first_names \
						 -last_name $last_name \
						]
		    
		    if { $creation_info(creation_status) ne "ok"} {
			ad_return_complaint 1 " The email: <b> $email </b> already exists on our database!"
		    }		
		} else {
		    set contact_id $user_id
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
		    -postal_code $postal_code \
		    -state_code $state_code \
		    -city_code $city_code \
		    -country_code $country_code \
		    -creation_ip [ad_conn peeraddr] \
		    -creation_user [ad_conn user_id] \
		    -context_id [ad_conn package_id]         	
	    }
	}	
    }
	
    return
}




ad_proc -public cn_resources::person::get_id {
    {-cpf_cnpj}
} {
    Returns person_id
} {


    return [db_string select_person_id {
	SELECT person_id FROM cn_persons WHERE cpf_cnpj = :cpf_cnpj
    } -default null]
}
    
ad_proc -public cn_resources::person::new {
    {-cpf_cnpj}
    {-legal_name ""}
    {-pretty_name ""}
    {-code ""}
    {-type_id ""}
    {-contact_id ""}
    {-email ""}
    {-phone ""}
    {-postal_address ""}
    {-postal_address2 ""}
    {-postal_code ""}
    {-state_code ""}
    {-city_code ""}
    {-country_code "BR"}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} {
    Add a new person

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-12-12

} {

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
    
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }



    ns_log Notice "
	-cpf_cnpj $cpf_cnpj \n
        -legal_name $legal_name \n
        -pretty_name $pretty_name \n
        -code $code \n
	-type_id $type_id \n
        -contact_id \n
	-email $email \n
	-phone $phone \n
	-postal_address $postal_address \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state_code $state_code \n
	-city_code $city_code \n
	-country_code $country_code \n
	-creation_ip $creation_ip \n
	-creation_user $creation_user \n 
	-context_id $context_id    
    "

    db_transaction {
	set person_id [db_exec_plsql insert_person {
	    SELECT cn_person__new (
				   :cpf_cnpj,
				   :legal_name,
				   :pretty_name,
				   :code,
				   :type_id,
				   :contact_id,
				   :email,
				   :phone,
				   :postal_address,
				   :postal_address2,
				   :postal_code,
				   :state_code,
				   :city_code,
				   :country_code,
				   :creation_ip,
				   :creation_user,
				   :context_id
				   );
	}]
    }

    return $person_id
    
}



ad_proc -public cn_resources::person::edit {
    {-person_id}
    {-cpf_cnpj}
    {-legal_name ""}
    {-pretty_name ""}
    {-code ""}
    {-type_id ""}
    {-contact_id ""}
    {-email ""}
    {-phone ""}
    {-postal_address ""}
    {-postal_address2 ""}
    {-postal_code ""}
    {-state_code ""}
    {-city_code ""}
    {-country_code "BR"}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} {
    Edit person info

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-12-12

} {

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
    
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }



    ns_log Notice "
	-cpf_cnpj $cpf_cnpj \n
        -legal_name $legal_name \n
        -pretty_name $pretty_name \n
        -code $code \n
	-type_id $type_id \n
        -contact_id \n
	-email $email \n
	-phone $phone \n
	-postal_address $postal_address \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state_code $state_code \n
	-city_code $city_code \n
	-country_code $country_code \n
	-creation_ip $creation_ip \n
	-creation_user $creation_user \n 
	-context_id $context_id    
    "

    db_transaction {
	db_exec_plsql update_person {
	    SELECT cn_person__edit (
				    :person_id,
				    :cpf_cnpj,
				    :legal_name,
				    :pretty_name,
				    :code,
				    :type_id,
				    :contact_id,
				    :email,
				    :phone,
				    :postal_address,
				    :postal_address2,
				    :postal_code,
				    :state_code,
				    :city_code,
				    :country_code
				    )
	}
    }
    
    
    
    return 
}



