ad_page_contract {
  List data aggregator for this package_id 

    @author Iuri Sampaio
    @creation-date 2011-09-18
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set site_wide [acs_user::site_wide_admin_p]
set action_list ""

set return_url [ad_conn url]

set spreadsheet_ids [db_list get {
    SELECT spreadsheet_id
    FROM cn_spreadsheets s, acs_objects ao
    WHERE s.spreadsheet_id = ao.object_id
    AND ao.package_id = :package_id
}]

if {$admin_p eq 1} {
	set action_list {"#cn-spreadsheet.New#" spreadsheet-ae "#cn-spreadsheet.New#"}
}

if {[llength $spreadsheet_ids] == 1} {
#	ad_returnredirect spreadsheet-items?spreadsheet_id=$spreadsheet_ids
}


template::head::add_css -href "/resources/cn-spreadsheet/cn-spreadsheet.css"


set bulk_actions [list]


set bulk_actions {"#cn-spreadsheet.Delete#" "spreadsheet-del" "#cn-spreadsheet.Delete_selected_spreadsheets#"}


template::list::create \
    -name spreadsheet_list \
    -multirow spreadsheet_list \
    -key spreadsheet_id \
    -actions $action_list \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -pass_properties {
    } -elements {
	name {
	    label ""
	    display_template {
		<a href="spreadsheet-items?spreadsheet_id=@spreadsheet_list.spreadsheet_id@">
		@spreadsheet_list.name@
		</a>
	    }
	}
	atd {
	    label ""
	    display_template {
		@spreadsheet_list.qtd@ #cn-spreadsheet.regitered_items# 
	    }
	}
	actions {
	    label ""
	    display_template {
		<div class="options_list">
		<ul>
		<if $site_wide>
		<li><a class="button" href="spreadsheet-del?spreadsheet_id=@spreadsheet_list.spreadsheet_id@">
		#cn-spreadsheet.Delete#
		</a></li> 
		<li><a class="button" href="spreadsheet-new?spreadsheet_id=@spreadsheet_list.spreadsheet_id@">
		#cn-spreadsheet.Edit#
		</a></li>
		
		</if>
		</ul>
		</div>
		
	    }
	}
    }

db_multirow -extend {qtd} spreadsheet_list select_spreadsheet {
    SELECT spreadsheet_id, name, description,
    acs_permission__permission_p(spreadsheet_id, :user_id, 'admin') as admin_p
    FROM cn_spreadsheets s,	acs_objects ao
    WHERE package_id = :package_id
    AND s.spreadsheet_id = ao.object_id
    AND ao.package_id = :package_id	
    AND 't' = acs_permission__permission_p(spreadsheet_id, :user_id, 'read')
} {
    set qtd [db_string select_emails {
	SELECT count(*) AS qtd
	FROM  cn_spreadsheet_elements se 
	WHERE se.valid = 't'
	AND se.spreadsheet_id = :spreadsheet_id
    } -default 0]
}
