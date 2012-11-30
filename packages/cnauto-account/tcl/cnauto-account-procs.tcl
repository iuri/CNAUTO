ad_library {
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    creation-date 2012-07-31
}

namespace eval cn_account {}

ad_proc -public cn_account::find_xml {
    {-path:required}
    {-files 0}
    {-directories 0}
} {

    Search xml files
} {
    ns_log Notice "Running ad_proc fin_xml"
    ns_log Notice "PATH $path"
    
    if { [catch { set items [glob ${path}/*] } errorMsg]} {
	ns_log Notice "EMPTY FOLDER!!!"
	return
	
    } else {
	#	    set items [glob ${path}/*]
	
	foreach item $items {
#	    ns_log Notice "ITEM $item"
	    if {[file isdirectory $item]} {
		ns_log Notice "IS Directory"
		incr directories
		cn_account::find_xml -path $item -files $files -directories $directories
	    } elseif {[file isfile $item] && [string equal [ns_guesstype $item] "text/xml"]} {
#		ns_log Notice " [ns_guesstype $item]"
		incr files
		#	cn_account::import_nfe_xml -input_file "${path}/*"
	    }
	    
	}		    
    }	
    ns_log Notice "$directories | $files"
    return
}


ad_proc -public cn_account::import_nfe_xml {
    {-input_file ""}
} {
    
    Imports NFE XML files
    
} {
    
    ns_log Notice "Running ad_proc"
    
    set tmpfile $input_file
    
    set input_file [open "$input_file" r]
    set xml [read $input_file]
    close $input_file

    #   ns_log Notice "$xml"   
    set doc [dom parse $xml]
    
    ns_log Notice "DOC $doc"
    
    if {[catch {set root [$doc documentElement]} err]} {
	error "Error parsing XML: $err"
    }
    
    set output_list [list]
    
    set nfe [list]


    ns_log Notice "NAME [$root nodeName]"
    if {[string equal [$root nodeName] "procCancNFe"]} {
	
	set root  [$root getElementsByTagName retCancNFe]
	set root  [$root getElementsByTagName infCanc]	

	# NFe Access key
	set node  [$root getElementsByTagName chNFe]
	set nodeName [$node nodeName]
	lappend nfe  [list "key" "[[$node firstChild] nodeValue]"]
	
	set key [[$node firstChild] nodeValue]
	ns_log Notice "KEYFRTR $key"
	set nfe_exists_p [db_0or1row select_nfe_key {
	    SELECT nfe_id FROM cn_nfes WHERE key = :key
	}]
	
	if {!$nfe_exists_p} {	    
	    ns_log Notice "NFe does not exists. It can not be canceled"
	    return
	}

	# NFE Protocol 
	set node [$root getElementsByTagName nProt]
	ns_log Notice "$node"
	set nodeName [$node nodeName]
	lappend nfe [list "prot" "[[$node firstChild] nodeValue]"]
	    
	# NFE Registration Date
	set node [$root getElementsByTagName dhRecbto]
	set nodeName [$node nodeName]
	lappend nfe [list "date" "[[$node firstChild] nodeValue]"]
	
	# NFE Status
	set node [$root getElementsByTagName cStat]
	set nodeName [$node nodeName]
	lappend nfe [list "status" "[[$node firstChild] nodeValue]"]
	
	# NFE motive
	set node [$root getElementsByTagName xMotivo]
	set nodeName [$node nodeName]
	lappend nfe [list "motive" "[[$node firstChild] nodeValue]"]
	
	cn_account::nfe::cancel \
	    -nfe $nfe \
	    -creation_user [ad_conn user_id] \
	    -creation_ip [ad_conn peeraddr] \
	    -context_id [ad_conn package_id]    
    
	set filename "NFE-$key.xml"
	set file_id [db_string select_item_id {
	    SELECT item_id FROM cr_items WHERE name = :filename
	}]

	fs::add_version \
	    -name "NFE-$key.xml" \
	    -tmp_filename $tmpfile \
	    -item_id $file_id \
	    -creation_user [ad_conn user_id] \
	    -creation_ip [ad_conn peeraddr] \
	    -title "NFE-$key.xml" \
	    -package_id 1840
	


    } else {
	
	if {[$root hasChildNodes]} {
	    set childNodes [$root childNodes]
	    
	    # NFe Access key
	    set node  [$root getElementsByTagName chNFe]
	    set nodeName [$node nodeName]
	    lappend nfe  [list "key" "[[$node firstChild] nodeValue]"]
	    
	    # NFE Protocol number
	    set node [$root getElementsByTagName nProt]
	    set nodeName [$node nodeName]
	    lappend nfe [list "prot" "[[$node firstChild] nodeValue]"]
	    
	    
	    # NFE Registration Date
	    set node [$root getElementsByTagName dhRecbto]
	    set nodeName [$node nodeName]
	    lappend nfe [list "date" "[[$node firstChild] nodeValue]"]
	    
	    # NFE number
	    set node [$root getElementsByTagName nNF]
	    set nodeName [$node nodeName]
	    lappend nfe [list "number" "[[$node firstChild] nodeValue]"]
	    
	    # NFE serie
	    set node [$root getElementsByTagName serie]
	    set nodeName [$node nodeName]
	    lappend nfe [list "serie" "[[$node firstChild] nodeValue]"]
	    
	    # NFE Status
	    set node [$root getElementsByTagName cStat]
	    set nodeName [$node nodeName]
	    lappend nfe [list "status" "[[$node firstChild] nodeValue]"]
	    
	    # NFE motive
	    set node [$root getElementsByTagName xMotivo]
	    set nodeName [$node nodeName]
	    lappend nfe [list "motive" "[[$node firstChild] nodeValue]"]
	    
	    # NFE Natureza da Operacao
	    set node [$root getElementsByTagName natOp]
	    set nodeName [$node nodeName]
	    lappend nfe [list "nat_op" "[[$node firstChild] nodeValue]"]
	    
	    
	    # NFE total
	    set node [$root getElementsByTagName total]
	    set node [$root getElementsByTagName vNF]
	    set nodeName [$node nodeName]
	    lappend nfe [list "total" "[[$node firstChild] nodeValue]"]
	    
	    # NFE remitter
	    set node [$root getElementsByTagName emit]
	    set node [$node getElementsByTagName CNPJ]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remitter_cnpj" "[[$node firstChild] nodeValue]"]
	    
	    set node [$root getElementsByTagName emit]
	    set node [$node getElementsByTagName xNome]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remitter_name" "[[$node firstChild] nodeValue]"]
	    
	    set node [$root getElementsByTagName emit]
	    set node [$node getElementsByTagName cMun]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remitter_state_reg" "[[$node firstChild] nodeValue]"]
	    
	    # NFEe remittee
	    set node [$root getElementsByTagName dest]
	    set node [$node getElementsByTagName CNPJ]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remittee_cnpj" "[[$node firstChild] nodeValue]"]
	    
	    set node [$root getElementsByTagName dest]
	    set node [$node getElementsByTagName xNome]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remittee_name" "[[$node firstChild] nodeValue]"]
	    
	    set node [$root getElementsByTagName dest]
	    set node [$node getElementsByTagName cMun]
	    set nodeName [$node nodeName]
	    lappend nfe [list "remittee_state_reg" "[[$node firstChild] nodeValue]"]   
	}
	
	ns_log Notice "NFE $nfe"
	set key [lindex [lindex $nfe 0] 1]
	
	ns_log Notice "KEYFRTR $key"
	set nfe_exists_p [db_0or1row select_nfe_key {
	    SELECT nfe_id FROM cn_nfes WHERE key = :key
	}]
	
	if {!$nfe_exists_p} {	    
	    set nfe_id [cn_account::nfe::new \
			    -nfe $nfe \
			    -creation_user [ad_conn user_id] \
			    -creation_ip [ad_conn peeraddr] \
			    -context_id [ad_conn package_id] \
			   ]
  	

	    ns_log Notice "NFEID $nfe_id"
	    if {[info exists nfe_id]} {
		ns_log Notice "$$$$$ [parameter::get -package_id [ad_conn package_id] -parameter \"UseFileStoragePackagep\" -default 1]"
		if {[parameter::get -package_id [ad_conn package_id] -parameter "UseFileStoragePackagep" -default 1]} {
		    
		    # TODO: It needs to implement the whole logic to handle	folders in filestorasge for accounting applications     set folder_id fs::new_folder
		    set mime_type "text/xml"
		    set folder_id 2198
		    
		    ns_log notice  "ADD FILE $input_file"
		    fs::add_file \
			-name "NFE-${nfe_id}-${key}.xml" \
			-parent_id $folder_id \
			-tmp_filename $tmpfile \
			-creation_user [ad_conn user_id] \
			-creation_ip [ad_conn peeraddr] \
			-title "NFE-$key.xml" \
			-package_id 1840 \
			-mime_type $mime_type
		} else {
		    cn_core::attach_file \
			-parent_id $nfe_id \
			-tmp_filename $input_file \
			-filename "NFE-$key.xml"
		    
		}
	    }
	} else {
	    ns_log Notice "Already exists!!!"
	}
    }
    
    
    return 
}


namespace eval cn_account::nfe {} 

ad_proc -public cn_account::nfe::new {
    {-nfe:required}
    {-creation_user ""}
    {-creation_ip ""}
    {-context_id ""}
} {


    Insert a new NFe
} {
    
    
    if {$creation_user == ""} {
	set user_id [ad_conn user_id]
    }
    
    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }

    foreach elem $nfe {
	ns_log Notice "$elem"
	set name [lindex $elem 0]
	set value [lindex $elem 1]
	
	set $name $value
	append sql_args ":${name}, "
	
    }
    
    ns_log Notice "$sql_args"
    db_transaction {
	set nfe_id [db_exec_plsql insert_nfe "
 	    SELECT cn_account_nfe__new (
					$sql_args
					:creation_user,
					:creation_ip,
					:context_id
					)	
	    
	"]	
    }

    return $nfe_id
}


ad_proc -public cn_account::nfe::delete {
    {-nfe_id:required}
} {
    Deletes a NFE
} {

    db_exec_plsql delete_nfe {
	SELECT cn_account_nfe__delete ( :nfe_id );
    }
    
    
    return
}



ad_proc -public cn_account::nfe::cancel {
    {-nfe:required}
} {
    Cancel NFe
} {
    
    foreach elem $nfe {
	ns_log Notice "$elem"
	set name [lindex $elem 0]
	set value [lindex $elem 1]
	
	set $name $value
	append sql_args ":${name}, "
	'
    }
    
    ns_log Notice "$sql_args"
    db_transaction {
	set nfe_id [db_exec_plsql cencel_nfe "
 	    SELECT cn_account_nfe__cancel_nfe (
					$sql_args
					:creation_user,
					:creation_ip,
					:context_id
					)	
	    
	"]
	
    }

    return
}
