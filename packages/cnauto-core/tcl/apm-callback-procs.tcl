# /packages/cnauto-core/tcl/apm-callback-procs.tcl
ad_library {
    Installation procs to support cnauto-core pkg
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-12
}


namespace eval cn_core::install {}


ad_proc -private cn_core::install::after_install {} {

   Instantiate and Mount CNAUTO subsite and app's
} {
    ns_log Notice "Running callback cnauto_core::install::after_install"
       

    set context_id [db_string select_package_id {
	SELECT o.package_id
	FROM acs_objects o 
	WHERE o.title = '#acs-kernel.Main_Site#'
    } -default null]
 
    if {[exists_and_not_null context_id]} {
	set subsite_package_id [site_node::instantiate_and_mount -node_name "cnauto" \
				    -package_key "acs-subsite" \
				    -package_name "CN Auto" \
				    -context_id $context_id \
				   ]
    
    
	set subsite_node_id [site_node::get_node_id_from_object_id -object_id $subsite_package_id]
    
	if {[apm_package_installed_p "xowiki"]} {
	    set xowiki_package_id [site_node::instantiate_and_mount \
				       -node_name "content" \
				       -package_key "xowiki" \
				       -package_name "content" \
				       -context_id $subsite_package_id \
				       -parent_node_id $subsite_node_id \
				      ]
	    
	}
	
	if {[apm_package_installed_p "news"]} {
	    set news_package_id [site_node::instantiate_and_mount -node_name "news" \
				     -package_key "newsletter" \
				     -package_name "News" \
				     -context_id $subsite_package_id \
				     -parent_node_id $subsite_node_id \
				    ]
	}
	
	if {[apm_package_installed_p "newsletter"]} {
	    set newsletter_package_id [site_node::instantiate_and_mount -node_name "newsletter" \
					   -package_key "newsletter" \
					   -package_name "Newsletter" \
					   -context_id $subsite_package_id \
					   -parent_node_id $subsite_node_id \
					  ]
	}
	
	if {[apm_package_installed_p "assurances"]} {
	    set assurances_package_id [site_node::instantiate_and_mount -node_name "assurances" \
					   -package_key "cnauto-assurances" \
					   -package_name "Assurances" \
					   -context_id $subsite_package_id \
					   -parent_node_id $subsite_node_id \
					  ]
	}
		
	if {[apm_package_installed_p "cnauto-orders"]} {
	    set orders_package_id [site_node::instantiate_and_mount -node_name "orders" \
				       -package_key "cnauto-orders" \
				       -package_name "Ordes" \
				       -context_id $subsite_package_id \
				       -parent_node_id $subsite_node_id \
				      ]
	}
	
	if {[apm_package_installed_p "cnauto-import"]} {
	    set import_package_id [site_node::instantiate_and_mount -node_name "imports" \
					   -package_key "cnauto-import" \
					   -package_name "Imports" \
					   -context_id $subsite_package_id \
					   -parent_node_id $subsite_node_id \
					  ]
	}



	if {[apm_package_installed_p "resources"]} {
	    set resources_package_id [site_node::instantiate_and_mount -node_name "resources" \
					  -package_key "cnauto-resources" \
					  -package_name "Resources" \
					  -context_id $subsite_package_id \
					  -parent_node_id $subsite_node_id \
					 ]
	    
	}
	
    }
    
    return
}
    
    
ad_proc -private  cn_core::install::before_unmount {
    {-package_id}
} {

    Umount IVC Subsite and related app's

} {
    ns_log Notice "Running ad_proc ivc::before_unmount"
    
    ns_log Notice "PACKAGEID $package_id" 

    db_1row select_node_id {
	SELECT node_id AS parent_node_id FROM site_nodes 
	WHERE name = 'ivc' 
	AND object_id = (SELECT object_id FROM acs_objects 
			 WHERE context_id = :package_id)
    }

    ns_log Notice "NODEID $parent_node_id" 
    set node_ids [db_list select_node_ids {
	SELECT node_id FROM site_nodes WHERE parent_id = :parent_node_id
    }]

    # Remove child instances
    foreach {node_id object_id} $node_ids {
	db_1row select_object_id {
	    SELECT object_id FROM site_nodes WHERE node_id = :node_id
	}
	

	ns_log Notice "Remove instance: $node_id | $object_id"
	site_node::unmount -node_id $node_id
	site_node::delete -node_id $node_id
	#apm_package_instance_delete $object_id
    }

    # Remove IVC acs-subsite
    ns_log Notice "Remove subsite instance: $parent_node_id | $object_id"
    site_node::unmount -node_id $parent_node_id
    site_node::delete -node_id $parent_node_id
    apm_package_instance_delete $package_id
}