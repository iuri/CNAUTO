ad_page_contract {
    Categories main page
  
} -properties {
    context:onevalue
    title:onevalue
}


set title "[_ cnauto-resources.Add_category]"
set context [list $title]


template::list::create \
    -name categories \
    -multirow categories \
    -elements {
	pretty_name {
	    label "[_ cnauto-core.Name]"
	    display_template {
		<a href="@categories.category_ae_url@">@categories.pretty_name;noquote@</a>
	    }
	}
	type {
	    label "[_ cnauto-core.Class]"
	}	
   }



db_multirow -extend {category_ae_url} categories select_categories {
    SELECT ct.category_id, ct.pretty_name, ot.pretty_name AS type
    FROM cn_categories ct, acs_object_types ot
    WHERE ot.object_type = ct.object_type

} {
    set category_ae_url [export_vars -base "category-ae" {category_id return_url}]

}