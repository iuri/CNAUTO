ad_page_contract {
  See newsletter list

  @author Alessandro Landim

} {
	{newsletter_id}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set site_url [ad_url]
set package_url [apm_package_url_from_id $package_id]



permission::require_permission -party_id $user_id -object_id $package_id -privilege admin

	
ad_form -name newsletters -html {enctype multipart/form-data} -export {newsletter_id} 

array set package_info [lindex [site_node::get_all_from_object_id -object_id $package_id] 0]
array set parent_info [site_node::get -node_id $package_info(parent_id)]
set news_package_id [lindex [site_node_apm_integration::get_child_package_id  -package_id $parent_info(package_id) -package_key news] 0]
set news_html_options [news_get_latest_news_html_options -package_id $news_package_id]

set listnames [parameter::get -parameter "listAmsName" -package_id $package_id]
set newsletter_title [parameter::get -parameter "NewsletterTitle" -package_id $package_id]




ad_form -extend -name newsletters -form { 
	{title:text(text) {label "#newsletter.Title#"}}
	{imgfile:file}
	{link:text(text) {label "#newsletter.Link#"}}
}

ad_form -extend -name newsletters -on_submit {
          
	set current_news_number [db_string get_newsnumber {select max(item_number) from newsletters_items where newsletter_id = :newsletter_id} -default 1]
	if {$current_news_number == ""} {
		set current_news_number 1
	} else {
		incr current_news_number
	}

	set newsletter_title $title
	set title "$newsletter_title - $title"

	## TODO: add it in a parameter



	##Save
	set email_list ""	
	set newsletter_item_id [newsletters::items::save -content "" -title $title -item_number "-$current_news_number" -newsletter_id $newsletter_id -email_list $email_list]

	if {[exists_and_not_null imgfile]} {
		    # ImageMagick package will check its tmp directory for the file, so no
		    # need to expand the path.
		    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $newsletter_item_id

	}
	set image_id [ImageMagick::util::get_image_id -item_id $newsletter_item_id -name_null 1]

	set t "
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
		<html>
		<head>
		  <meta http-equiv=\"content-type\"
			 content=\"text/html; charset=ISO-8859-1\">
		</head>
		<body bgcolor=\"#ffffff\" text=\"#000000\">
		<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">
		<title>$title</title>
			<style type=\"text/css\">
			body {margin:auto 0px;}
			</style>
			<table align=\"center\">
				<tr><td>
			      <a href=\"$link\"><img border=\"0\" src=\"${site_url}${package_url}image/$image_id\" alt=\"\"></a></td></tr>
			</table>
		  </body>
		  </html>
	"

	newsletters::items::update_content -newsletter_item_id $newsletter_item_id -content $t

} -after_submit {
    ad_returnredirect "newsletter-items?newsletter_id=$newsletter_id"
    ad_script_abort
}
