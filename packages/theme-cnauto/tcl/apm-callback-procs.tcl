# /packages/theme-cnauto/tcl/apm-callback-procs.tcl
ad_library {
    Installation procs to support theme-cnauto pkg
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-12
}


namespace eval theme_cnauto {}


ad_proc -private theme_cnauto::after_install {
    {-package_id}
} {
    Mount and instantiate ivc subsite
} {
    #ns_log Notice "Running callback theme_cnauto::after_install"

    set ivc_package_id [site_node::instantiate_and_mount -node_name "ivc" \
			    -package_key "acs-subsite" \
			    -package_name "IVC Motors" \
			   ]
    
    parameter::set_value -package_id $ivc_package_id -parameter "DefaultMaster" -value "/packages/theme-cnauto/lib/ivc-master"
    

    set ivc_package_id [site_node::instantiate_and_mount -node_name "about" \
			    -package_key "xowiki" \
			    -package_name "about" \
			   ]


    set ivc_package_id [site_node::instantiate_and_mount -node_name "newsletter" \
			    -package_key "newsletter" \
			    -package_name "Newsletter" \
			   ]

    return
}