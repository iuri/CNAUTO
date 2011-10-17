ad_page_contract {

    Display a list of news items to order


} {
  {order ""}
}


# Authorization:restricted to admin as long as in /news/admin
set package_id [ad_conn package_id]

# parameters URL
set return_url [ad_return_url]

if {[exists_and_not_null order]} {
	set order_num 0
	news_order_reset -package_id $package_id
	foreach news_id $order {
		news_order_item_set -news_id $news_id -order $order_num
		incr order_num	
	}
	util_memoize_flush_regexp "news*"
	ad_returnredirect "."
}

ah::requires -sources "jquery,jquery_table"
template::head::add_css -href "/resources/news/news.css"
set title "[_ news.Administration]" 
set context {}


# administrator sees all news items
db_multirow -extend { publish_date_pretty archive_date_pretty pretty_status image_id news_id} news_items itemlist {} {
    set publish_date_pretty [lc_time_fmt $publish_date_ansi "%x"]
    set archive_date_pretty [lc_time_fmt $archive_date_ansi "%x"]
    set pretty_status [news_pretty_status \
                           -publish_date $publish_date_ansi \
                           -archive_date $archive_date_ansi \
                           -status $status]
	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	set news_id [content::item::get_live_revision -item_id $item_id]
}


