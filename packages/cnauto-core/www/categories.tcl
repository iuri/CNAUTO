ad_page_contract {
    Categories main page
  
} { 
    {category_type ""}
    {orderby "pretty_name,asc"}
    {submit.x:optional}
    {keyword:optional}
    page:optional
} -properties {
    context:onevalue
    title:onevalue
}


set title "[_ cnauto-resources.Add_category]"
set context [list $title]

set category_type_options [list]

db_foreach category_type { 
    SELECT cc.category_type AS type, COUNT(cc.category_id) AS num, ot.pretty_name
    FROM cn_categories cc, acs_object_types ot
    WHERE cc.category_type = ot.object_type
    GROUP BY cc.category_type, ot.pretty_name 
} {
    lappend category_type_options \
	[list \
	          $pretty_name \
	          $type \
	     [lc_numeric $num]]
}
    
set actions {
    "#cnauto-core.Add_category#" "category-ae" "#cnauto-core.Add_category#"
    "#cnauto-resources.Import_person_cat_lt#" "categories-import-csv-file"
}
set bulk_actions {"#cnauto-core.Delete#" "category-bulk-delete" "#cnauto-core.Delete_selected_cat#"}


set where_clause ""
if {[info exists submit.x]} { 
    set where_clause "AND cc.pretty_name = :keyword"
    
}


template::list::create \
    -name categories \
    -multirow categories \
    -key category_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -row_pretty_plural "categories" \
    -page_size 10 \
    -page_flush_p t \
    -page_query_name categories_pagination \
    -elements {
	pretty_name {
	    label "[_ cnauto-core.Name]"
	    display_template {
		<a href="@categories.category_ae_url@">@categories.pretty_name;noquote@</a>
	    }
	}
	pretty_type {
	    label "[_ cnauto-core.Class]"
	}
	parent {
	    label "[_ cnauto-core.Parent]"
	}

    } -filters {
	category_type {
	    label "[_ cnauto-core.Type]"
	    values $category_type_options
            where_clause {
                cc.category_type = :category_type
            }
	    default_value ""
	}
    } -orderby {
	pretty_name {
	    label "[_ cnauto-core.Name]"
	        orderby category_id
	    orderby_asc {cc.pretty_name asc}
	    orderby_desc {cc.pretty_name desc}
	}
    }

 
db_multirow -extend {category_ae_url} categories select_categories {} {
    set category_ae_url [export_vars -base "category-ae" {category_id return_url}]

}