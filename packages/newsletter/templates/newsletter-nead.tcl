
set site_url [ad_url]

set news_items_sql [join $news_items ","]
set package_url [apm_package_url_from_id $package_id]


set listnames [parameter::get -parameter "listAmsName" -package_id $package_id]
foreach listname $listnames {
	 set amsvalues [ams::values -package_key "newsletter" -object_type "newsletter_item" -list_name $listname -object_id $newsletter_item_id]
	 foreach {nothing1 atribute_name atribute_pretty_name value} $amsvalues {
		set $atribute_name $value
	 } 
}


set agenda_texto_width 0
set textoculturadigital_width 0
set favoritos_texto_width 0

if {[exists_and_not_null agenda_texto]} {
	set agenda_texto_width 1
} 

if {[exists_and_not_null textoculturadigital]} {
	set textoculturadigital_width 1
} 

if {[exists_and_not_null favoritos_texto]} {
	set favoritos_texto_width 1
}

set t [expr $favoritos_texto_width + $textoculturadigital_width + $agenda_texto_width]

switch $t {
	1 { set box_width "730px"}
	2 { set box_width "360px"}
	3 { set box_width "232px"}
}





set date [dt_sysdate -format "%d/%m/%Y"]
db_multirow -extend {publish_body180 publish_body54 publish_body204 publish_body404 image_id_size_2} get_news_items get_news_items {} {

  	set publish_title [ad_html_to_text $publish_title]
   	set publish_body [ad_html_to_text $publish_body]
  	set publish_body180 [util_close_html_tags $publish_body "180" "180" "..." ""]
   	set publish_body54 [util_close_html_tags $publish_body "54" "54" "..." ""]
   	set publish_body204 [util_close_html_tags $publish_body "204" "204" "..." ""]
   	set publish_body404 [util_close_html_tags $publish_body "404" "404" "..." ""]

	
    set image_id_size_2 [ImageMagick::util::get_image_id -item_id $item_id -name "size-2"]
	set date [dt_sysdate -format "%d/%m/%Y"]

}


