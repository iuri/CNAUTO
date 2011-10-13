#set filepath "[acs_root_dir]/www/BRASIF1_071020112.txt"
set filepath "[acs_root_dir]/www/brasilassistencia.csv"


ns_log Notice $filepath

set input_file [open $filepath r]
set lines [split [read $input_file] \n]
close $input_file
set i 0

foreach line $lines {
    set record $line
    set elements [split $line {;}]

    	

    ns_log Notice "$line"
    set i 0
    foreach element $elements {
	ns_log Notice "$element"

	
	set contrato "Omar"
	set suplemento 0
	set tipomov I

	# get Renavam from DESCVEIC
	switch $i {
	    3 { # vigencia
		set vigencia [lindex $element 0]
	    }
	    
	    4 { #renavam -  desc veiculo
		set desc [lindex $element 0]
		
		set element [lindex $element 0]
		#ns_log Notice "$element | [string length $element] | [llength $element]"
		
		set renavam [lindex $element [expr [llength $element] - 1]]
		#ns_log Notice "$renavam"
	    }
	    
	    5 {
		set chassi
	    }
	    #numero - chave do pedido
	    6 {
		set numero [lindex $element 0]
	    }
	}
	
	# 8 columns
	#1 CONTRATO - 2 SUPLEMENTO - 3 CHASSI - 4 NUMERO - 5 TIPO MOV - 6 DESC VEIC - 7 VIGENCIA - 8 RENAVAN
	
	incr i
    }
}


