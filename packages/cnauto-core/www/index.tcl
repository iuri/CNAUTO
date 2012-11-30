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

set return_url [ad_conn url]
set ba_url [export_vars -base "ba" {return_url}]
set europ_url [export_vars -base "europ" {return_url}]

set import_cotia_url [export_vars -base "cotia-import-xml" {return_url}]

set import_abeiva_url [export_vars -base "abeiva-file" {return_url}]

set categories_url [export_vars -base "categories" {return_url}]