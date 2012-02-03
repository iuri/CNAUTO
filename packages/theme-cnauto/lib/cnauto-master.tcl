# /packages/theme-cnauto/lib/cnauto-master.tcl
ad_page_contract {

 @author Iuri Sampaio (iuri.sampaio@iurix.com)
 @creation-date 2011-10-17

}


set title [apm_instance_name_from_id [ad_conn package_id]]
set context $title

if {[info exists context]} {
    set context_tmp $context
    unset context
} else {
    set context_tmp {}
}

ad_context_bar_multirow -- $context_tmp

# Context bar separator
set subsite_id [ad_conn subsite_id]
set separator [parameter::get -package_id $subsite_id -parameter ContextBarSeparator -default ":"]



template::head::add_css -href "/resources/theme-cnauto/cnauto-master.css"

set system_url [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL -default ""]




set user_id [ad_get_user_id] 
set untrusted_user_id [ad_conn untrusted_user_id]

set admin_url ""


if {$untrusted_user_id == 0} {
    set login_url [ad_get_login_url]
    set login_url [export_vars -base "$login_url" {return_url}]
} else {

    set username [person::name -person_id $untrusted_user_id]
    set pvt_home_url "/pvt/home" 
    set pvt_home_name [_ acs-subsite.Your_Account]
    set logout_url "[ad_get_logout_url]"

    # Site-wide admin link
    set sw_admin_p [acs_user::site_wide_admin_p -user_id $untrusted_user_id]
    if {$sw_admin_p} {
	set admin_url "/acs-admin/"
    } else {
	set subsite_admin_p [permission::permission_p \
				 -object_id [subsite::get_element -element object_id] \
				 -privilege admin \
				 -party_id $untrusted_user_id \
				 ]
	if {$subsite_admin_p} {
	    set admin_url "[subsite::get_element -element url]admin/"
	}
    }
}

set system_name [ad_system_name]
set subsite_name [lang::util::localize [subsite::get_element -element instance_name]]

subsite_navigation::define_pageflow \
    -navigation_multirow navigation -group main -subgroup sub \
    -show_applications_p [parameter::get -package_id [ad_conn subsite_id] \
			      -parameter ShowApplications -default 1] \
    -no_tab_application_list [parameter::get -package_id [ad_conn subsite_id] \
				  -parameter NoTabApplicationList -default ""] \
    -initial_pageflow [parameter::get -package_id [ad_conn subsite_id] \
			   -parameter UserNavbarTabsList -default ""]



if { [template::multirow exists navigation] } {
    if { ![info exists navigation_groups] } {
        set navigation_groups [list]
    }
    for {set i 1} {$i <= [template::multirow size navigation]} {incr i} {
        template::multirow get navigation $i
        if { [lsearch -exact $navigation_groups $navigation(group)] < 0} {
            lappend navigation_groups $navigation(group)
        }
    }
}


