ad_library {
    
    Theme CN Auto API library

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04
}


namespace eval theme_cnauto::install {}

ad_proc -private theme_cnauto::install::after_install {
} {
    
    After Install proc
} {
    
    ns_log Notice "Running ad_proc cnauto_core::install::after_install"
	
    db_1row select_object_id {
	SELECT package_id FROM acs_objects WHERE title = 'cnauto' AND object_type = 'site_node'    
    }
    
    parameter::set_value -package_id $package_id -parameter "DefaultMaster" -value "/packages/theme-cnauto/lib/cnauto-master"
    
}