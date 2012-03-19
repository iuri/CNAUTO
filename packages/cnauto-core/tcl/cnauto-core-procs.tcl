# /packages/cnauto-core/tcl/cnauto-core-procs.tcl
ad_library {

    CNAuto Core core package procs

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04

}

namespace eval cnauto_core {}

namespace eval cn_core {}




ad_proc -public cn_core::import_xml {
    {-input_file}
} {
    Import NFe XML file
} {

    ns_log Notice "Running ad_proc cn_core::import_xml"
    set xml [read [open "${input_file}" r]]

 #   ns_log Notice "$xml"

    set doc [dom parse $xml]
    
    ns_log Notice "DOC $doc"
    
    if {[catch {set root [$doc documentElement]} err]} {
	error "Error parsing XML: $err"
    }
    
    set output_list [list]

    ns_log Notice "NAME [$root nodeName]"

    if {[$root hasChildNodes]} {
	set childNodes [$root childNodes]
#	ns_log Notice "CHILDREN $childNodes | [$childNodes nodeName]"
#	ns_log Notice "[$root getElementsByTagName prod]"
	set prodNodes [$root getElementsByTagName prod]


	set distNode [$root getElementsByTagName dest]
       	set distCNPJElem [$distNode getElementsByTagName CNPJ]
	set distCNPJ [[$distCNPJElem firstChild] nodeValue]
		      
	set ditributor_id [cn_resources::person::get_id -cpf_cnpj $distCNPJ]

	foreach node $prodNodes {
	
	    # Chassis
	    set chassisNode [$node getElementsByTagName chassi]
	    set chassisElem [$chassisNode nodeName]
	    set chassisValue [[$chassisNode firstChild] nodeValue]
	    
	    # Color
	    set colorNode [$node getElementsByTagName xCor]
	    set colorElem [$colorNode nodeName]
	    set colorValue [[$colorNode firstChild] nodeValue]
	    
	    # Engine
	    set engineNode [$node getElementsByTagName nMotor]
	    set engineElem [$engineNode nodeName]
	    set engineValue [[$engineNode firstChild] nodeValue]
	    
	    # Resource
	    set resourceNode [$node getElementsByTagName cProd]
	    set resourceElem [$resourceNode nodeName]
	    set resourceValue [[$resourceNode firstChild] nodeValue]
	    
	    set resource_id [cn_resources::get_resource_id -code $resourceValue]
	    
	    # Model
	    #set model_id [cn_resources::get_model_id -resource_id $resource_id]
	    
	    
	    # Year of Model
	    set yofNode [$node getElementsByTagName anoFab]
	    set yofValue [[$yofNode firstChild] nodeValue]
	    
	    #Year of fab
	    set yomNode [$node getElementsByTagName anoMod]
	    set yomValue [[$yomNode firstChild] nodeValue]
	    
	    # distributor - CNPJ
    
	    lappend $output_list "${chassisValue};${colorValue};${engineValue};\n"
	

	    ns_log Notice "Chassis: $chassisNode | $chassisElem | $chassisValue"
	    ns_log Notice "Color: $colorNode | $colorElem | $colorValue"
	    ns_log Notice "Engine $engineNode | $engineElem | $engineValue"
	    ns_log Notice "Distributor: $distCNPJ"
	    

	    # switch $item { "part" { insert part } "vehicle" {insert vehgicle}}

	    # Insert Vehicle
	    #cn_resources::vehicle::new \
		-vin $chassisValue \
		-resource_id $resource_id \
		-model_id "" \
		-engine $engineValue \
		-year_of_model $yofValue \
		-year_of_fabrication $yomValue \
		-color $colorValue \
		-ditributor_id $distributor_id
		
	    
	}
    }
 
    set flag 0
    if {$flag} {
	

	set filepath "[acs_root_dir]/www/${filename}"
	set output_file [open $filepath w]
	
	
	
	# Output file
	puts $output_file $output_list

	close $output_file


	
	set date [lindex [ns_localsqltimestamp] 0]
	set fileseq [db_nextval cn_core_file_number_seq]
	set filename "${date}-${fileseq}"
	
	
	set revision_id [cn_core::attach_file \
			     -parent_id [ad_conn package_id] \
			     -tmp_filename $filepath \
			     -filename $filename \
			    ]
	
	
	acs_mail_lite::send \
	    -send_immediately \
	    -from_addr "iuri.sampaio@gmail.com" \
	    -to_addr "iuri.sampaio@cnauto.com.br" \
	    -subject "CNAUTO - Fatura de automovel" \
	    -body "Please see file attachment" \
	    -package_id [ad_conn package_id] \
	    -file_ids $revision_id
	
    }
    
    
    ns_log Notice "$rt"
}








ad_proc -public cn_core::attach_file {
    {-parent_id:required}
    {-tmp_filename:required}
    {-filename ""}
} {

    Attach files to a object requirement
} {

    set item_id [db_nextval acs_object_id_seq]

    db_transaction {
	content::item::new \
	    -item_id $item_id \
	    -name "${filename}-${item_id}" \
	    -parent_id $parent_id \
	    -package_id [ad_conn package_id] \
	    -content_type "content_item" \
	    -creation_user [ad_conn user_id] \
	    -creation_ip [ad_conn peeraddr]
	
	set n_bytes [file size $tmp_filename]
	set mime_type [ns_guesstype $tmp_filename]
	set revision_id [cr_import_content \
			     -item_id $item_id \
			     -title $filename \
			     -storage_type file \
			     -creation_user [ad_conn user_id] \
			     -creation_ip [ad_conn peeraddr] \
			     -description $filename \
			     -package_id [ad_conn package_id] \
			     $parent_id \
			     $tmp_filename \
			     $n_bytes \
			     $mime_type \
			     "file-${filename}-${item_id}"
			]
	
	item::publish -item_id $item_id -revision_id $revision_id
    }


    return $revision_id
}








namespace eval cn_core::util {}


namespace eval cn_categories {}

namespace eval cn_categories::category {}


ad_proc -public  cn_categories::import_csv_file {
    {-input_file:required}
    {-type ""}
    {-parent_id ""}
} {

    Imports CSV files to add categories
} {

    ns_log Notice "Running ad_proc cn_categories::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    foreach line $lines {
	set line [split $line {;}] 

	
	ns_log Notice "LINE $line"

	set code [lindex $line 0]
	set name [lindex $line 1]

	set class_id [cn_categories::get_category_id -code $code -type "cn_assurance"] 
	  
	if {$class_id eq "null"} {  
	    ns_log Notice "Add class $name | "
	    
	    set class_id [cn_categories::category::new \
			      -code $code \
			      -pretty_name $name \
			      -parent_id $parent_id \
			      -object_type $type \
			      -package_id [ad_conn package_id]]
	}	
    }
    
    return
}


ad_proc -public cn_categories::category::new {
    {-pretty_name ""}
    {-name ""}
    {-parent_id ""}
    {-package_id ""}
    {-object_type ""}
} {

    Adds a new category
} {    
    
    set category_id [db_nextval acs_object_id_seq]
    
    if {$name == ""} {
	set name [util_text_to_url -replacement "" -text $pretty_name]
    }

    if {$package_id == ""} {
	set package_id [ad_conn package_id]
    }

    db_transaction {
	db_dml insert_category {
	    INSERT INTO cn_categories (
				       category_id,
				       package_id,
				       parent_id,
				       pretty_name,
				       name,
				       object_type
				       ) VALUES (
						 :category_id,
						 :package_id,
						 :parent_id,
						 :pretty_name,
						 :name,
						 :object_type
				       )
	}
    }
    
    return $category_id
}
ad_proc -public cn_categories::category::delete {
    category_id
} {
    Deletes category
} {

    # If category is parent of others remove the children first

    

    set children_ids [db_list select_children_ids {
	SELECT category_id FROM cn_categories WHERE parent_id = :category_id
    }]

    if {[exists_and_not_null children_ids]} {
	foreach child_id $children_ids {
	    cn_categories::category::delete $child_id 
	}
    }

    #if category is a leaf node just remove it
    db_dml delete_category {
	DELETE FROM cn_categories WHERE category_id = :category_id
    }
    

    return
}



ad_proc -public cn_categories::get_category_id {
    {-code ""}
    {-name ""} 
    {-type ""}
    
    
} {
    Returns category_id
} {

    if {$code ne ""} {	

        set code [util_text_to_url -replacement "" -text $code]
    
    	return [db_string select_category_id {
	    SELECT category_id FROM cn_categories
	    WHERE code = :code AND object_type = :type
	} -default null]

    } elseif {$name ne ""} {
	      
	set name [util_text_to_url -replacement "" -text $name]
	
	return [db_string select_category_id {
	    SELECT category_id FROM cn_categories
	    WHERE name = :name AND object_type = :type
	} -default null]
    }

}

ad_proc -public cn_core::item_exists {
    {-items}
    {-chassi}
} {
    Checks if the record is  already in the list 
} {
    
    if {![exists_and_not_null chassi]} {
	return 1
    }
    
    foreach item $items {
	#ns_log Notice "$chassi | $item"
	if {[string equal $chassi $item]} {
	    return 1
	}
    }
    
    return 0
}


ad_proc -public cn_core::format_output_line {
    {-line}
} {
    Format output line to BA standards
} {
    #ns_log Notice "FORMAT LINE: $line"

    set suplemento [format "%15d" 0]
    set tipomov [format "%1s" "I"]

    set numero [format "%-15s" [lindex $line 0]]
    set vigencia [format "%-16s" [lindex $line 1]]
    set renavam [format "%-30s" [lindex $line 2]]    	
    set desc [format "%-80s" [lindex $line 3]]
    set contrato [format "%-18s" [lindex $line 4]]
    set chassi [format "%-17s" [lindex $line 5]]
        
    return "${contrato}${suplemento}${chassi}${numero}${tipomov}${desc}${vigencia}${renavam}\r"

}




ad_proc -public cn_core::mount_output_line {
    {-line} 
} {
    Prepare input line to output
} {
    
    set elements [split $line {;}]
    #ns_log Notice "ELEMENTS: $elements"
    set i 0

    foreach element $elements {
	switch $i {
            0 {
		#numero - chave do pedido( chave principal e unica do registro do cliente)
		#ns_log Notice "ELEMENT $element"

                lappend output_line [lindex $element 0]
		#ns_log Notice "APPEND LINE $output_line"
	    }

	    1 { 
		# vigencia
		#ns_log Notice "ELEMENT $element"
		set date [split [lindex $element 0] {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"

                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]

		lappend output_line "${date1}${date2}"
		#ns_log Notice "APPEND LINE $output_line"
	   	
	    }

	    2 {
	       
		#ns_log Notice "ELEMENT $element"
                # renavam 
		set renavam [lindex $element [expr [llength $element] - 1]]
		lappend output_line $renavam 

		#ns_log Notice "APPEND LINE $output_line"
		#desc veic(Nome do usuario da assitencia) - renavam(sub-chave principal e unica do registro do cliente)
	        set desc [lreplace $element end-1 end]
                set desc [lreplace $desc 0 1]
		set desc [join $desc ""]

                lappend output_line $desc
		#ns_log Notice "APPEND LINE $output_line"

		#ns_log Notice "DESC $desc"
		
		if {[regexp -all "opic" $desc]} {
		    ns_log Notice "Topic" 
		    set contrato 40000162449
		    #ns_log Notice "$contrato"
		    lappend output_line $contrato
		}
		if {[regexp -all "owner" $desc]} {
		    ns_log Notice "Towner" 
		    set contrato 40000162448
		    #ns_log Notice "$contrato"
		    lappend output_line $contrato
		}
		

            }

	    3 {
		#ns_log Notice "ELEMENT $element"
		
		#chassi
		lappend output_line [lindex $element 0]
		#ns_log Notice "APPEND LINE $output_line"
            }
	}
	
	incr i
    }
    
    return $output_line
}


ad_proc -public cn_core::export_csv_to_txt {
    {-input_file}
    {-output_file}
} {
    Export CSV file to TXT
} {

    ns_log Notice "Running ad_proc export_csv_to_txt"
    # Input File
    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    # Output file
    set filename "[acs_root_dir]/www/${output_file}"
    set output_file [open "[acs_root_dir]/www/${output_file}" w]
    
    set items [list]
    set i 0
    set duplicated 0

    set count_towner 0
    set count_topic 0

    foreach line $lines {
	#ns_log Notice "LINE: $line"
	set output_line [mount_output_line -line $line]

	#ns_log Notice "MOUNTED LINE: $output_line"
	#checks if the chassi already exists within the list "items"

	set exists_p [item_exists -items $items -chassi [lindex $output_line 5]]

	#ns_log Notice "EXISTS $exists_p"
	if {$exists_p == 1} {
	    incr duplicated
	}
	if {$exists_p == 0} {
	    
	    lappend items [lindex $output_line 5]
	    
	    # format output to BA standards 
	    set output_line [cn_core::format_output_line -line $output_line]
	    
	    #inserts line within output file
	    puts $output_file $output_line    
	    incr i
	    ns_log Notice "Added $i"

	}
	#ns_log Notice "OUTPUT LINE [lindex $output_line 2]"
	if {[regexp -all "opic" [lindex $output_line 2]]} {
	    #ns_log Notice "Topic" 
	    incr count_topic 
	}
	if {[regexp -all "owner" [lindex $output_line 2]]} {
	    incr count_towner 
	}

	set output_line ""


    }
    close $output_file

    ns_log Notice "$filename"
    ns_log Notice "Duplciated $duplicated"
    ns_log Notice "Added  $count_towner Towners | $count_topic Topics"
    ns_returnfile 200 "text/plain; charset=iso-8859-2" "$filename"
    
    return
    #ns_return 200 text/plain "$output_file" return
    
}


