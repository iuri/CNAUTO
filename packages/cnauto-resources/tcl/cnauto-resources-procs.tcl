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

    
    set city [cn_core::util::treat_string -str $city]

    # WHERE name like [lindex city 0]
    db_foreach select_city_info {
	SELECT ibge_code, name FROM br_ibge_municipality ORDER BY name
    } {

	set name [cn_core::util::treat_string -str $name]

	ns_log Notice "$ibge_code | $name | $city"
	
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

    # WHERE name like [lindex city 0]
    db_foreach select_city_info {
	SELECT state_abbrev FROM br_states 
    } {

	set state_abbrev [cn_core::util::treat_string -str $state_abbrev]

	ns_log Notice "$state_abbrev | $state"
	
	if {[string equal $state_abbrev $state]} {
	    return $
	}
    }
    
    return 
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
	set line [split $line {;}] 
	ns_log Notice "LINE $line"
	
	# 0 CIDADE
	# 1 ESTADO
	# 2 NOME FANTASIA
	# 3 RAZÃO SOCIAL
	# 4 CNPJ
	# 5 CODIGO
	# 6 TIPO
	# 7 CONTATO
	# 8 TELEFONE
	# 9 ENDEREÇO
	# 10 CEP
	# 11 E-mail Titular

	set city [lindex $line 0]
	set city_code [cn_resources::get_city_code -city $city]
	
	set state [lindex $line 1]
	#set state_code [cn_resources::get_state_code -state $state]

	set corporate_name [lindex $line 2] 
	set legal_name [lindex $line 3]
	set cpf_cnpj [lindex $line 4]
	set code [lindex $line 5]
	set type [lindex $line 6]

	# Begin to colect contact/user info
	set contact [lindex $line 7]
	ns_log Notice "CONMTACT $contact"
	for {set i 0} {$i < [expr [llength $contact] - 1]} {incr i} {
	    lappend first_names [lindex $contact $i]
	}

	set last_name [lindex $contact $i]
       	set email [lindex $line 11] \
	    
	# Adding user/member/contact
	set contact_id [db_nextval acs_object_id_seq]
	array set creation_info [auth::create_user \
                                     -user_id $contact_id \
                                     -email $email \
                                     -first_names $first_names \
                                     -last_name $last_name \
				    ]
	set group_id [application_group::group_id_from_package_id -package_id [	subsite::get_element -element "package_id"]]
	
	if { $creation_info(creation_status) eq "ok" && [exists_and_not_null group_id] } {
            group::add_member \
                -group_id $group_id \
                -user_id $contact_id \
                -rel_type "membership_rel"
        }
	# End Adding user/member/contact
	
	set phone [lindex $line 8]
	set postal_address [lindex $line 9]
	set postal_address2 ""
	set postal_code [lindex $line 10]

	set country_code "BR"
	


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

