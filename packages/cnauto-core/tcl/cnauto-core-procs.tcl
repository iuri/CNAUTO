# /packages/cnauto-core/tcl/cnauto-core-procs.tcl
ad_library {

    CNAuto Core core package procs

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04

}

namespace eval cnauto_core {}
namespace eval cn_core::util {}



ad_proc -public cnauto_core::item_exists {
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


ad_proc -public cnauto_core::format_output_line {
    {-line}
} {
    Format output line to BA standards
} {
    #ns_log Notice "FORMAT LINE: $line"

    set suplemento [format "%15d" 0]
    set tipomov [format "%1s" "A"]

    set numero [format "%-15s" [lindex $line 0]]
    set vigencia [format "%-16s" [lindex $line 1]]
    set renavam [format "%-30s" [lindex $line 2]]    	
    set desc [format "%-80s" [lindex $line 3]]
    set contrato [format "%-18s" [lindex $line 4]]
    set chassi [format "%-17s" [lindex $line 5]]
        
    return "${contrato}${suplemento}${chassi}${numero}${tipomov}${desc}${vigencia}${renavam}\r"

}




ad_proc -public cnauto_core::mount_output_line {
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


ad_proc -public cnauto_core::export_csv_to_txt {
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
	    set output_line [cnauto_core::format_output_line -line $output_line]
	    
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





ad_proc -public cn_core::util::treat_string {
    {-str}
} {
    Removes special chars from the string
} {

    set str [string map {à á â ã ç é ê í óôõú-" "" " " ""} [string tolower $str]]

    return $str 
}
