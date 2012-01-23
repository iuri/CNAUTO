ad_page_contract {
    
    Import main page

} {
    {orderby "code,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Import]"
set context [list $title]

set return_url [ad_return_url]
set assurance_ae_url [export_vars -base "order-ae" {return_url}] 



set actions {
    "#cnauto-import.Add_order#" "order-ae?return_url=/cnauto-order" "#cnauto-import.Add_a_new_order#"
    "#cnauto-import.Admin#" "admin/index?return_url=/cnauto-order" "#cnauto-import.Admin#"
}

set bulk_actions [list]


set where_clause ""

if {[exists_and_not_null keyword]} {
    set where_clause "AND (cio.n = :keyword OR ca.assurance_number = :keyword)"
}



template::list::create \
    -name orders \
    -multirow orders \
    -key order_id \
    -actions $actions \
    -row_pretty_plural "orders" \
    -bulk_actions $bulk_actions \
    -elements {
	code {
	    label "[_ cnauto-import.Code]"
	    display_template {
		<a href="@orders.order_url@">@orders.code;noquote@
	    }
	}
	provider {
	    label "[_ cnauto-import.Provider]"
	    display_template {
		<a href="@orders.provider_url@">@orders.provider;noquote@</a>
	    }
	}
	incoterm {
	    label "[_ cnauto-import.Incoterm]"
	    display_template {
		@orders.incoterm;noquote@</a>
	    }	    
	}
	incoterm_value {
	    label "[_ cnauto-import.Incoterm_value]"
	    display_template {
		@orders.incoterm_value;noquote@</a>
	    }	    
	}
	creation_date {
	    label ""
	    display_template {
		@orders.creation_date;noquote@
	    }
	}
    } -orderby {
	code {
	    label "[_ cnauto-import.Code]"
	    orderby "lower(co.code)"
	}
    } 


db_multirow -extend {provider_url order_url} orders select_orders {} {
    
    set order_url [export_vars -base "order-one" {order_id return_url}]

    ns_log Notice "TEDST $order_id | "
    set provider_url ""

}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-assurance.Search]"}
    }    
} 