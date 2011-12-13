ad_library {

    CN Auto Assurance API

}


namespace eval cn_assurance {}
namespace eval cn_vehicle {}

ad_proc -public cn_vehicle::new { 
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


ad_proc -public cn_assurance::new { 
    {-dcn ""}
    {-assurance_number ""}
    {-assurance_date ""}
    {-status ""}
    {-lp ""}
    {-lp_date ""}
    {-lp_2 ""}
    {-lp_2_date ""}
    {-service_order ""} 
    {-service_order_date ""}
    {-chassis ""}
    {-kilometers ""}
    {-part_group ""}
    {-part_code ""}
    {-part_quantity ""}
    {-damage_description ""}
    {-third_service ""}
    {-cost_price ""}
    {-assurance_price ""}
    {-tmo_code ""}
    {-tmo_duration ""}
    {-cost ""}
    {-ttl_sg ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} { 
    Add a new assurance
} {
    

    ns_log Notice "
			      -dcn $dcn \n
			      -assurance_number $assurance_number \n
			      -assurance_date $assurance_date \n
			      -status $status \n
			      -lp $lp \n
			      -lp_date $lp_date \n
			      -lp_2 $lp_2 \n
			      -lp_2_date $lp_2_date \n
			      -service_order $service_order \n
			      -service_order_date $service_order_date \n
			      -chassis $chassis \n
			      -kilometers $kilometers \n
			      -part_group $part_group \n
			      -part_code $part_code \n
			      -part_quantity $part_quantity \n
			      -damage_description $damage_description \n
			      -third_service $third_service \n
			      -cost_price $cost_price \n
			      -assurance_price $assurance_price \n
			      -tmo_code $tmo_code \n
			      -tmo_duration $tmo_duration \n
			      -cost  $cost \n
			      -ttl_sg $ttl_sg \n
			      -creation_ip [ad_conn peeraddr] \n
			      -creation_user [ad_conn user_id] \n
			      -context_id [ad_conn package_id] \n
"

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
     
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }

    



    #set assurance_id [db_nextval acs_object_id_seq]
				    
    set assurance_id [db_exec_plsql insert_assurance {
	SELECT cn_assurance__new (
				  :dcn,
				  :assurance_number,
				  :assurance_date,
				  :status,
				  :lp,
				  :lp_date,
				  :lp_2,
				  :lp_2_date,
				  :service_order, 
				  :service_order_date,
				  :chassis,
				  :kilometers,
				  :part_group,
				  :part_code,
				  :part_quantity,
				  :damage_description,
				  :third_service,
				  :cost_price,
				  :assurance_price,
				  :tmo_code,
				  :tmo_duration,
				  :cost,
				  :ttl_sg,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
    }]
    
    return $assurance_id
}


namespace eval cn_assurance::person {}

ad_proc -public cn_assurance::person::new {
    {-cpf_cnpj}
    {-first_names ""}
    {-last_name ""}
    {-email ""}
    {-type ""}
    {-phone ""}
    {-postal_address ""}
    {-postal_address2 ""}
    {-postal_code ""}
    {-state ""}
    {-municipality ""}
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
    
    
    set person_id [db_exec_plsql insert_person {
	SELECT cn_person__new (
			       :cpf_cnpj,
			       :first_names,
			       :last_name,
			       :email,
			       :type,
			       :phone,
			       :postal_address,
			       :postal_address2,
			       :postal_code,
			       :state,
			       :municipality,
			       :country_code,
			       :creation_ip,
			       :creation_user,
			       :context_id
			       );
    }]
    
    return $person_id
    
}




ad_proc -public cn_assurance::get_color_options {} {
    
    Returns a list of lists to the ad_form select element 
    
} {
    
    return [db_list_of_lists select_colors { SELECT name, code FROM cn_colors }]
}