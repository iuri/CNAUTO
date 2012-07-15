ad_library {
    CN Auto Parts Library

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-06-04
}


namespace eval cn_resources::part {}
namespace eval cn_resources::parts {}




ad_proc -public  cn_resources::parts::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add part
} {

    ns_log Notice "Running ad_proc cn_resources::parts::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    set creation_ip [ad_conn peeraddr]
    set creation_user [ad_conn user_id]
    set context_id [ad_conn package_id]

    foreach line $lines {
	
	if {$line ne ""} {
	    set line [split $line {;}] 
	    ns_log Notice "LINE $line"
	    
	    
	    set code [lindex $line 0]
	    set name $code
	    set pretty_name [lindex $line 1]
	    set ncm [lindex $line 2]

	    set exists_p [db_string select_code {
		SELECT code FROM cn_parts WHERE code = :code
	    } -default null]
	    
	    if {$exists_p == "null" && $code != ""} {
		ns_log Notice "CODE $code" 
		
		db_transaction {
		    db_exec_plsql insert_part {
			SELECT cn_part__new (
						:code,
						:name,
						:pretty_name,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						:context_id,
						:creation_user,
						:creation_ip
						)
		    }
		}
	    }
	}	
    }
    
    return
}




ad_proc -public cn_resources::part::delete {
    part_id
} {
    Delete a part
} {

    db_transaction {
	
	db_exec_plsql delete_part {
	    SELECT cn_part__delete ( :part_id )
	}
    }
    
    return 
}

ad_proc -public cn_resources::part::edit {
    {-part_id:required}
    {-code:required}
    {-name ""}
    {-pretty_name ""}
    {-resource_id ""}
    {-model_id ""}
    {-quantity ""}
    {-price ""}
    {-width ""}
    {-height ""}
    {-depth ""}
    {-weight ""}
    {-volume ""}
    {-dimensions ""}
} {
    
    Edits part 
} {
    
    db_transaction {
	db_exec_plsql update_part {
	    SELECT cn_part__edit (
				  :part_id,
				  :code,
				  :name,
				  :pretty_name,
				  :resource_id,
				  :model_id,
				  :quantity,
				  :price,
				  :width,
				  :height,
				  :depth,
				  :weight,
				  :volume,
				  :dimensions
				  )
	}
    }		     

    return
}



ad_proc -public cn_resources::part::new {
    {-code:required}
    {-name ""}
    {-pretty_name ""}
    {-resource_id ""}
    {-model_id ""}
    {-quantity ""}
    {-price ""}
    {-width ""}
    {-height ""}
    {-depth ""}
    {-weight ""}
    {-volume ""}
    {-dimensions ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}
} {
    
    Adds a new part 
} {
     
    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
     
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }

    db_transaction {
	set part_id [db_exec_plsql insert_part {
	    SELECT cn_part__new (
				 :code,
				 :name,
				 :pretty_name,
				 :resource_id,
				 :model_id,
				 :quantity,
				 :price,
				 :width,
				 :height,
				 :depth,
				 :weight,
				 :volume,
				 :dimensions,
				 :context_id,
				 :creation_user,
				 :creation_ip
				 )
	}]	
    }
    
    return $part_id
}
