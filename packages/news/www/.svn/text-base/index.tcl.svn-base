# /packages/news/www/index.tcl

ad_page_contract {

    Displays a hyperlinked list of published news titles either 'live' or 'archived'
    
    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date 2000-12-20
    @cvs-id $Id: index.tcl,v 1.4 2006/11/24 22:21:15 alessandrol Exp $

} {
   {start:integer "1"}
   {view:trim "live"}
   {category_id ""}
} -properties {

   
    title:onevalue
    context:onevalue
    news_admin_p:onevalue
    news_create_p:onevalue 
    news_items:multirow
    allow_search_p:onevalue
    pagination_link:onevalue
    item_create_link:onevalue
    view_switch_link:onevalue
}

set package_id [ad_conn package_id]
ad_require_permission $package_id news_read
set news_url [site_node::get_url_from_object_id -object_id $package_id]
set rss_title [parameter::get -package_id $package_id -parameter RSSTitle]


set context [list]

# switches for privilege-enabled links: admin for news_admin, submit for registered users
set news_admin_p [ad_permission_p $package_id news_admin]
set news_create_p [ad_permission_p $package_id news_create]
set user_id [ad_conn user_id]

# switch for showing interface to site-wide-search for news
set allow_search_p [parameter::get -package_id $package_id -parameter ShowSearchInterfaceP  -default 1]
set search_url [site_node_closest_ancestor_package_url -package_key search -default ""]




# view switch in live | archived news
if { [string equal "live" $view] } {

    set title [apm_instance_name_from_id $package_id]
    set title "[_ news.News]"
    
    set view_clause [db_map view_clause_live]

    if { [db_string archived_p "
    select decode(count(*),0,0,1) 
    from   news_items_approved
    where  publish_date < sysdate 
    and    archive_date < sysdate
    and    package_id = :package_id"]} {
	set view_switch_link "<a href=?view=archive>[_ news.Show_archived_news]</a>"
    } else { 
	set view_switch_link ""
    }
    
} else {
    
     set title [apm_instance_name_from_id $package_id]
    set title [_ news.News]
    set view_clause [db_map view_clause_archived]

    if { [db_string live_p "
    select decode(count(*),0,0,1) 
    from   news_items_approved
    where  publish_date < sysdate 
    and    (archive_date is null 
            or archive_date > sysdate) 
    and    package_id = :package_id"] } {
	set view_switch_link "<a href=?view=live>[_ news.Show_live_news]</a>"
    } else {
	set view_switch_link ""
    }    
}

set max_dspl [ad_parameter DisplayMax "news" 10]



set category_where_clause "" 
if {[exists_and_not_null category_id]} {
	set category_where_clause "and exists (select 1 from category_object_map where category_id = :category_id and object_id = item_id)"
}
set boxes_p [parameter::get -package_id $package_id -parameter JavascriptGallery -default 0]

set max_priority_item [db_list get_max_priority {}]


if {$start == 1 && $max_priority_item != ""} {
	set query item_list_with_max_priority
	set list_of_items_all [db_list get_list_with_max_priority {}]
} else {
	set query item_list 
	set list_of_items_all [db_list get_list {}]
}

set list_of_items [lrange $list_of_items_all [expr $start -1]  [expr [expr $start -1]  + $max_dspl]]

if {$list_of_items != ""} {
	set list_of_items_where_clause "where item_id in ([join $list_of_items ,])"
} else {
	set list_of_items_where_clause "where 1 = 0"
}
  
db_multirow -extend { publish_date continue image_id publish_body_small} news_items $query {} {
    # this code block enables paging counter, no direct data manipulation 
    # alternatives are: <multiple ... -startrow=.. and -max_rows=.. if it worked
    # in Oracle (best for large number of rows): select no .. (select rownum as no.. (select...)))
    #                             
    
    if { [string length $publish_body] > 400} {  
           set publish_body "[string range $publish_body 0 400]..."
    }

    set publish_body_small $publish_body
    if {[string length $publish_body] > 300} {
          set publish_body_small "[string range $publish_body 0 300]..."
    }
    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
    set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
    set publish_body [ad_html_to_text $publish_body]
    set publish_body_small [ad_html_to_text $publish_body_small]
	
}

# make paging links
if { [llength $list_of_items_all] < [expr $start + $max_dspl] } {
    set next_start ""
} else {
    set next_start "<a href=index?start=[expr $start + $max_dspl]&view=$view>#news.Next#<a/>"
}

if { $start == 1 } {
    set prev_start ""
} else {
    set prev_start "<a href=index?start=[expr $start - $max_dspl]&view=$view>#news.Previous#</a>"
}

if { ![empty_string_p $next_start] && ![empty_string_p $prev_start] } {
    set divider " | "
} else {
    set divider ""
}

set pagination_link "$prev_start$divider$next_start"
set rss_exists [rss_support::subscription_exists \
                    -summary_context_id $package_id \
                    -impl_name news]
set rss_url "[news_util_get_url $package_id]rss/rss.xml"

set notification_chunk [notification::display::request_widget \
                        -type one_news_item_notif \
                        -object_id $package_id \
                        -pretty_name "[_ news.News]" \
                        -url [ad_return_url] \
                        ]

set return_url [ad_conn url]
set item_create_url [export_vars -base "item-create" {return_url}]

			
ad_return_template
