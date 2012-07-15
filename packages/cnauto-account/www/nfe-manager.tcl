ad_page_contract {
    NFe Manager list
} {
    {page ""}
    {keyword:optional}
}

auth::require_login

set title "[_ cnauto-account.NFE_manager]"
set context [list $title]

set return_url [ad_return_url]
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege "admin"]

set actions ""
set bulk_actions ""

if {$admin_p} {
    set bulk_actions {"#cnauto-account.Delete#" "nfe-bulk-delete" "#cnauto-account.Delete_selected_nfes#"}
    set actions {"#cnauto-account.Import_NFe#" "import-nfe" "#cnauto-account.Import_nfes#"}
    set admin_url "[apm_package_url_from_id [ad_conn package_id]]admin"	      
}

set where_clause ""
if {[info exists keyword]} {
    set where_clause "WHERE (
      cn.nfe_key = :keyword 
      OR cn.nfe_protocol = :keyword)
    "
}

template::list::create \
    -name nfes \
    -multirow nfes \
    -key nfe_id \
    -actions $actions \
    -row_pretty_plural "nfes" \
    -bulk_actions $bulk_actions \
    -bulk_action_method post \
    -elements {
	key {
	    label "[_ cnauto-account.Key]"
	    display_template {
		<a href="@nfes.nfe_url@">@nfes.key;noquote@</a>
	    }
	}
	prot {
	    label "[_ cnauto-account.Protocol]"
	}
	date {
	    label "[_ cnauto-account.Date]"
	}
	total {
	    label "[_ cnauto-account.Total]"
	}
	status {
	    label "[_ cnauto-account.Status]"
	    display_template {
		<if @nfes.status@ eq 100><img src="/resources/cnauto-account/images/authorized.png"></if>
		<if @nfes.status@ eq 101><img src="/resources/cnauto-account/images/canceled.png"></if>
	    }
	}
	actions {
	    label "[_ cnauto-account.Actions]"
	    display_template {
		<a href="@nfes.download_url@"><img src="/resources/cnauto-account/images/download.png" \></a>
		<a href="#" onClick="emailXMLonClick(@nfes.file_id@)" rel="nofollow"><img src="/resources/cnauto-account/images/email.png" \></a>
		<a href="@nfes.nfe_url@"><img src="/resources/cnauto-account/images/view.png" \></a>
	    }
	}
    } -orderby {
	nfe_date {
	    label "[_ cnauto-account.Date]"
	    orderby "lower(cn.date)"
	}
    } 


template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/prototype.js"


template::head::add_javascript -script {
    function emailXMLonClick(fileId) {
	new Ajax.Request('email-xml',{asynchronous:true,method:'post',parameters:'file_id=' + fileId});

   	
	new Ajax.Request('email-xml', {
	    method: 'get',
	    parameters:'file_id=' + fileId,
	    onSuccess: successFunc,
	    onFailure:  failureFunc
	});
	
    }

    function successFunc(response){
   
	if (200 == response.status){
	    alert("Call is success");
	}
	var container = $('notice');
	var content = response.responseText;
	container.update(content);
    }

    function failureFunc(response){

	alert("Call is failed" );
    
    }
}





set fs_url "/file-storage/"

db_multirow -extend {file_id nfe_url download_url email_url} nfes select_nfes {
    SELECT nfe_id, key, prot, date, total, status FROM cn_nfes
} {

    set nfe_url [export_vars -base "nfe-one" {return_url nfe_id}]
    set title "NFE-${key}.xml"
    set file_id [db_string select_file_id {
	SELECT item_id FROM cr_items WHERE name = :title
    }]

    set download_url [export_vars -base "${fs_url}download/[ad_urlencode $title]" {file_id}]
    #behave like filesystem    set download_url "/file/$file_id/[ad_urlencode $title]"

    set email_url [export_vars -base "" {return_url nfe_id}]
    

}


