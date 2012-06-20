# /packages/cnauto-core/tcl/cnauto-core-procs.tcl
ad_library {

    CNAuto Core core package procs

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04

}


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











#######################
# ABEIVA 
###############
namespace eval cn_core::abeiva {}

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


ad_proc -public cn_core::abeiva::format_output_line {
    {-line}
} {
    Format output line to BA standards
} {
    #ns_log Notice "FORMAT LINE: $line"

    set suplemento [format "%15d" 0]
    set tipomov [format "%1s" "I"]
    set vigencia [format "%-16s" [lindex $line 0]]
    set chassi [format "%-17s" [lindex $line 1]]
    set renavam [format "%-30s" [lindex $line 2]]    	
    set desc [format "%-80s" [lindex $line 3]]
    set contrato [format "%-18s" [lindex $line 4]]
    set numero [format "%-15s" [lindex $line 5]]
        
    return "${contrato}${suplemento}${chassi}${numero}${tipomov}${desc}${vigencia}${renavam}\r"

}











ad_proc -public cn_core::abeiva::mount_output_line {
    {-line} 
} {
    Prepare input line to output
} {
    
    set i 0
#    ns_log Notice "LINE $line"
   
    foreach element $line {
	switch $i {
	    0 { 
		# vigencia
		set date [split $element {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"
		
                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]

		lappend output_line "${date1}${date2}"
	   	
	    }

	    1 {
		# Chassi
		set chassi $element
		lappend output_line $chassi		
            }
	    
	    2 {
		# Renavam
		set renavam $element
		lappend output_line $renavam 
	    }
	    3 {
		# Desc
		set desc $element
		lappend output_line $desc
            }	    
	}
	
	incr i
    }
    
    # Contrato
    if {[regexp -all "LSY" $chassi]} {
	#ns_log Notice "Topic" 
	set contrato 40000162449
	#ns_log Notice "$contrato"
	lappend output_line $contrato
    } else {
	#ns_log Notice "Towner" 
	set contrato 40000162448
	#ns_log Notice "$contrato"
	lappend output_line $contrato
    }
    
    # Numero
    set numero [ns_rand 1000000]
    lappend output_line $numero
    
    
    
    #   ns_log Notice "Output: $output_line"
    return $output_line    
}




ad_proc -public cn_core::abeiva::import_csv_file {
    {-input_file}
    {-output_file}
} {
    Import Abeiva's spreadsheet

} {

    ns_log Notice "Running ad_proc export_csv_to_txt"

    # Input File
    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    
    set items [list]
    set i 0    
    set count_towner 0
    set count_topic 0
    
    #Array
    array set towner_units {
	92010 0
	102010 0
	112010 0
	122010 0
	12011 0
	22011 0
	32011 0
	42011 0
	52011 0
	62011 0
	72011 0
	82011 0
	92011 0
	102011 0
	112011 0
	122011 0
	12012 0
	22012 0
	32012 0
	42012 0
	52012 0
    }
    
    #Array
    array set topic_units {
	92010 0
	102010 0
	112010 0
	122010 0
	12011 0
	22011 0
	32011 0
	42011 0
	52011 0
	62011 0
	72011 0
	82011 0
	92011 0
	102011 0
	112011 0
	122011 0
	12012 0
	22012 0
	32012 0
	42012 0
	52012 0
    } 
    
    # Output file
    set filename "[acs_root_dir]/www/${output_file}"
    set output_file [open "${filename}" w]

    foreach line $lines {
	set line [split $line ";"]
	
	if {$line ne ""} {	    
	    set output_line [cn_core::abeiva::mount_output_line -line $line]
	    
	    set exists_p [cn_core::item_exists -items $items -chassi [lindex $output_line 1]]
	    
	    if {$exists_p == 1} {
		incr duplicated
	    }

	    if {$exists_p == 0} {		
		
		lappend items [lindex $output_line 1]

		# Date
		set date [lindex $line 0] 
		set date [split $date /]
		set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
		
		if {$date ne "--emp_data"} {
		    set month [db_string select_month { 
			SELECT EXTRACT (month from timestamp :date) 
		    }]
		    set year [db_string select_year { 
			SELECT EXTRACT (year from timestamp :date) 
		    }]
		    
		    set pos "${month}${year}"		
		    
		}   
		if {[regexp -all {LSY} [lindex $line 1]]} {
		    incr topic_units($pos)
		}
		if {[regexp -all {LKH} [lindex $line 1]]} {
			incr towner_units($pos)
		}
		
		
		# format output to BA standards 
		set output_line [cn_core::abeiva::format_output_line -line $output_line]
		
		#inserts line within output file
		puts $output_file $output_line    
		incr i
		
	    }
	    

	    
	}
    }
    
    
    ns_log Notice "Total $i | Towners: [parray towner_units] | Topics: [parray topic_units]"
    
    close $input_file
    
    return 
}
