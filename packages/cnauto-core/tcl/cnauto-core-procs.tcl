# /packages/cnauto-core/tcl/cnauto-core-procs.tcl

ad_library {

    CNAuto Core core package procs

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04

}

namespace eval cnauto_core {}

ad_proc -public cnauto_core::format_input_line {
    {-line} 
} {
    Format the output line to insert within the file
} {
    
    set elements [split $line {;}]
    
    
    set contrato [format "%18s" "0"]
    set suplemento [format "%15d" 0]
    set tipomov [format "%1s" "I"]
    
    
    set i 0
    foreach element $elements {
	switch $i {
            0 {
                #numero - chave do pedido( chave principal e unica do registro do cliente)
                set numero [format "%15s" [lindex $element 0]]
            }

	    1 { 
		# vigencia
		set date [split [lindex $element 0] {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"

                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]
                set vigencia [format "%16s" "${date1}${date2}"]
	    }

	    2 {
		#desc veic(Nome do usuario da assitencia) - renavam(sub-chave principal e unica do registro do cliente)
		set desc $element
				
                set renavam [lindex $desc [expr [llength $desc] - 1]]
		set renavam [format "%30s" $renavam] 
                set desc [lreplace $desc end-1 end]
                set desc [lreplace $desc 0 1]
                set desc [format "%80s" [join $desc ""]]
	    }

	    3 {
                set chassi [format "%20s" [lindex $element 0]]
	    }

 

	
	}
	
	incr i
    }

    ns_log Notice "$contrato $suplemento $numero $renavam $tipomov $desc $vigencia $chassi\r"
    set output_line "$contrato $suplemento $numero $renavam $tipomov $desc $vigencia $chassi\r"
    
    return $output_line
}

ad_proc -public cnauto_core::line_exists {
    {-items}
    {-line}
} {
    Checks if the record is  already in the list 
} {

    foreach item $items {
	if {[string equal [lindex $line 2] [lindex $item 2]]} {
	    return 1
	}
    }
    
    return 0
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
    set output_file [open "[acs_root_dir]/www/${output_file}" w]
    
    set items [list]
    
    foreach line $lines {
	
	set output_line [format_input_line -line $line]
	
	#checks if the chassi already exists within the list "items"
	set exists_p [line_exists -items $items -line $output_line]
	if {$exists_p == 0} {
	    
	    lappend items $output_line
	    
	    #inserts line within output file
	    puts $output_file $output_line    
	}
	set output_line ""
    }
    close $output_file
}




ad_proc -public cnauto_core::export_csv_to_csv {
    {-input_file}
    {-output_file}
} {
    Export CSV file to CSV
} {

    # Input File
    set input_file [open $filepath r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    # Output file
    set output_file [open $filepath w]
    
    set items [list]
    
    foreach line $lines {
	
	set output_line [format_input_line -line $line]
	
	#checks if the chassi already exists within the list "items"
	set exists_p [line_exists -items $items -line $output_line]

	if {$exists_p == 0} {
	    
	    lappend items $output_line
	    
	    set output_line [string map {" " ;} $output_line]
	    #inserts line within output file
	    puts $output_file $output_line    
	}
	
	set output_line ""
	
    }
    
    close $output_file
    
}
