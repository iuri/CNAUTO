ad_page_contract {
    Resource admin page
}


set title "[_ cnauto-resources.Admin]"
set context [list $title]

set return_url [ad_conn url]
set add_category_url [export_vars -base "category-add" {return_url}]