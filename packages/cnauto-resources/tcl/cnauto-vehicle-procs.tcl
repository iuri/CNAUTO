ad_library {

    CNAuto vehicles procs

}


namespace eval cn_resources::vehicles {}

ad_proc -public cn_resources::vehicles::get_owner_options {} {
    Returns a list of owners to an ad_form select widget
} {
    
    set owners [list]
    lappend owners [list [_ cnauto-import.Select] ""]
    
    db_foreach select_owner {
	SELECT cp.pretty_name, cp.person_id 
	FROM cn_persons cp, cn_categories cc
	WHERE cp.type_id = cc.category_id AND cc.name = 'pessoafisica'
    } {
	lappend owners [list $pretty_name $person_id]
    }
    
    return $owners
}


ad_proc -public cn_resources::vehicles::get_distributor_options {} {
    Returns a list of owners to an ad_form select widget
} {
    
    set distributors [list]
    lappend distributors [list [_ cnauto-import.Select] ""]

    db_foreach select_distributors {
	SELECT cp.pretty_name, cp.person_id 
	FROM cn_persons cp, cn_categories cc
	WHERE cp.type_id = cc.category_id AND cc.name = 'concessionarias'
    } {
	
	lappend distributors [list $pretty_name $person_id]
    }
    
    return $distributors
}




ad_proc -public cn_resources::vehicles::get_color_options {} {
    
    Returns a list of lists to the ad_form select element 
    
} {
    
    set colors [list]

    lappend colors [list [_ cnauto-import.Select] ""] 

    db_foreach select_colors { 
	SELECT name, code FROM cn_colors 
    } {
	lappend colors [list $name $code]
	
    }
    
    
    ns_log Notice "$colors"
    return $colors
}


    


ad_proc -public cn_resources::vehicles::import_csv_abeiva {
    {-input_file}
} {
    Import CSV file from ABEIVA
} {

    ns_log Notice "Running ad_proc cn_resources::vehicles::import_csv_abeiva"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    foreach line $lines {

	set line [split $line {;}] 
	set purchase_date [lindex $line 0]

	if {[exists_and_not_null purchase_date]} {
	    set purchase_date [split $purchase_date {/}]
	    set purchase_date "[lindex $purchase_date 2]-[lindex $purchase_date 1]-[lindex $purchase_date 0]"
	} else {
	    set purchase_date ""
	}

	set vin [lindex $line 1]
	set renavam [lindex $line 2]

	set resource [lindex $line 3]
	
	cn_resources::vehicle::renavam_new -code $code -fabricant $fabricant -lcvm $lcvm -model $model -version $version
	
	
	set distributor [lindex $line 7]
	
    }
}


ad_proc -public  cn_resources::vehicles::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add vehicles
} {

    ns_log Notice "Running ad_proc cn_resources::vehicles::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    set creation_ip [ad_conn peeraddr]
    set creation_user [ad_conn user_id]
    set context_id [ad_conn package_id]

    foreach line $lines {

	if {$line ne ""} {
	    set line [split $line {;}] 
	    ns_log Notice "LINE $line"
	    
	    
	    set vin [lindex $line 0]
	    
	    
	    set exists_p [db_string select_code {
		SELECT vin FROM cn_vehicles WHERE vin = :vin
	    } -default null]
	    
	    if {$exists_p == "null" && $vin != ""} {
		ns_log Notice "CHASSIS $vin" 
		
		db_transaction {
		    db_exec_plsql insert_vehicle {
			SELECT cn_vehicle__new (
						:vin,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						:creation_ip,
						:creation_user,
						:context_id
						)
		    }
		}
	    }
	}	
    }

    return
}

namespace eval cn_resources::vehicle {}

ad_proc -public cn_resources::vehicle::delete { 
    vehicle_id
} {
    Deletes a vehicle
} {

    db_exec_plsql delete_vehicle {
	SELECT cn_vehicle__delete ( :vehicle_id )
    }

    return
}

ad_proc -public cn_resources::vehicle::edit { 
    {-vehicle_id:required}
    {-vin:required}
    {-resource_id:required}
    {-engine ""}
    {-year_of_model ""}
    {-year_of_fabrication ""}
    {-color ""}
    {-arrival_date ""}
    {-billing_date ""}
    {-purchase_date ""}
    {-warranty_time ""}
    {-distributor_id ""}
    {-owner_id ""}
    {-notes ""}
} {
    Edit vehicle info
} {
    

    db_transaction {
	db_exec_plsql update_vehicle {
	    SELECT cn_vehicle__edit (
				     :vehicle_id,
				     :vin,
				     :resource_id,
				     :engine,
				     :year_of_model,
				     :year_of_fabrication,
				     :color,
				     :arrival_date,
				     :purchase_date,
				     :billing_date,
				     :warranty_time,
				     :distributor_id,
				     :owner_id,
				     :notes
				     )
	}
    }

    return

}


ad_proc -public cn_resources::vehicle::new { 
    {-vin:required}
    {-resource_id:required}
    {-year_of_model null}
    {-year_of_fabrication null}
    {-color ""}
    {-arrival_date null}
    {-billing_date null}
    {-license_date null}
    {-purchase_date null}
    {-warranty_time ""}
    {-distributor_id null}
    {-owner_id null}
    {-notes ""}
    {-creation_ip ""}
    {-creation_user null}
    {-context_id null}
} {
    Adds a new vehicle 
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
	
    db_transaction {
	set vehicle_id [db_exec_plsql insert_vehicle {
	    SELECT cn_vehicle__new (
				    :vin,
				    :resource_id,
				    :year_of_model,
				    :year_of_fabrication,
				    :color,
				    :arrival_date,	
				    :billing_date,
				    :license_date,
				    :purchase_date,
				    :warranty_time,
				    :distributor_id,
				    :owner_id,
				    :notes,
				    :creation_ip,
				    :creation_user,
				    :context_id
				    )
	}]
    }

    return $vehicle_id
}



ad_proc -public cn_resources::vehicle::renavam_new {
    {-code ""}
    {-fabricant ""}
    {-lcvm ""}
    {-model ""}
    {-version ""}
} {
    Creates a new renavam and returns its renavam_id
} {
    
    set renavam_id [db_nextval acs_object_id_seq]

    db_exec_plsql insert_renavam {
	SELECT cn_renavam__new (
				:renavam_id,		
				:code,
				:fabricant,
				:lcvm,
				:model,
				:version
				);
    }
	
    return $renavam_id
    

}



ad_proc -public cn_resources::vehicle::renavam_edit {
    {-renavam_id:required}
    {-code ""}
    {-fabricant ""}
    {-lcvm ""}
    {-model ""}
    {-version ""}
} {
    Amends renavam information
} {

    db_exec_plsql update_renavam {
	SELECT cn_renavam__edit (
				:renavam_id,		
				:code,
				:fabricant,
				:lcvm,
				:model,
				:version
				);
    }
	
    return 0   

}




ad_proc -public  cn_resources::vehicles::import_renavam {
    {-input_file}
} {

    Imports renavam CSV file 
} {

    ns_log Notice "Running ad_proc cn_resources::import_renavam"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    foreach line $lines {
	set line [split $line {;}] 
	ns_log Notice "LINE $line"


	if {$line ne ""} {
	    ns_log Notice "add renavam"

	    set fabricant [lindex $line 0]
	    set lcvm [lindex $line 1]
	    set model [lindex $line 2]
	    set version [lindex $line 3]
	    set code [lindex $line 4]
	    
	    set code_p [db_string select_code {
		SELECT COUNT(renavam_id) FROM cn_vehicle_renavam WHERE code = :code AND code is not null } -default null]
	    
	    if {$code_p eq 0} {
		
		set renavam_id [db_nextval acs_object_id_seq]
		
		db_exec_plsql insert_renavam {
		    SELECT cn_vehicle_renavam__new (
					    :renavam_id,		
					    :code,
					    :fabricant,
					    :lcvm,
					    :model,
					    :version
					    );
		}    	    
	    }	
	}
    }
    
    return 
}



ad_proc -public cn_resources::vehicle::renavam_delete { 
    renavam_id
} {
    Deletes a renavam
} {

    db_exec_plsql delete_renavam {
	SELECT cn_vehicle_renavam__delete ( :renavam_id )
    }

    return
}
