ad_library {

    CN Spreasheet API
    
    @author Iuri Sampaio (iuri.sampaio.iurix.com)
    @creation-date 2011-09-18

}

namespace eval cn_spreadsheet {}
namespace eval cn_spreadsheet::fields {}
namespace eval cn_spreadsheet::data {}
namespace eval cn_spreadsheet::elements {}
namespace eval cn_spreadsheet::items {}




ad_proc -public cn_spreadsheet::import_csv {
    {-spreadsheet_id:required}
    {-tmp_file:required}
    {-update_p "0"}
} {
    Import CSV
} {

    if {$update_p} {
	cn_spreadsheet::element::delete -spreadsheet_id $spreadsheet_id
	cn_spreadsheet::data::delete -spreadsheet_id $spreadsheet_id
    }

    set num 0
    oacs_util::csv_foreach -file $tmp_file -array_name row {
	
	if {$num == 0} {
	    set fields [array names row]
	    
	    # clean fields
	    set fields_names ""
	    set available_fields ""
	    set fields_to_delete ""
	    foreach field_name $fields {
		if {$field_name != "chassi"} {
		    lappend fields_names $field_name
		}
	    }
	    set fields $fields_names
	    
	    foreach field_name $fields {
		set field_id($field_name) [cn_spreadsheet::fields::new -name $field_name -spreadsheet_id $spreadsheet_id]
		lappend available_fields $field_id($field_name)
	    }
	    
	    set available_fields_list_sql [join $available_fields ","]
	    if {$available_fields_list_sql != ""} {
		set fields_to_delete [db_list get_list "
		    SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id AND field_id NOT IN ($available_fields_list_sql)
		"]
	    }
	    
	    foreach field_to_delete $fields_to_delete {
		cn_spreadsheet::fields::delete -field_id $field_to_delete
	    }
	}
	
	
	if {![exists_and_not_null row(name)]} {
	    set row(name) $row(chassi)
	}
	
	cn_spreadsheet::element::new -name $row(name) -element $row(chassi) -spreadsheet_id $spreadsheet_id
	foreach field_name $fields {
	    cn_spreadsheet::data::new -field_id $field_id($field_name) -data $row($field_name) -element $row(chassi)
	}
	incr num
    }
        
    return $spreadsheet_id
    
}	



#####################################
# CN SpreadSheet
#####################################

ad_proc -public cn_spreadsheet::new {
	{-spreadsheet_id "null"}
	{-name:required}
	{-description:required}
	{-tmp_file:required}
} {
    create new spreadsheet
} {
    set package_id [ad_conn package_id]
    set creation_user [ad_conn user_id]
    set creation_ip [ad_conn peeraddr]
		
    set spreadsheet_id [db_string create_spreadsheet {
	select spreadsheet__new (
				 :spreadsheet_id,	-- spreadsheet_id
				 :name,			-- name
				 :description,		-- description
				 :package_id,		-- package_id
				 now(), 		-- creation_date
				 :creation_user,	-- creation_user
				 :creation_ip, 		-- creation_ip
				 :package_id		-- context_id
				 )
    }]
    
    spreadsheet::import_csv -spreadsheet_id $spreadsheet_id -tmp_file $tmp_file

    return $spreadsheet_id
}

#####################################
# Fields
#####################################

ad_proc -public cn_spreadsheet::fields::new {
    {-spreadsheet_id:required}
    {-name ""}
} {
    create new field
} {

	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip   [ad_conn peeraddr]
	
	set exists [db_string test {
	    SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id AND name = :name
	} -default ""]
	if {$exists != ""} {
		return $exists
	} 
	

	set field_id [db_string create_field {
		select cn_spreadsheet_fields__new (
		            null, 			    -- field_id
			    :spreadsheet_id,		    -- spreadsheet_id
			    :name, 	    		    -- pretty_name
			    :package_id,    		    -- package_id
			    now(), 			    -- creation_date
			    :creation_user,     	    -- creation_user
			    :creation_ip, 		    -- creation_ip
			    :spreadsheet_id		    -- context_id
		)
	}]

	return $field_id
}


ad_proc -public cn_spreadsheet::fields::delete {
    {-field_id:required}
} {
    delete field 
} {
    db_exec_plsql delete_field {
	SELECT cn_spreadsheet_fields__del(:field_id)
    }
}



#####################################
# Element
#####################################


ad_proc -public cn_spreadsheet::element::new {
    {-spreadsheet_id:required}
    {-name:required}
    {-element:required}
} {
    create new data
} {
    
    #test if exists 
    set exists [db_string test {
	SELECT 1 from cn_spreadsheet_elements WHERE element = :chassi AND spreadsheet_id = :spreadsheet_id
    } -default 0]
    
    if {$exists} {
	return
    } 
    
    db_exec_plsql create_data {
        SELECT cn_spreadsheet_element__new (
					    :spreadsheet_id,		-- field_id
					    :name, 			-- name
					    :chassi  			-- chassi
					    )
    }
}



ad_proc -public cn_spreadsheet::element::delete {
    {-spreadsheet_id:required}
} {
    db_dml delete_field {
	DELETE FROM cn_spreadhseet_elements WHERE spreadsheet_id = :spreadsheet_id
    }
}


#####################################
# Data
#####################################


ad_proc -public cn_spreadsheet::data::new {
    {-field_id:required}
    {-element:required}
    {-data ""}
} {
    create new data
} {
    set exists [db_string test {
	SELECT 1 FROM cn_spreadsheet_data WHERE element = :chassi AND field_id = :field_id
    } -default 0]

    if {$exists} {
	return
    } 
    

    db_exec_plsql create_data {
        SELECT spreadsheet_data__new (
				      :field_id,		-- field_id
				      :element,  		-- element
				      :data 		        -- data
				      )
    }
}


ad_proc -public cn_spreadsheet::data::delete {
    {-spreadsheet_id:required}
} {
     Delete Data SpreadSheet
} {
    return [db_string delete_data_newsletters {
	SELECT cn_spreadsheet_data__del(:spreadsheet_id)
    }]
}

