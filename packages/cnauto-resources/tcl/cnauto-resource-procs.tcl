ad_library {
    CN Auto Resources API

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-06-04
}


namespace eval cn_resources {}

namespace eval cn_resources::resource {}



ad_proc -public cn_resources::get_resource_options {
    {-type ""}
} {
    Returns resources to a select list
} {
    
    set resources [list]

    lappend resources [list [_ cnauto-resources.Select] ""]

    if {$type eq ""} {
	set where_clause ""
    } else {
	set where_clause " WHERE cr.type_id = (SELECT category_id FROM cn_categories WHERE name = :type)" 
    }

    db_foreach select_resource "
	SELECT cr.pretty_name, cr.resource_id FROM cn_resources cr 
	$where_clause
    " {
	lappend resources [list $pretty_name $resource_id]
    }
   
    ns_log Notice "RESOURCES $resources"

    return $resources
}


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
    lappend states [list [_ cnauto-resources.Select] ""]

    db_foreach select_states {
	SELECT state_name, abbrev FROM br_states ORDER BY state_name 
    } {
	lappend states [list $state_name $abbrev]
    }

    return $states

}


ad_proc -public cn_resources::get_city_options {} {
    Returns a list of cities for an ad_form select widget
} {

    set cities [list]
    lappend cities [list [_ cnauto-resources.Select] ""]

    db_foreach select_cities {
	SELECT name, ibge_code FROM br_ibge_municipality ORDER BY name
    } {
	lappend cities [list $name $ibge_code]
    }

    return $cities

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

