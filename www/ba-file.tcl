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
    
    set elements [split $line {;}]
    
    
    set contrato "Omar"
    set suplemento 0
    set tipomov I
    
    
    set i 0
    foreach element $elements {
	switch $i {
	    3 { 
		# vigencia
		set date [split [lindex $element 0] {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"

                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]
                set vigencia "${date1}${date2}"
	    }

	    4 {
		set desc $element
				
                set renavam [lindex $desc [expr [llength $desc] - 1]]
		
                set desc [lreplace $desc end-1 end]
                set desc [lreplace $desc 0 1]
                set desc [join $desc ""]
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

    ns_log Notice "$contrato $suplemento $chassi $numero $tipomov $desc $vigencia $renavam"
    set output_line "$contrato $suplemento $chassi $numero $tipomov $desc $vigencia $renavam\r"
    
    return $output_line
}

ad_proc -public line_exists {
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


ad_proc -public export_csv_to_csv {
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

ad_proc -public export_csv_to_txt {
    {-input_file}
    {-output_file}
} {
    Export CSV file to TXT
} {

    # Input File
    set input_file [open "[acs_root_dir]/www/${input_file}" r]
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


#set input_file "brasilassistencia.csv"
#set output_file "BRASIF1_14102011.txt"




ad_form -html { enctype multipart/form-data } -name export_file -form {
    {input_file:file {label "#cn-auto.Input_file#"} {html "size 30"}}
    {output_file:text {label "#cn-auto.Output_file#"} {html "size 30"}}
} -on_submit {


    
    export_csv_to_txt -input_file $input_file -output_file $output_file
    
}