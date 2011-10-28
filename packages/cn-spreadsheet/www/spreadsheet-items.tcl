ad_page_contract {
  List data aggregator for this package_id 

  @author Iuri Sampaio

} {
    {spreadsheet_id}
    {page:optional}
    {return_url ""}
    {email ""}
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id $spreadsheet_id -privilege admin
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""
set title [db_string get_spreadsheet_title {}]
   
template::head::add_css -href "/resources/cn-spreadsheet/cn-spreadsheet.css"

set n_items [db_string get_number_of_items {}] 

set return_url [export_vars -base [ad_conn url] {spreadsheet_id}]




ad_form -name search -export {spreadsheet_id} -form {
    {email:text(text) {label "[_ cn-spreadsheet.Search_item]"}}
} 




set actions [list]
set bulk_actions [list]
set extend_list [list]
lappend extend_list element_url

set elements [list element [list label [_ cn-spreadsheet.Item] \
                              display_template {
                                  <a href="@items.element_url;noquote@">@items.element;noquote@</a>
                              }]]

set orderbys {
    email {
	label "[_ cn-spreadsheet.Element]"
	orderby_asc { lower_element asc }
	orderby_desc { lower_element desc }
    }
}

set list_elems [db_list select_elems {}]

foreach field_id $list_elems {
    lappend extend_list ${field_id}
    set name [db_string select_name {} -default ""]
    lappend elements ${field_id} [list label $name]
    lappend orderbys ${field_id} [list label "$name" orderby "lower($field_id)"]
}



set bulk_actions {"#cn-spreadsheet.Delete_item#" "cn-spreadsheet-element-del" "#cn-spreadsheet.Delete_element#"}

if {[exists_and_not_null element]} {
    set where_clause "AND element = :element"
} else {
	set where_clause ""
}

template::list::create \
    -name "items" \
    -multirow "items" \
    -key element \
    -row_pretty_plural "items" \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url spreadsheet_id } \
    -pass_properties { spreadsheet_id } \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name users_pagination \
    -elements $elements \
    -filters {
	spreadsheet_id {default_value $spreadsheet_id}
    } -orderby $orderbys

db_multirow -extend $extend_list items select_items {} {

    set email_url "spreadsheet-item-info?element=$element"

    db_foreach select_field {} {
	set ${field_id} ${data}
    }
}
