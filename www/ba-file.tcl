ad_page_contract {
    Create file for Brasil Assistencia
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
    
}


ad_proc -public format_input_line {
    {-line} 
} {
    Format the output line to insert within the file
} {
    
    #ns_log Notice "Running ad_proc format_input_line"
    set elements [split $line {;}]
    
    
    set contrato "Omar"
    set suplemento 0
    set tipomov I
    
    
    #    ns_log Notice "$line"
    set i 0
    foreach element $elements {
	#ns_log Notice "$element $i"
	switch $i {
	    3 { 
		# vigencia
		set date [split [lindex $element 0] {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"

                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]
                set vigencia "${date1}${date2}"

		#ns_log Notice "$vigencia"
	    }

	    4 {
		set desc $element
		
                #ns_log Notice "$element | [string length $element] | [llength $element]"
		
                set renavam [lindex $desc [expr [llength $desc] - 1]]
		
                set desc [lreplace $desc end-1 end]
                set desc [lreplace $desc 0 1]
                set desc [join $desc ""]
                #ns_log Notice "DESC: $desc | $renavam"

                #ns_log Notice "$renavam"

	    }

	    5 {
                set chassi [lindex $element 0]
	    }

            6 {
                #numero - chave do pedido
                set numero [lindex $element 0]
            }


	
	}
	# get Renavam from DESCVEIC
	# 8 columns
	#1 CONTRATO - 2 SUPLEMENTO - 3 CHASSI - 4 NUMERO - 5 TIPO MOV - 6 DESC VEIC - 7 VIGENCIA - 8 RENAVAN
	
	incr i
    }

    # ns_log Notice "$contrato $suplemento $chassi $numero $tipomov $desc $vigencia $renavam"
    #set output_line "$contrato $suplemento"
    set output_line "$contrato $suplemento $chassi $numero $tipomov $desc $vigencia $renavam\r"
    
    return $output_line
}

ad_proc -public line_exists {
    {-items}
    {-line}
} {
    Checks if the record is  already in the list 
} {
    
    #ns_log Notice "Running ad_proc line_exists"

    foreach item $items {
	#ns_log Notice "[lindex $line 2] - [lindex $item 2]"
	if {[string equal [lindex $line 2] [lindex $item 2]]} {
	    #ns_log Notice "ACHOU"
	    return 1
	}
    }
    
    return 0
}



# Input File
#set filepath "[acs_root_dir]/www/test.csv"
set filepath "[acs_root_dir]/www/brasilassistencia.csv"
set input_file [open $filepath r]
set lines [split [read $input_file] \n]
close $input_file

# Output file
set filepath "[acs_root_dir]/www/BRASIF1_14102011.txt"
#set filepath "[acs_root_dir]/www/teste.txt"
set output_file [open $filepath w]

set items [list]

foreach line $lines {

    set output_line [format_input_line -line $line]

    #checks if the chassi already exists within the list "items"
    set exists_p [line_exists -items $items -line $output_line]
    #ns_log Notice "EXISTS $exists_p"
    if {$exists_p == 0} {
	
	#ns_log Notice "INSERT LINE: $output_line"
	lappend items $output_line
	
	#inserts line within output file
	puts $output_file $output_line    
    }
    
    set output_line ""
    
}

close $output_file
