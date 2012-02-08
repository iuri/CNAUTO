ad_page_contract {
    Resource admin page
}


set title "[_ cnauto-resources.Admin]"
set context [list $title]

set return_url [ad_conn url]
set categories_url [export_vars -base "/cnauto-core/categories" {return_url}]