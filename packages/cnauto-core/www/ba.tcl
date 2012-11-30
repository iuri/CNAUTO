ad_page_contract {
}

set import_url [export_vars -base "europ-file" {return_url}]
set package_id [ad_conn package_id]

set actions ""
set bulk_actions {"#cnauto-core.Send_email#" "send-email" "#cnauto-core.Send_select_files#"}

template::list::create \
    -name files \
    -multirow files \
    -key revision_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -elements {
	title {
	    label "[_ cnauto-core.Name]"
	}
    }


db_multirow -extend {} files select_files {
    SELECT revision_id, title from cr_revisions cr, cr_items ci WHERE parent_id = :package_id AND title LIKE '%EUROP%'
} 