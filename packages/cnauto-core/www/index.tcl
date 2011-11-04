# /packages/cnauto-core/www/index.tcl

ad_page_contract {
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04
} -properties {
    context:onevalue
    title:onevalue
}

set title [apm_instance_name_from_id [ad_conn package_id]]
set context [list]


set export_url [export_vars -base "ba-file" {}]