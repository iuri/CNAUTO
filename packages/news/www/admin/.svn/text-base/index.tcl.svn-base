# /packages/news/www/admin/index.tcl

ad_page_contract {

    Display a list of news items summary for administration

    @author Stefan Deusch (stefan@arsdigita.com)
    @creation-date 2000-12-20
    @cvs-id $Id: index.tcl,v 1.2 2006/10/10 15:03:32 alessandrol Exp $

} {
  {orderby: "item_id"}
  {view: "published"}
  {column_names:array ""}
  {range "0"}
} -properties {
    title:onevalue
    context:onevalue
    view_link:onevalue
    hidden_vars:onevalue
    select_actions:onevalue
    item_list:multirow
}


# Authorization:restricted to admin as long as in /news/admin
set package_id [ad_conn package_id]

# parameters URL
set return_url [ad_return_url]
set news_url [site_node::get_url_from_object_id -object_id $package_id]



set view_slider [list \
    [list view "[_ news.News_Items]" published [list \
	[list published "[_ news.Published]" {where "status like 'published%'"}] \
	[list unapproved "[_ news.Unapproved]" {where "status = 'unapproved'"}] \
	[list approved "[_ news.Approved]" {where "status like 'going_live%'"}] \
	[list archived "[_ news.Archived]"     {where "status = 'archived'"}] \
        [list all "[_ news.All]"               {} ] \
    ]]
]
set view_link [ad_dimensional $view_slider]
set view_option [ad_dimensional_sql $view_slider]
# define action on selected views, unapproved, archived, approved need restriction
switch $view {
    "unapproved" { 
        set select_actions "<option value=\"publish\">[_ news.Publish]" 
    }
    "archived"   { 
        set select_actions "<option value=\"publish\">[_ news.Publish]" 
    }
    "approved"   { 
        set select_actions "<option value=\"make permanent\">[_ news.Make_Permanent]" 
    }
    default      {
	set select_actions "
	<option value=\"archive now\" selected>[_ news.Archive_Now]</option>
	<option value=\"archive next week\">[_ news.lt_Archive_as_of_Next_We]</option>
	<option value=\"archive next month\">[_ news.lt_Archive_as_of_Next_Mo]</option>
	<option value=\"make permanent\">[_ news.Make_Permanent]"
    }
}

set title "[_ news.Administration]" 
set context {}
set limit 200
set item_id_list [db_list itemlist_items {}]

set first $range
set last [expr $first + $limit]

set items_range_sql ""
set items_ranged [lrange $item_id_list $first $last]

if {$items_ranged != ""} {
	set items_range_sql "and item_id in ([join $items_ranged ,])" 
}

set item_id_list_total [llength $item_id_list]
set html_range 0
set range_options ""
while {$item_id_list_total > $html_range} {
	set new_range [expr $html_range + $limit]
	append range_options "<a href=\"index?range=$html_range\">$html_range-$new_range</a> | "
	set html_range $new_range
}

# administrator sees all news items
db_multirow -extend { publish_date_pretty archive_date_pretty pretty_status } news_items itemlist {} {
    set publish_date_pretty [lc_time_fmt $publish_date_ansi "%x"]
    set archive_date_pretty [lc_time_fmt $archive_date_ansi "%x"]
    set pretty_status [news_pretty_status \
                           -publish_date $publish_date_ansi \
                           -archive_date $archive_date_ansi \
                           -status $status]
}

set rss_exists [rss_support::subscription_exists \
                    -summary_context_id $package_id \
                    -impl_name news]
set rss_feed_url [news_util_get_url $package_id]rss/rss.xml

