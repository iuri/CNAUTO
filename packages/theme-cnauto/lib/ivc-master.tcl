#----------------------------------------------------------------------
# /packahes/theme-cnauto/lib/ivc-master.tcl
# @author Iuri Sampaio (iuri.sampaio@iurix.com)
# @creation-date 2011-10-08
#----------------------------------------------------------------------



set user_id [ad_get_user_id] 
set untrusted_user_id [ad_conn untrusted_user_id]

set package_id [ad_conn package_id]

set title [apm_instance_name_from_id $package_id]
set context $title





template::head::add_css -href "/resources/theme-cnauto/ivc-master.css"

set return_url [ad_conn url]


if {$untrusted_user_id == 0} {
    set login_url [export_vars -base "/register" {return_url}]
} else {

    set username [person::name -person_id $untrusted_user_id]
    set pvt_home_url "/pvt/home" 
    set pvt_home_name [_ acs-subsite.Your_Account]
    set logout_url "[ad_get_logout_url]"

    # Site-wide admin link
    set sw_admin_p [acs_user::site_wide_admin_p -user_id $untrusted_user_id]
    if {$sw_admin_p} {
	set admin_url "/acs-admin/"
	set admin_name "Admin"
    } else {
	set subsite_admin_p [permission::permission_p \
				 -object_id [subsite::get_element -element object_id] \
				 -privilege admin \
				 -party_id $untrusted_user_id \
				 ]
	if {$subsite_admin_p} {
	    set admin_url "[subsite::get_element -element url]admin/"
	    set admin_name "Admin"
	}
    }
}