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
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    Add a new vehicle 
} {
    
    #set vehicle_id [db_nextval acs_object_id_seq]
	
    set vehicle_id [db_exec_plsql insert_vehicle {
	SELECT cn_vehicle__new (
				null,
				:chassis,
				:model,
				:engine,
				:color,
				:year_of_model,
				:year_of_fabrication,
				:creation_ip,
				:creation_user,
				:context_id
				)
    }]
    
    return $vehicle_id
}


ad_proc -public cn_assurance::new { 
    {-chassis}
    {-model}
    {-engine ""}
    {-color ""}
    {-year_of_model ""}
    {-year_of_fabrication ""}
    {-purchase_date ""}
    {-arrival_date ""}
    {-billing_date ""}
    {-duration ""}
    {-distributor_code ""}
    {-owner ""}
    {-phone ""}
    {-postal_address ""}
    {-postal_address2 ""}
    {-postal_code ""}
    {-state ""}
    {-country_code "BR"}
    {-notes ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} { 
    Add a new assurance
} {
    
    ns_log Notice "
	$chassis \n
	$model \n
	$engine \n
	-color $color \n
	-year_of_model $year_of_model \n
	-year_of_fabrication $year_of_fabrication \n
	-purchase_date $purchase_date \n
	-arrival_date $arrival_date \n
	-billing_date $billing_date \n
	-duration $duration \n
	-distributor_code $distributor_code \n
	-owner $owner \n
	-phone $phone \n
	-postal_address $postal_address \n
	-postal_address2 $postal_address2 \n
	-postal_code $postal_code \n
	-state $state \n
	-country_code $country_code \n
	-notes $notes \n
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

    set vehicle_id [cn_vehicle::new \
			-chassis $chassis \
			-model $model \
			-engine $engine \
			-color $color \
    			-year_of_model $year_of_model \
			-year_of_fabrication $year_of_fabrication \
			-creation_ip $creation_ip \
			-creation_user $creation_user \
			-context_id $context_id]
    
    #set assurance_id [db_nextval acs_object_id_seq]
				
    db_exec_plsql insert_assurance {
	SELECT cn_assurance__new (
				  null,
				  :vehicle_id,
				  :purchase_date,
				  :arrival_date,	
				  :billing_date,
				  :duration,
				  :distributor_code,
				  :owner,
				  :phone,
				  :postal_address,
				  :postal_address2,
				  :postal_code,
				  :state,
				  :municipality,
				  :country_code,
				  :notes,
				  :creation_user,
				  :creation_ip,
				  :context_id
				  )
    }
    
    return $assurance_id
}


ad_proc -public cn_assurance::get_color_options {} {

    Returns a list of lists to the ad_form select element 

} {

    return [db_list_of_lists select_colors { SELECT name, code FROM cn_colors }]
}