ad_library {
    CN Auto Resources API
}


namespace eval cn_resources {}
namespace eval cn_resources::vehicle {}


ad_proc -public cn_resources::vehicle::new { 
    {-chassis}
    {-model}
    {-year_of_model ""}
    {-year_of_fabrication ""}
    {-engine ""}
    {-color ""}
    {-arrival_date ""}
    {-billing_date ""}
    {-purchase_date ""}
    {-duration ""}
    {-distributor_code ""}
    {-person_id ""}
    {-notes ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    Add a new vehicle 
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


   #set vehicle_id [db_nextval acs_object_id_seq]
	
    set vehicle_id [db_exec_plsql insert_vehicle {
	SELECT cn_vehicle__new (
				null,
				:chassis,
				:engine,
				:model,
				:year_of_model,
				:year_of_fabrication,
				:color,
				:purchase_date,
				:arrival_date,	
				:billing_date,
				:duration,
				:distributor_code,
				:person_id,
				:notes,
				:creation_ip,
				:creation_user,
				:context_id
				)
    }]
    
    return $vehicle_id
}



ad_proc -public cn_resources::get_city_code {
    {-city $city}
} {
    Returns city's code
} {

    set city [lindex [split $city "-"] 0]
#    set city [cn_core::util::treat_string -str $city]

    # WHERE name like [lindex city 0]
    db_foreach select_city_info {
	SELECT ibge_code, name FROM br_ibge_municipality ORDER BY name
    } {

	#set name [cn_core::util::treat_string -str $name]

	ns_log Notice "$ibge_code | [enconding utf8 $name] | [encoding utf8 $city]"
	
	if {[string equal $name $city]} {
	    return $city_code
	}
    }
    
    return 
}

ad_proc -public cn_resources::get_state_code {
    {-state $state}
} {
    Returns state's code
} {

    
    set state [cn_core::util::treat_string -str $state]

    # WHERE name like [lindex state 0] -- optimize the query with the first letter of the word
    db_foreach select_state_info {
	SELECT abbrev, state_name FROM br_states 
    } {

	set abbrev [cn_core::util::treat_string -str $abbrev]
	set state_name [cn_core::util::treat_string -str $state_name]
	
	if {[string equal $abbrev $state] || [string equal $state_name $state]} {
	    return $abbrev
	}
    }
    
    return ""
}

ad_proc -public cn_resources::get_country_code {
    {-country $country}
} {
    Returns country's code
} {

    
    set country [cn_core::util::treat_string -str $country]

    # WHERE name like [lindex city 0]
    db_foreach select_country_info {
	SELECT iso, default_name FROM countries 
    } {

	set default_name [cn_core::util::treat_string -str $default_name]
	set iso [cn_core::util::treat_string -str $iso]

	
	if {[string equal $country $default_name] || [string equal $country $iso]} {
	    return $iso
	}
    }
    
    return ""
}


namespace eval cn_resources::persons {}

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
	set line [split $line {,}] 
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
	set name [lindex $line 1]
	set type [lindex $line 2]

	set country [lindex $line 3]
	set country_code [cn_resources::get_country_code -country $country]

	set postal_code [lindex $line 4]

	set state [lindex $line 5]
	set state_code [cn_resources::get_state_code -state $state]

	set city [lindex $line 6]
	set city_code [cn_resources::get_city_code -city $city]
	
	set postal_addess "[lindex $line 8] [lindex $line 9] [lindex $line 10] [lindex $line 7]"
	set postal_addess2 [lindex $line 11]
	set phone [lindex $line 12]
	set email [lindex $line 13]
	set cpf_cnpj [lindex $line 14]


    ns_log Notice "
	-cpf_cnpj $cpf_cnpj \n
        -legal_name $legal_name \n
        -corporate_name $corporate_name \n
        -code $code \n
	-type $type \n
        -contact_id $contact_id \n
	-email $email \n
	-phone $phone \n
	-postal_address $postal_address2 \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state_code $state_code \n
	-city_code $city_code \n
	-country_code $country_code \n
    "



	#cn_resources::person::new \
	    -cpf_cnpj $cpf_cnpj \
	    -legal_name $legal_name \
	    -corporate_name $corporate_name \
	    -code $code \
	    -type $type \
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
    
    return
}

namespace eval cn_resources::person {}

ad_proc -public cn_resources::person::new {
    {-cpf_cnpj}
    {-legal_name ""}
    {-corporate_name ""}
    {-code ""}
    {-type ""}
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
        -corporate_name $corporate_name \n
        -code $code \n
	-type $type \n
        -contact_id \n
	-email $email \n
	-phone $phone \n
	-postal_address $postal_address2 \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state_code $state_code \n
	-city_code $city_code \n
	-country_code $country_code \n
	-creation_ip $creation_ip \n
	-creation_user $creation_user \n 
	-context_id $context_id    
    "

    
    
    set person_id [db_exec_plsql insert_person {
	SELECT cn_person__new (
			       :cpf_cnpj,
			       :legal_name,
			       :corporate_name,
			       :code,
			       :type,
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
    
    return $person_id
    
}

