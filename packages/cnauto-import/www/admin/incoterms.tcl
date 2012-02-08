ad_page_contract {
    
    Incoterms admin page

} {
    {orderby "name,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Import]"
set context [list $title]

set return_url [ad_return_url]

set bulk_actions [list]

set actions [list]

template::list::create \
    -name incoterms \
    -multirow incoterms \
    -key incoterm_id \
    -actions $actions \
    -row_pretty_plural "orders" \
    -bulk_actions $bulk_actions \
    -elements {
	name {
	    label "[_ cnauto-import.Name]"
	    display_template {
		@incoterms.name;noquote@
	    }
	}
	pretty_name {
	    label "[_ cnauto-import.Pretty_name]"
	    display_template {
		@incoterms.pretty_name;noquote@
	    }
	}
    } -orderby {
	name {
	    label "[_ cnauto-import.Name]"
	    orderby "lower(cii.name)"
	}
    } 


db_multirow -extend {} incoterms select_incoterms {
    SELECT cii.name, cii.pretty_name FROM cn_import_incoterms cii
} {}

