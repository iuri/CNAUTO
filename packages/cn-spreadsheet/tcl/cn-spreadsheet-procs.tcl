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



ad_proc -public cn_spreadsheet::export_txt {
    {-spreadsheet_id}
} {
    Export CSV file to TXT
} {
    
    ns_log Notice "Running ad_proc export_txt"
    
    # Output file
    set filename_jan "[acs_root_dir]/www/BRASIF1_31012011.txt"
    set filename_feb "[acs_root_dir]/www/BRASIF1_28022011.txt"
    set filename_mar "[acs_root_dir]/www/BRASIF1_31032011.txt"
    set filename_apr "[acs_root_dir]/www/BRASIF1_30042011.txt"
    set filename_may "[acs_root_dir]/www/BRASIF1_31052011.txt"
    set filename_jun "[acs_root_dir]/www/BRASIF1_30062011.txt"
    set filename_jul "[acs_root_dir]/www/BRASIF1_31072011.txt"
    set filename_aug "[acs_root_dir]/www/BRASIF1_31082011.txt"
    set filename_sep "[acs_root_dir]/www/BRASIF1_30092011.txt"
    set filename_oct "[acs_root_dir]/www/BRASIF1_31102011.txt"

    set output_jan [open "${filename_jan}" w]
    set output_feb [open "${filename_feb}" w]
    set output_mar [open "${filename_mar}" w]
    set output_apr [open "${filename_apr}" w]
    set output_may [open "${filename_may}" w]
    set output_jun [open "${filename_jun}" w]
    set output_jul [open "${filename_jul}" w]
    set output_aug [open "${filename_aug}" w]
    set output_sep [open "${filename_sep}" w]
    set output_oct [open "${filename_oct}" w]
    
        
    set count_towner 0
    set count_topic 0
    set total 0

    set output_line [list]

    db_foreach chassis {
	SELECT DISTINCT se.element_id, se.element AS chassis FROM cn_spreadsheet_elements se
	WHERE se.spreadsheet_id = :spreadsheet_id AND se.valid = 't'
    } {
	
	set data [db_list_of_lists select_data {
	    SELECT data FROM cn_spreadsheet_data sd WHERE sd.element = :chassis ORDER BY field_id
	}]
	
	# 0 Chave do pedido
	lappend output_line $element_id
	
	
	# 1 Data de vigencia
	set date [split [lindex $data 0] {/}]
	set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"
	
	set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"

	set month [db_string select_month {
	    SELECT EXTRACT(MONTH FROM TIMESTAMP :date)
	}]

	set year [db_string select_month {
	    SELECT EXTRACT(YEAR FROM TIMESTAMP :date)
	}]

	set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]
	
	set date "${date1}${date2}"
	
	lappend output_line $date

	
	# 2 Modelo
	lappend output_line [lindex [lindex $data 3] 0]

	# 3 Descrcao
	lappend output_line "[lindex [lindex $data 4] 0] [lindex [lindex $data 5] 0] [lindex $data 6]"

	# 4 Contrato
	if {[regexp -all "^LSY" $chassis]} {
	    set contrato 40000162449
	    incr count_topic
	   
	} elseif {[regexp -all "^LKH" $chassis]} {
	    set contrato 40000162448
	    incr count_towner
	}
	
	lappend output_line $contrato

	lappend output_line $chassis

	# Format output to BA standard
	set output_line [cn_core::format_output_line -line $output_line]

	# Send info to output file
	ns_log Notice "MONTH $month | YEAR $year"
	if {$year == 2011} { 
	    switch $month {
		1 {
		    puts $output_jan $output_line
		}
		2 {
		    puts $output_feb $output_line
		}
		3 {
		    puts $output_mar $output_line
		}
		4 {
		    puts $output_apr $output_line
		}
		5 {
		    puts $output_may $output_line
		}
		6 {
		    puts $output_jun $output_line
		}
		7 {
		    puts $output_jul $output_line
		}
		8 {
		    puts $output_aug $output_line
		    
		}
		9 {
		    puts $output_sep $output_line
		    
		}
		10 {
		    puts $output_oct $output_line
		}
		
	    }
	}


	incr total

	set output_line ""
    } 

    ns_log Notice "Total: $total | Topic: $count_topic | Towner: $count_towner"

}





ad_proc -public cn_spreadsheet::import_csv {
    {-spreadsheet_id:required}
    {-tmp_file:required}
    {-update_p "0"}
} {
    Import CSV
    
    @upadte_p 0 - removes everything
    @update_p 1 - add more data
} {
    ns_log Notice "Running ad_proc cn_spreadsheet::import_csv"
    
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
	#ns_log Notice "LINE $line " 
	if {$num == 0} {
	    # FIELDS
	    set fields [split $line ";"]
	    set i 0
	    foreach field_name $fields {
		set field_name [util_text_to_url -replacement "" -text $field_name] 
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
		
		#ns_log Notice "$row($key) - $spreadsheet_id"
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
    ns_log Notice "Running ad_proc cn_spreadsheet::element::new"

    ns_log Notice "$spreadsheet_id | $name | $element"

    #test if exists 
    set exists [db_string test {
	SELECT 1 from cn_spreadsheet_elements WHERE element = :element AND spreadsheet_id = :spreadsheet_id
    } -default 0]
    
    if {$exists} {
	return
    } 
    
    #set element_id [db_nextval cn_spreadsheet_element_id_seq]
    db_transaction { 
	db_exec_plsql create_data {
	    SELECT cn_spreadsheet_element__new (
						:spreadsheet_id,	-- spreadsheet_id
						:name, 			-- name
						:element  	        -- element
						)
	}
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

