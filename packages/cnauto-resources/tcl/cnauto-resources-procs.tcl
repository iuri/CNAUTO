
ad_library {
    CN Auto Resources API
}


namespace eval cn_resources {}

namespace eval cn_resources::resource {}


ad_proc -public cn_resources::get_resource_id {
    {-code:required}
} {

    Gets resource_id 
} {
    
    return [db_string select_resource_id {
	SELECT resource_id FROM cn_resources WHERE code = :code
    } -default null]

}


ad_proc -public cn_resources::resource::delete {
    resource_id
} {
    Delete a resource
} {

    db_transaction {
	
	db_exec_plsql delete_resource {
	    SELECT cn_resource__delete ( :resource_id )
	}
    }
    
    return 
}

ad_proc -public cn_resources::resource::edit {
    {-resource_id:required}
    {-code ""}
    {-pretty_name ""}
    {-description ""}
    {-type_id:required}
    {-ncm_class ""}
    {-unit ""}
} {
    Edit resource info
} {


    set name [util_text_to_url -replacement "" -text $pretty_name]

    db_exec_plsql update_resource {
	SELECT cn_resource__edit (
				  :resource_id,
				  :code,
				  :name,
				  :pretty_name,
				  :description,
				  :type_id,
				  :ncm_class,
				  :unit
				  )
    }

    return
}




ad_proc -public cn_resources::resource::new {
    {-code ""}
    {-name ""}
    {-pretty_name ""}
    {-description ""}
    {-type_id:required}
    {-ncm_class ""}
    {-unit ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    Creates a new resoruce and returns its resource_id
} {

    if {$name == ""} {
	set name [util_text_to_url -replacement "" -text $pretty_name]
    }

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
     
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }

    db_transaction {
	set resource_id [db_exec_plsql insert_resource {
	    SELECT cn_resource__new (
				     :code,
				     :name,
				     :pretty_name,
				     :description,
				     :type_id,
				     :ncm_class,
				     :unit,
				     :creation_ip,
				     :creation_user,
				     :context_id
				     )
	}]
    }

    return $resource_id
}



ad_proc -public  cn_resources::import_resources {
    {-input_file:required}
} {

    Imports CSV files to add resources
} {

    ns_log Notice "Running ad_proc cn_resources::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    foreach line $lines {
	set line [split $line {;}] 
	
	ns_log Notice "LINE $line"

	if {$line ne ""} {
	    ns_log Notice "LINE 3 $line"
	    set code_unum [lindex $line 0]
	    
	    set exists_p [db_string select_code {
		SELECT code FROM cn_resources WHERE code = :code
	    } -default null]
	    
	    if {$exists_p == "null"} {
		set pretty_name [lindex $line 1]
		set color [lindex $pretty_name 1]
		
		set class [lindex $line 2]
		
		set unit [lindex $line 3]
		set ncm [lindex $line 4]
		
		ns_log Notice "ADD RESOURCE $code | $pretty_name | $class_id | $ncm | $unit"
		cn_resources::resource::new \
		    -code_unum $code \
		    -pretty_name $pretty_name \
		    -class_id $class_id \
		    -ncm_class $ncm \
		    -unit $unit \
		    -renavam_id ""
	    }
	}
    }	

    return
}




namespace eval cn_resources::part {}

ad_proc -public cn_resources::part::delete {
    part_id
} {
    Delete a part
} {

    db_transaction {
	
	db_exec_plsql delete_part {
	    SELECT cn_part__delete ( :part_id )
	}
    }
    
    return 
}

ad_proc -public cn_resources::part::edit {
    {-part_id:required}
    {-code:required}
    {-name ""}
    {-pretty_name ""}
    {-resource_id ""}
    {-model_id ""}
    {-quantity ""}
    {-price ""}
    {-width ""}
    {-height ""}
    {-depth ""}
    {-weight ""}
    {-volume ""}
    {-dimensions ""}
} {
    
    Edits part 
} {
    
    db_transaction {
	db_exec_plsql update_part {
	    SELECT cn_part__edit (
				  :part_id,
				  :code,
				  :name,
				  :pretty_name,
				  :resource_id,
				  :model_id,
				  :quantity,
				  :price,
				  :width,
				  :height,
				  :depth,
				  :weight,
				  :volume,
				  :dimensions
				  )
	}
    }		     

    return
}



ad_proc -public cn_resources::part::new {
    {-code:required}
    {-name ""}
    {-pretty_name ""}
    {-resource_id ""}
    {-model_id ""}
    {-quantity ""}
    {-price ""}
    {-width ""}
    {-height ""}
    {-depth ""}
    {-weight ""}
    {-volume ""}
    {-dimensions ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    
    Adds a new part 
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

    db_transaction {
	set part_id [db_exec_plsql insert_part {
	    SELECT cn_part__new (
				 :code,
				 :name,
				 :pretty_name,
				 :resource_id,
				 :model_id,
				 :quantity,
				 :price,
				 :width,
				 :height,
				 :depth,
				 :weight,
				 :volume,
				 :dimensions,
				 :context_id,
				 :creation_user,
				 :creation_ip
				 )
	}]	
    }
    
    return $part_id
}



ad_proc -public cn_resources::get_city_code {
    {-city $city}
} {
    Returns city's code
} {

    set city [lindex [split $city "-"] 0]
    set city [util_text_to_url -replacement "" -text $city]

    # WHERE name like [lindex city 0]
    set cities [db_list_of_lists select_city_info {
	SELECT ibge_code, name FROM br_ibge_municipality ORDER BY name
    } ]

    foreach element $cities {
	
	set name [util_text_to_url -replacement "" -text [lindex $element 1]]
	
	#ns_log Notice "[lindex $element 0] | $name | $city"
	
	if {[string equal $name $city]} {
	    return [lindex $element 0]

	}
    }
    
    return ""
}

ad_proc -public cn_resources::get_state_code {
    {-state $state}
} {
    Returns state's code
} {

    
    set state [util_text_to_url -replacement "" -text $state]

    # WHERE name like [lindex state 0] -- optimize the query with the first letter of the word
    set states [db_list_of_lists select_state_info {
	SELECT abbrev, state_name FROM br_states 
    }]
    
    foreach element $states {
	
	set abbrev [util_text_to_url -replacement "" -text [lindex $element 0]]
	set state_name [util_text_to_url -replacement "" -text [lindex $element 1]]
	
	#ns_log Notice "$state | $abbrev | $state_name"
	if {[string equal $abbrev $state] || [string equal $state_name $state]} {
	    return [lindex $element 0]
	}
    }
    
    return ""
}

ad_proc -public cn_resources::get_country_code {
    {-country $country}
} {
    Returns country's code
} {

    
    set country [util_text_to_url -replacement "" -text $country]

    # WHERE name like [lindex city 0]
    set countries [db_list_of_lists select_country_info {
	SELECT iso, default_name FROM countries 
    }]
    

    foreach element $countries {
	
	set iso_aux [util_text_to_url -replacement "" -text [lindex $element 0]]
	set default_name_aux [util_text_to_url -replacement "" -text [lindex $element 1]] 
			      
	#ns_log Notice "$country | $default_name_aux | $iso_aux"
	if {[string equal $country $default_name_aux] || [string equal $country $iso_aux]} {
	    return [lindex $element 0]
	}
    }
    
    
    return ""
}



ad_proc -public cn_resources::get_state_options {} {
    Returns a list of states for an ad_form select widget
} {

    set states [list]
    lappend $states [list [_ cnauto-resources.Select] ""]

    db_foreach select_states {
	SELECT state_name, abbrev FROM br_states ORDER BY state_name 
    } {
	lappend $states [list $state_name $abbrev]
    }

    return $states

}


ad_proc -public cn_resources::get_city_options {} {
    Returns a list of cities for an ad_form select widget
} {

    set cities [list]
    lappend $cities [list [_ cnauto-resources.Select] ""]

    db_foreach select_cities {
	SELECT name, ibge_code FROM br_ibge_municipality ORDER BY name
    } {
	lappend $cities [list $name $ibge_code]
    }

    return $cities

}




namespace eval cn_resources::person {}

ad_proc -public cn_resources::person::get_type_options {} {
    Returns a list of type for an ad_form select widget
} {
    set types [list]

    lappend $types [list [_ cnauto-resources.Select] ""]

    db_foreach select_types {
	SELECT pretty_name, category_id
	FROM cn_categories WHERE category_type = 'cn_person' ORDER BY pretty_name
    } {

        lappend types [list $pretty_name $category_id]
    }


    return $types
}












namespace eval cn_resources::categories {}

ad_proc -public  cn_resources::categories::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add categories
} {

    ns_log Notice "Running ad_proc cn_resources::categories::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    set package_id [ad_conn package_id]
    set object_type "cn_person"
    
    foreach line $lines {
	set line [split $line {,}] 
	ns_log Notice "LINE $line"
	
	set category_id [db_nextval acs_object_id_seq]
	set pretty_name [lindex $line 0]
	set name [util_text_to_url -replacement "" -text [lindex $line 0]]
	
	
	#ns_log notice "[llength $name] - $name"

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
	
    }
    
    return
}


namespace eval cn_resources::persons {}


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

ad_proc -public  cn_resources::persons::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add assurance requires
} {

    ns_log Notice "Running ad_proc cn_assurance::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    
    foreach line $lines {
	set line [split $line {;}] 

	if {$line != ""} {  
	    ns_log Notice "LINE $line"
	
	# 0 codigo
	# 1 first_name/last_name - corporate_name/legal_name
	# 2 type concessionarias / CNAUTO / Funcionarios / Diretores / 
	# 3 pais
	# 4 CEP
	# 5 estado
	# 6 cidade
	# 7 bairro 8 9 10 11
	# 12 TELEFONE
	# 13 Email


	    set code [lindex $line 0]
	    set pretty_name [lindex $line 1]
	    set legal_name ""
	    set contact_id ""
	    set type [lindex $line 2]
	    
	    set type [util_text_to_url -replacement "" -text $type]
	    ns_log Notice "TYPE $type"
	    set type_id [cn_resources::persons::get_type_id -type $type]
	    
	    
	    set country [lindex $line 3]
	    set country_code [cn_resources::get_country_code -country $country]
	    
	    set postal_code [lindex $line 4]
	    
	    set state [lindex $line 5]
	    set state_code [cn_resources::get_state_code -state $state]
	    
	    set city [lindex $line 6]
	    set city_code [cn_resources::get_city_code -city $city]
	    
	    set postal_address "[lindex $line 8] [lindex $line 9] [lindex $line 10] [lindex $line 7]"
	    set postal_address2 [lindex $line 11]
	    set phone [lindex $line 12]
	    set email [lindex $line 13]
	    
	    
	    set cpf_cnpj [lindex $line 14]
	    if {[string equal $cpf_cnpj "000.000.000-00"] || [string equal $cpf_cnpj "000.000.000/0000-00"]} {
		set cpf_cnpj ""
	    }
	    
	    ns_log Notice "
	-cpf_cnpj $cpf_cnpj \n
        -pretty_name $pretty_name \n
        -legal_name $legal_name \n
        -code $code \n
	-type_id $type_id \n
        -contact_id $contact_id \n
	-email $email \n
	-phone $phone \n
	-postal_address $postal_address \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state_code $state_code \n
	-city_code $city_code \n
	-country_code $country_code \n
    "
	    
	    set exists_p [db_string select_cpf_cnpj {
		SELECT cpf_cnpj FROM cn_persons
		WHERE cpf_cnpj = :cpf_cnpj
	    } -default null]
	    
	    ns_log Notice "TEST $exists_p | CNPJ $cpf_cnpj"
	    
	    if {$exists_p == "null"} {
		ns_log Notice "INSERT"
		

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
	    }
	}
    }	

    return
}

namespace eval cn_resources::person {}
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

