ad_library {

    CN Spreasheet API
    
    @author Iuri Sampaio (iuri.sampaio.iurix.com)
    @creation-date 2011-09-18

}

namespace eval cn_spreadsheet {}
namespace eval cn_spreadsheet::fields {}
namespace eval cn_spreadsheet::data {}
namespace eval cn_spreadsheet::element {}
namespace eval cn_spreadsheet::items {}




ad_proc -public cn_spreadsheet::import_csv {
    {-spreadsheet_id:required}
    {-tmp_file:required}
    {-update_p "0"}
} {
    Import CSV
    
    @upadte_p 0 - removes everything
    @update_p 1 - add more data
} {
    
    if {$update_p} {
	cn_spreadsheet::element::delete -spreadsheet_id $spreadsheet_id
	cn_spreadsheet::data::delete -spreadsheet_id $spreadsheet_id
    }
    
    set input_file [open $tmp_file r] 
    set lines [split [read $input_file] \n]
    close $input_file
    
    # Determine what is the key element within the spreadsheet fields
    set key_field "chassi"

    set num_fields 0
    set num 0
    foreach line $lines {
	if {$num == 0} {
	    # FIELDS
	    set fields [split $line ";"]
	    set i 0
	    foreach field_name $fields {
		set field_name [cn_spreadsheet::treat_chars -str $field_name] 
		if {[string equal $field_name $key_field]} {
		    set key $i
		}
		if {[exists_and_not_null field_name]} {
		    set field_id($i) [cn_spreadsheet::fields::new -name $field_name -spreadsheet_id $spreadsheet_id]
		    incr num_fields
		}
		incr i
		
	    }
	   	    
	} else {
	    # DATA
	    set values [split $line ";"]
	    set i 0
	    foreach value $values {
		set row($i) $value
		incr i
		
	    }
	    	    
	    set aux $row($key)
	    if {[exists_and_not_null aux]} {
		
		cn_spreadsheet::element::new -name $row($key) -element $row($key) -spreadsheet_id $spreadsheet_id
	    
		for {set j 0} {$j<$num_fields} {incr j} {
		    if {[exists_and_not_null aux]} {
			cn_spreadsheet::data::new -field_id $field_id($j) -data $row($j) -element $row($key)
		    }
		}
	    }
	}
	incr num
    }    
}	


ad_proc -public cn_spreadsheet::treat_chars {
    {-str}
} {
    Changes char to lower case and treats special chars
} {
    


    set str [encoding convertto utf-8 $str]
    return [string tolower $str]
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
	select cn_spreadsheet__new (
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
    
    cn_spreadsheet::import_csv -spreadsheet_id $spreadsheet_id -tmp_file $tmp_file

    return $spreadsheet_id
}




ad_proc -public cn_spreadsheet::delete {
    {-spreadsheet_id:required}
} {
    Delete Spreadsheet
} {
    set list_of_fields [db_list get_fields {
	SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id}]
    foreach field_id $list_of_fields {
	cn_spreadsheet::fields::delete -field_id $field_id
    }
    set list_of_items [db_list get_fields {
	SELECT item_id FROM cn_spreadsheet_items WHERE spreadsheet_id = :spreadsheet_id}]
    foreach item_id $list_of_items {
	cn_spreadsheet::items::delete -item_id $item_id
    }
    
    return [db_string delete_spreadsheet {
	select cn_spreadsheet__del(:spreadsheet_id)
    }]
}





#####################################
# Items
#####################################
ad_proc -public cn_spreadsheet::items::delete {
    {-item_id}
} { 
    Delete Spreadsheet Item
} {
 
    return [db_string delete_spreadsheet_item {
	SELECT cn_spreadsheet_items__del(:item_id)
    }]
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
    ns_log Notice "Running ad_proc cn_spreadhseet::fields::new"
    ns_log Notice "$spreadsheet_id - $name"
    
    set package_id 	  [ad_conn package_id]
    set creation_user [ad_conn user_id]
    set creation_ip   [ad_conn peeraddr]
    set label $name
    
    set exists [db_string test {
	SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id AND name = :name
    } -default ""]
    if {$exists != ""} {
	return $exists
    } 
   
    ns_log Notice "$name"
    set field_id [db_string create_field {
	select cn_spreadsheet_fields__new (
					   :spreadsheet_id,		    -- spreadsheet_id
					   :name, 	    		    -- pretty_nname
					   :label,                         -- label
					   :package_id,    		    -- package_id
					   now(), 			    -- creation_date
					   :creation_user,     	    -- creation_user
					   :creation_ip 		    -- creation_ip
					   )
    }]
    
   
    ns_log Notice "$field_id"
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
	SELECT 1 from cn_spreadsheet_elements WHERE element = :element AND spreadsheet_id = :spreadsheet_id
    } -default 0]
    
    if {$exists} {
	return
    } 
    
    db_exec_plsql create_data {
        SELECT cn_spreadsheet_element__new (
					    :spreadsheet_id,		-- field_id
					    :name, 			-- name
					    :element  			-- element
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
	SELECT 1 FROM cn_spreadsheet_data WHERE element = :element AND field_id = :field_id
    } -default 0]

    if {$exists} {
	return
    } 
    

    db_exec_plsql create_data {
        SELECT cn_spreadsheet_data__new (
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

