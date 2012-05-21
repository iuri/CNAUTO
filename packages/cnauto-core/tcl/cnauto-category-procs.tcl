# /packages/cnauto-core/tcl/cnauto-category-procs.tcl
ad_library {

    CNAuto Core categoory procs

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2012-05-21

}


namespace eval cn_categories {}

namespace eval cn_categories::category {}


ad_proc -public  cn_categories::import_csv_file {
    {-input_file:required}
    {-type ""}
    {-parent_id ""}
} {

    Imports CSV files to add categories
} {

    ns_log Notice "Running ad_proc cn_categories::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file
    
    foreach line $lines {
	set line [split $line {;}] 

	
	ns_log Notice "LINE $line"

	set code [lindex $line 0]
	set name [lindex $line 1]

	set class_id [cn_categories::get_category_id -code $code -type "cn_assurance"] 
	  
	if {$class_id eq "null"} {  
	    ns_log Notice "Add class $name | "
	    
	    set class_id [cn_categories::category::new \
			      -code $code \
			      -pretty_name $name \
			      -parent_id $parent_id \
			      -object_type $type \
			      -package_id [ad_conn package_id]]
	}	
    }
    
    return
}


ad_proc -public cn_categories::category::new {
    {-pretty_name ""}
    {-name ""}
    {-parent_id ""}
    {-package_id ""}
    {-category_type ""}
} {

    Adds a new category
} {    
    
    set category_id [db_nextval acs_object_id_seq]
    
    if {$name == ""} {
	set name [util_text_to_url -replacement "" -text $pretty_name]
    }

    if {$package_id == ""} {
	set package_id [ad_conn package_id]
    }

    db_transaction {
	db_dml insert_category {
	    INSERT INTO cn_categories (
				       category_id,
				       package_id,
				       parent_id,
				       pretty_name,
				       name,
				       category_type
				       ) VALUES (
						 :category_id,
						 :package_id,
						 :parent_id,
						 :pretty_name,
						 :name,
						 :category_type
				       )
	}
    }
    
    return $category_id
}
ad_proc -public cn_categories::category::delete {
    category_id
} {
    Deletes category
} {

    # If category is parent of others remove the children first

    

    set children_ids [db_list select_children_ids {
	SELECT category_id FROM cn_categories WHERE parent_id = :category_id
    }]

    if {[exists_and_not_null children_ids]} {
	foreach child_id $children_ids {
	    cn_categories::category::delete $child_id 
	}
    }

    #if category is a leaf node just remove it
    db_dml delete_category {
	DELETE FROM cn_categories WHERE category_id = :category_id
    }
    

    return
}



ad_proc -public cn_categories::get_category_id {
    {-code ""}
    {-name ""} 
    {-type ""}
    
    
} {
    Returns category_id
} {

    if {$code ne ""} {	

        set code [util_text_to_url -replacement "" -text $code]
    
    	return [db_string select_category_id {
	    SELECT category_id FROM cn_categories
	    WHERE code = :code AND category_type = :type
	} -default null]

    } elseif {$name ne ""} {
	      
	set name [util_text_to_url -replacement "" -text $name]
	
	return [db_string select_category_id {
	    SELECT category_id FROM cn_categories
	    WHERE name = :name AND category_type = :type
	} -default null]
    }

}

ad_proc -public cn_categories::get_category_name {
    {-category_id:required}
} {
    Returns category's name
} {



    return [db_string select_category_type {
	SELECT name FROM cn_categories WHERE category_id = :category_id
    } -default null]

}