ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} {
    {newsletter_id}
    {page:optional}
    {return_url ""}
    {email ""}
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id $newsletter_id -privilege admin
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""
set title [db_string get_newsletter_title {}]
   
template::head::add_css -href "/resources/newsletter/newsletter.css"

set n_users [db_string get_number_of_users {}] 

set return_url [export_vars -base [ad_conn url] {newsletter_id}]




ad_form -name search -export {newsletter_id} -form {
    {email:text(text) {label "[_ newsletter.Search_Email]"}}
} 




set actions [list]
set bulk_actions [list]
set extend_list [list]
lappend extend_list email_url

set elements [list email [list label [_ newsletter.Email] \
                              display_template {
                                  <a href="@users.email_url;noquote@">@users.email;noquote@</a>
                              }]]

set orderbys {
    email {
	label "[_ newsletter.Email]"
	orderby_asc { lower_email asc }
	orderby_desc { lower_email desc }
    }
}

set list_elems [db_list select_elems {}]

foreach field_id $list_elems {
    lappend extend_list ${field_id}
    set name [db_string select_name {} -default ""]
    lappend elements ${field_id} [list label $name]
    lappend orderbys ${field_id} [list label "$name" orderby "lower($field_id)"]
}



set bulk_actions {"#newsletter.Delete_user#" "newsletter-users-del" "#newsletter.Delete_user#"}

if {[exists_and_not_null email]} {
    set where_clause "AND email = :email"
} else {
	set where_clause ""
}

template::list::create \
    -name "users" \
    -multirow "users" \
    -key email \
    -row_pretty_plural "users" \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url newsletter_id } \
    -pass_properties { newsletter_id } \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name users_pagination \
    -elements $elements \
    -filters {
	newsletter_id {default_value $newsletter_id}
    } -orderby $orderbys

db_multirow -extend $extend_list users users_select {} {

    set email_url "newsletter-user-info?email=$email"

    db_foreach select_field {} {
	set ${field_id} ${data}
    }
}
