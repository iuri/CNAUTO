
set site_url [ad_url]

set news_items_sql [join $news_items ","]

db_multirow -extend {publish_body180 publish_body54 publish_body204 image_id_size_2} get_news_items get_news_items {} {

    	set publish_title [ad_html_to_text $publish_title]
    	set publish_body [ad_html_to_text $publish_body]
  	set publish_body180 [util_close_html_tags $publish_body "180" "180" "..." ""]
   	set publish_body54 [util_close_html_tags $publish_body "54" "54" "..." ""]
   	set publish_body204 [util_close_html_tags $publish_body "204" "204" "..." ""]

	
	set image_id_size_2 [ImageMagick::util::get_image_id -item_id $item_id -name "size-2"]

}


