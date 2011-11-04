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


