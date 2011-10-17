# /packages/theme-cnauto/lib/cnauto-master.tcl
ad_page_contract {

 @author Iuri Sampaio (iuri.sampaio@iurix.com)
 @creation-date 2011-10-17

}


set title [apm_instance_name_from_id [ad_conn package_id]]
set context $title

template::head::add_css -href "/resources/theme-cnauto/cnauto-master.css"
template::head::add_css -href "/resources/openacs-default-theme/styles/default-master.css"

set system_url [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL -default ""]


set en_locale_img "/resources/theme-ivc/images/english.png"
set en_locale_url [export_vars -base "/acs-lang/change-locale" {return_url {user_locale "en_US"}}]                               

set pt_locale_img "/resources/theme-ivc/images/portuguese.png"
set pt_locale_url [export_vars -base "/acs-lang/change-locale" {return_url {user_locale "pt_BR"}}]


set user_id [ad_get_user_id] 
set untrusted_user_id [ad_conn untrusted_user_id]

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

ns_log Notice "[ad_conn url]"
if {[string equal [ad_conn url] "/ivc/content/index"] || [string equal [ad_conn url] "/ivc/content/"]} {
    template::head::add_javascript -src "http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js"
    template::head::add_javascript -src "/resources/theme-ivc/js/translucentslideshow.js"
    template::head::add_javascript -src "/resources/theme-ivc/js/slideshow.js"
}