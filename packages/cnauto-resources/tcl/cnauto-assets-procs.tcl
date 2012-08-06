ad_library {
    CN Auto Assets API
}


namespace eval cn_assets {}

namespace eval cn_assets::asset {}

ad_proc -public cn_assets::asset::assign_user {
    {-asset_id:required}
    {-user_id:required}
} {

    Assigns responsability of an asset to a user
} {
   

    set map_id [db_nextval acs_object_id_seq]

    db_exec_plsql insert_map {
	SELECT cn_asset_user_map__new (
			    :map_id,
			    :asset_id,
			    :user_id
			    )
    }
    
    return 

}


ad_proc -public cn_assets::asset::unassign_user {
    {-asset_id:required}
} {

    Unassigns responsability of an asset to a user
} {
   

    db_1row select_map_id {
	SELECT map_id FROM cn_asset_user_map WHERE asset_id = :asset_id
    }

    db_exec_plsql remove_map {
	SELECT cn_asset_user_map__delete ( :map_id )
    }
    
    return 

}




ad_proc -public cn_assets::asset::get_asset_id {
    {-code:required}
} {

    Gets asset_id 
} {
    
    return [db_string select_asset_id {
	SELECT asset_id FROM cn_assets WHERE asset_code = :code
    } -default null]

}


ad_proc -public cn_assets::asset::delete {
    asset_id
} {
    Delete an asset
} {

    db_transaction {
	
	db_exec_plsql delete_asset {
	    SELECT cn_asset__delete ( :asset_id )
	}
    }
    
    return 
}

ad_proc -public cn_assets::asset::new {
    {-asset_code:required}
    {-serial_number:required}
    {-resource_id:required}
    {-location ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    Creates a new asset and returns its asset_id
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
	set asset_id [db_exec_plsql insert_asset {
	    SELECT cn_asset__new (
				  :resource_id,
				  :asset_code,
				  :serial_number,
				  :location,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
	}]
    }

    return $asset_id
}



ad_proc -public  cn_assets::import_assets {
    {-input_file:required}
} {

    Imports CSV files to add assets
} {

    ns_log Notice "Running ad_proc cn_assets::import_assets"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    foreach line $lines {
	set line [split $line {;}] 
	
	ns_log Notice "LINE $line"

	if {$line ne ""} {
	    ns_log Notice "LINE 3 $line"
	    set code_ [lindex $line 0]
	    
	    set exists_p [db_string select_code {
		SELECT code FROM cn_resources WHERE code = :code
	    } -default null]
	    

	    ns_log Notice "ADD RESOURCE $code | $pretty_name | $class_id | $ncm | $unit"
	    set resource_id [cn_resources::resource::new \
				 -code_unum $code \
				 -pretty_name $pretty_name \
				 -class_id $class_id \
				 -ncm_class $ncm \
				 -unit $unit \
				]
	    
	    set asset_id [cn_assets::asset::new \
			      -resource_id $resource_id \
			      -asset_code $asset_code \
			      -serial_number $serial_number \
			      -location $location \
			     ]
	}



    }	

    return
}




