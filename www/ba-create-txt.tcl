ad_page_contract {
    Create file for Brasil Assistencia
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-14
    
}


set input_file [open "[acs_root_dir]/ba-saida.txt"]

set lines [split [read $input_file] \n]

#gets $input_file line


#Fields
set str1 

#ns_log Notice "LINE: $lines"

foreach line $lines {
    set tam [string length $line]
    ns_log Notice "LINE: $line - $tam"

}
close $input_file







