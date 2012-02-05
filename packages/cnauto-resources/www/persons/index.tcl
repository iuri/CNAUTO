ad_page_contract {
    Persons main page
} {
    {page ""}
}

set title "[_ cnauto-resources.Persons]"
set context [list $title]

set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

if {$admin_p} {
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}
set return_url [ad_conn url]

set person_ae_url [export_vars -base "person-ae" {return_url}]


set actions ""
set bulk_actions ""

template::list::create \
    -name persons \
    -multirow persons \
    -key person_id \
    -actions $actions \
    -row_pretty_plural "persons" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name persons_pagination \
    -elements {
	code {
	    label "[_ cnauto-resources.Code]"
	    display_template {
		<a href="@persons.person_url@">@persons.code;noquote@
	    }
	}
	pretty_name {
	    label "[_ cnauto-resources.Name]"
	    display_template {
		<a href="@persons.person_url@">@persons.pretty_name;noquote@</a>
	    }
	}
	pretty_type {
	    label "[_ cnauto-resources.Type]"
	    display_template {
		<a href="@persons.person_url@">@persons.pretty_type;noquote@</a>
	    }
	}
    } -orderby {
	pretty_type {
	    label "[_ cnauto-resources.Type]"
	    orderby "lower(cp.pretty_type)"
	}
    } 


db_multirow -extend {person_url} persons select_persons {
    
} {

    set person_url [export_vars -base person-one {return_url person_id type_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-core.Search]"}
    }    
} 