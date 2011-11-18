ad_library {
    TCL script test file
}

aa_register_case \
    -cats {smoke api} \
    mount_xowiki_test {
	Test xowiki mount
    } {
	aa_run_with_teardown \
	    -rollback \
	    -test_code {
	

		ns_log Notice "Running callback theme_ivc::after_instantiate"
		set subsite_package_id 1069
		set name [ad_generate_random_string]
		set subsite_node_id [site_node::get_node_id_from_object_id -object_id $subsite_package_id]
		
		if {[apm_package_installed_p "xowiki"]} {
		    set xowiki_package_id [site_node::instantiate_and_mount \
					       -node_name $name \
					       -package_key "xowiki" \
					       -package_name "$name" \
					       -context_id $subsite_package_id \
					       -parent_node_id $subsite_node_id \
					      ]
		    
		    set instance_name "/ivc/$name"
		    
		    if {[site_node::exists_p -url $instance_name]} {
			ns_log Notice "created instance /ivc/content"
		    }

		    array set info [site_node::get_from_url -url $instance_name -exact]
		    
		    if {[expr {$info(package_id) ne ""}]} {
			ns_log Notice "package is mounted, package_id provided"
		    }
		    
                    
                    set index_vuh_params {
                        {-m view}
                        {-folder_id:integer 0}
                    }

		    ns_log Notice "before ::xosiki"
                    ::xowiki::Package initialize -parameter $index_vuh_params \
                        -package_id $info(package_id) \
                        -url $instance_name/ \
                        -actual_query "" \
                        -user_id 0

                    if {[info exists package_id]} {
			ns_log Notice "package_id is exported"
		    }

                    if {[set package_id $info(package_id)]} {
			ns_log Notice "package_id right value"
                    }
		}
	    }
    }