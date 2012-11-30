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
    set chassis [format "%-17s" [lindex $line 1]]
    set renavam [format "%-30s" [lindex $line 2]]    	
    set desc [format "%-80s" [lindex $line 3]]
    set contrato [format "%-18s" [lindex $line 4]]
    set numero [format "%-15s" [lindex $line 5]]
        
    return "${contrato}${suplemento}${chassis}${numero}${tipomov}${desc}${vigencia}${renavam}\r"

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
	    2 { 
		# vigencia
		set date [split $element {/}]
                set date1 "[lindex $date 2][lindex $date 1][lindex $date 0]"
		
                set date "[lindex $date 2]-[lindex $date 1]-[lindex $date 0]"
                set date2 [clock format [clock scan "1 year" -base [clock scan $date]] -format %Y%m%d]
		
		set vigencia  "${date1}${date2}"
	   	
	    }
	    5 {
		# Chassis
		set chassis $element
            }
	    
	    3 {
		# Renavam
		set renavam $element
	    }
	    4 {
		# Desc
		set desc $element
            }	    
	}
	
	incr i
    }
    
    # Contrato
    if {[regexp -all "LSY" $chassis]} {
	#ns_log Notice "Topic" 
	set contrato 40000162449
    } else {
	#ns_log Notice "Towner" 
	set contrato 40000162448
    }
    
    # Numero
    set numero [ns_rand 1000000]
    
    lappend output_line $vigencia
    lappend output_line $chassis
    lappend output_line $renavam
    lappend output_line $desc
    lappend output_line $contrato
    lappend output_line $numero

    return $output_line    
}




ad_proc -public cn_core::abeiva::import_csv_file {
    {-input_file:required}
    {-output_file}
    {-insert_vehicles_p f} 
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
    set duplicated 0

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
	62012 0
	72012 0
	82012 0
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
	62012 0
	72012 0
	82012 0
    } 
    
    # Output file
    set filename "[acs_root_dir]/www/${output_file}"
    set output_file [open "${filename}" w]
    
    foreach line $lines {
	set line [split $line ";"]
	
	if {$line ne ""} {	    
	    ns_log Notice "$line"

	    ##############
	    # Insert vehicle into the database
	    ##############

	    ## This code needs to be improve. To create abeiva library and create new ad_procs to improve legibility  and maintainace 
	    ns_log Notice "INSERT $insert_vehicles_p"

	    if {$insert_vehicles_p eq t} {
		[cn_core::import_from_abeiva -line $line]
	    }

	    set output_line [cn_core::abeiva::mount_output_line -line $line]

	    ns_log Notice "OUTPUT $output_line"
	        
	    set exists_p [cn_core::item_exists -items $items -chassi [lindex $output_line 3]]
	    
	    if {$exists_p == 1} {
		incr duplicated
	    }

	    if {$exists_p == 0} {		
		
		lappend items [lindex $output_line 1]

		# Date
		set date [lindex $line 2] 
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

		if {[regexp -all {LSY} [lindex $line 5]]} {
		    incr topic_units($pos)
		}

		if {[regexp -all {LKH} [lindex $line 5]]} {
			incr towner_units($pos)
		}
		
		
		# format output to BA standards 
		set output_line [cn_core::abeiva::format_output_line -line $output_line]
		

		ns_log Notice "OUTPUT FINAL  $output_line"
		#inserts line within output file
		puts $output_file $output_line    
		incr i
		
	    }
	}
    }
    
    
    ns_log Notice "Total $i | Towners: [parray towner_units] | Topics: [parray topic_units]"
    
    close $input_file

    ns_log Notice "OUT $output_file"
    cn_core::attach_file \
 	-parent_id [ad_conn package_id] \
	-tmp_filename $filename \
	-filename [file tail $filename]
    
    return 
}













ad_proc -public cn_core::import_from_abeiva {
    {-line:required}
} {
} {
    
    ns_log Notice "Insert vehicle"
    ns_log Notice "LINE $line"
    
    set vin [string trim [lindex $line 1]]
    set renavam_code [lindex $line 2]
    
    # Check Renavam Code
    set resource_id [db_string select_resource_id {
	SELECT resource_id FROM cn_vehicle_renavam cvr WHERE cvr.code = :renavam_code
    } -default "" ]
    
    
    ns_log Notice "RENAVAM CODE $renavam_code "
    if {![exists_and_not_null resource_id]} {
	#  ad_return_complaint 1 "The renavam code does not exists for this vehicle: <b>$vin</b>! Please <a href=\"javascript:history.go(-1);\">go back and fix it!</a> "
	
    } 
    
    # Check VIN (chassis)
    set vehicle_exists_p [db_0or1row select_vehicle_id {
	SELECT vehicle_id FROM cn_vehicles WHERE vin = :vin
    }]
    
    ns_log notice "$vehicle_exists_p"
    if {$vehicle_exists_p}  {
	# ad_return_complaint 1 "The chassis already exists on the database! Please <a href=\"javascript:history.go(-1);\">go back and fix it!</a> "
    } else {
	ns_log Notice "FLAG1"
	set license_date [string trim [lindex $line 0]]
	set license_date [string map {/ -} $license_date]
	
	if {$license_date ne ""} {
	    set license_date "[template::util::date::get_property year $license_date] [template::util::date::get_property month $license_date] [template::util::date::get_property day $license_date]"
	}
	ns_log Notice "FLAG2"
	set license_date [string trim $license_date]
	
	set distributor_code [lindex $line 7]
	set distributor_id [db_string select_distributor_id {
	    SELECT person_id FROM cn_persons WHERE code = :distributor_code
	} -default ""]
	
	if {$distributor_id eq ""}  {
	    #	ad_return_complaint 1 "The distributor does not exists on the database: <b>$distributor_code</b>. Please <a href=\"javascript:history.go(-1);\">go back and fix it!'</a> "
	} 
	
	# this ad_proc needs to be fixed/redesigned. With renavam info into cd_resources most of info became unnecessary now.
	
	
	ns_log Notice "NEW $vin | $resource_id | $license_date | $distributor_id"
	cn_resources::vehicle::new \
	    -vin $vin \
	    -resource_id $resource_id \
	    -license_date $license_date \
	    -distributor_id $distributor_id \
	    -creation_ip [ad_conn peeraddr] \
	    -creation_user [ad_conn user_id] \
	    -context_id [ad_conn package_id]
    }
    
}




##########################################################
#### FENABRAVE
##########################################################

namespace eval cn_core::fenabrave {}

ad_proc -public cn_core::fenabrave::mount_output_line {
    {-line:required}
} {
    Format the line to export to a file

} {

    ns_log Notice "FORMAT LINE $line"
    foreach element $line {
	ns_log Notice "ELEMENT $element"
    }


    #########################################################################
    # output line
    # #######################################################################
    # TipodeMovimento IN - Incluir, AL - Alterar, EX - Excluir [2]
    set TipodeMovimento [format "%-2s" "IN"]
    # Chave (apolice + contrato) [20]
    set chave [format "%-20s" ""] 
    # ProdutoEurop 
    set ProdutoEurop [format "%3s" ""] 
    # Nome 
    set Nome [format "%-40s" ""]
    # Endereco Completo
    set EndCompl [format "%-40s" ""]
    # Complemento do Endereco
    set ComplEnd [format "%-10s" ""]
    # Cidade
    set cidade [format "%-30s" ""]
    # CEP
    set cep [format "%-8s" ""]
    # Estado
    set estado [format "%-2s" ""]
    # Bairro
    set bairro [format "%-20s" ""] 
    # CPF/CNPJ 
    set cpf_cnpj [format "%-14s" ""]
    # TipoPessoa(F/J) 
    set tipo_pessoa [format "%-1s" ""]
    # Tel1 
    set tel1 [format "%-10s" ""]
    # Tel2
    set tel2 [format "%-10s" ""]
    # DataEmissaoApolice DDMMAAAA
    set dt_emi_apol [format "%-8s" ""] 
    # DataInicioVigencia DDMMAAAA
    set dt_ini_vig [string map {/ ""} [lindex $line 2]]
    set dt_ini_vig [format "%-8s" ""]


    # DataTerminoVigencia DDMMAAAA
    set dt_ter_vig [split [lindex $line 2] {/}]
    set dt_ter_vig "[lindex $dt_ter_vig 2][lindex $dt_ter_vig 1][lindex $dt_ter_vig 0]"
    set dt_ter_vig [clock format [clock scan "1 year" -base [clock scan $dt_ter_vig]] -format %d%m%Y]

    set dt_ter_vig [format "%-8s" "$dt_ter_vig"]
    # PessoaContato
    set pessoa_contato [format "%-40s" ""]
    # TelContato
    set tel_contato [format "%-20s" ""]
    # MarcaAutomovel
    set marca_auto [format "%-30s" "[lindex $line 4]"]
    # Modelo 
    set modelo [format "%-20s" "[lindex $line 4]"]
    # Ano
    set ano [format "%-4s" ""]
    # Combustivel: AL - alcool, GA - gaasolina, DI - diesel, GN - gas NAtural, EL - eltricidade
    set combustivel [format "%-2s" ""]
    # Placa
    set placa [format "%-8s" ""]
    # Chassi
    set chassi [format "%-18s" "[lindex $line 5]"]
    # Versao Europ
    set versao_europ [format "%-3s" ""]
    # Numero do Item da Apolice
    set num_item_apol [format "%-20s" ""]
    # Data de cancelamento da apolice DDMMAAAA
    set dt_can_apol [format "%-8s" ""]
    # Data de nascimento DDMMAAAA
    set dt_nasc [format "%-8s" ""]
    # Estado Civil
    set estado_civil [format "%-1s" ""]
    # Observacao
    set obs [format "%-200s" ""]
    # Flag VIP 
    set flag_vip [format "%-1s" ""]
    # Sexo
    set sexo [format "%-1s" ""]
    # Tipo seguro
    set tipo_seg [format "%-30s" ""]
    # Uso veiculo
    set uso_veic [format "%-10s" ""]
    #v_veic
    set v_veic [format "%-30s" ""]
    # Tipo Contrato
    set tipo_contrato [format "%-2s" ""]


    set output_line "${TipodeMovimento}${chave}${ProdutoEurop}${Nome}${EndCompl}${ComplEnd}${cidade}${cep}${estado}${bairro}${cpf_cnpj}${tipo_pessoa}${tel1}${tel2}${dt_emi_apol}${dt_ini_vig}${dt_ter_vig}${pessoa_contato}${tel_contato}${marca_auto}${modelo}${ano}${combustivel}${placa}${chassi}${versao_europ}${num_item_apol}${dt_can_apol}${dt_nasc}${estado_civil}${obs}${flag_vip}${sexo}${tipo_seg}${uso_veic}${v_veic}${tipo_contrato}"

    
   return $output_line

}




ad_proc -public cn_core::fenabrave::import_csv_file {
    {-input_file:required}
    {-insert_vehicles_p f} 
} {
    Import Abeiva's spreadsheet

} {

    ns_log Notice "Running ad_proc import_csv_to_txt"

    # Input File
    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file


    set date_now [clock format [clock scan "now"] -format "%d%m%Y"]

    set filename "${date_now}.918.AUTO.INC.001.txt"
    set output_file [open "[acs_root_dir]/www/$filename" w]

    puts $output_file [format "%-1s" "H"][format "%-20s" "918 CNAUTO S.A."][format "%-8s" "$date_now"][format "%-30s" "$filename"][format "%-30s" ""][format "%-1s" "F"][format "%-100s" "jorge@cnauto.com.br"]


    set items [list]
    set count 0
    foreach line $lines {
	set line [split $line ";"]

	if {$line ne ""} {
	    ns_log Notice "$line"
	    incr count 
	    set output_line [cn_core::fenabrave::mount_output_line -line $line]
	    
	    ns_log Notice "FORMATED LINE: $output_line"
	    
	    puts $output_file $output_line
	    
	}	
    }
   
    puts $output_file [format "%-1s" "T"][format "%-8s" "${count}"][format "%-8s" "${count}"][format "%-8s" "$count"][format "%-8s" "${count}"]

    close $output_file


    

#    cn_core::attach_file \
 	-parent_id [ad_conn package_id] \
	-tmp_filename "[acs_root_dir]/www/$filename" \
	-filename [file tail $filename]
    

    return 
}



