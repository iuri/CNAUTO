ad_library {
}

namespace eval cn_account {}

ad_proc -public cn_account::import_nfe_xml {
    {-input_file:required}
} {

    Imports NFE XML files
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

	# NFe Access key
	set node  [$root getElementsByTagName chNFe]
	set nodeName [$node nodeName]
	set nfe_key [[$node firstChild] nodeValue]

	
	# NFE Protocol number
	set node [$root getElementsByTagName nProt]
	set nodeName [$node nodeName]
	set nfe_prot [[$node firstChild] nodeValue]

	# NFE Registration Date
	set node [$root getElementsByTagName dhRecbto]
	set nodeName [$node nodeName]
	set nfe_date [[$node firstChild] nodeValue]



	
	ns_log Notice "CHNFe $nfe_key | $nfe_prot | $nfe_date"
	
	set nfe_exists_p [db_0or1row select_nfe_key {
	    SELECT nfe_id FROM cn_nfes WHERE nfe_key = :nfe_key
	}]
	
	if {!$nfe_exists_p} {
	    
	    set nfe_id [cn_account::nfe::new \
			    -nfe_key $nfe_key \
			    -nfe_prot $nfe_prot \
			    -nfe_date $nfe_date \
			    -creation_user [ad_conn user_id] \
			    -creation_ip [ad_conn peeraddr] \
			    -context_id [ad_conn package_id] \
			   ]
	} else {
	    ns_log Notice "Already exists!!!"
	}
    }
	
    return 
}


namespace eval cn_account::nfe {} 

ad_proc -public cn_account::nfe::new {
    {-nfe_key:required}
    {-nfe_prot:required}
    {-nfe_date:required}
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

    db_transaction {
	set nfe_id [db_exec_plsql insert_nfe {
	    SELECT cn_account_nfe__new (
					:nfe_key,
					:nfe_prot,
					:nfe_date,
					:creation_user,
					:creation_ip,
					:context_id
					)	
	    
	}]
	
    }

    return $nfe_id
}