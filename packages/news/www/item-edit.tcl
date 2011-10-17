# /packages/news/www/item-create.tcl

ad_page_contract {

    This page enables registered users and the news-admin 
    to enter news releases.

    @author stefan@arsdigita.com
    @creation-date 2000-11-14
    @cvs-id $Id: item-create.tcl,v 1.4 2006/11/09 12:21:54 alessandrol Exp $

} {
    {publish_title {}}
    {publish_lead {}}
    {publish_body:allhtml {}}
    {html_p {}}
    {publish_date_ansi {now}}
    {archive_date_ansi {}}
    {permanent_p {}}
    {revision_id}
} -properties {
    title:onevalue
    context:onevalue
    publish_date_select:onevalue
    archive_date_select:onevalue
    immediate_approve_p:onevalue
}


set title "[_ news.Create_News_Item]"
set context [list $title]

# Authorization by news_create
set package_id [ad_conn package_id]
ad_require_permission $package_id news_admin
set item_id [content::revision::item_id -revision_id $revision_id]
set image_width_size [parameter::get -parameter WidthImageSize -default "480"]

# Furthermore, with news_admin privilege, items are approved immediately
# or if open approval policy

db_1row select_item {}

if { $publish_date eq "" } {
    set immediate_approve_p 0
} else {
    set immediate_approve_p 1
}

set return_url ""
ad_form -name news \
    -cancel_url [ad_decode $return_url "" "." $return_url] \
	-html {enctype multipart/form-data} \
    -form {
	{revision_id:text(hidden) {value $revision_id}}
    {publish_title:text
            {label "[_ news.Title]"}
            {html {size 50}}}
	{approval_user:text(hidden),optional}
        {approval_ip:text(hidden),optional}
        {approval_date:text(hidden),optional}
        {creation_ip:text(hidden),optional}
        {live_revision_p:text(hidden),optional}
        {publish_lead:text(hidden),optional}
        {user_id:text(hidden),optional}
        {publish_date_select:text(text),optional
        	{label "[_ news.publish_date_select]"}
        	{after_html {<input type='button' value=' ... ' onclick=\"return showCalendar('publish_date_select', 'y-m-d');\">  <div class="form-help-text"><img src="/shared/images/info.gif" width="12" height="9" alt="\[i\]" title="Help text" border="0"> [_ calendar.ymd]</div> }}} 
        {confirm_url:text(hidden),optional}
	    {imgfile:file,optional
				{label "#news.Image#"}
		}
		{imgdescription:text,optional
			{label "#news.Image_description#"}
		}

       } \
    -export {return_url}


if { $immediate_approve_p } {
	ad_form -extend -name news -form {
       	{archive_date_select:text(hidden),optional}
	}
    element set_value news approval_user [ad_conn user_id]
    element set_value news approval_ip [ad_conn peeraddr]
    element set_value news creation_ip [ad_conn peeraddr]
    element set_value news live_revision_p t
    element set_value news confirm_url ""
} else {
	set archive_date_select ""
        element set_value news confirm_url needing-approval
}

element set_value news user_id [ad_conn user_id]

ad_form -extend -name news -form {
	{priority:text(radio),optional
			{label "[_ news.Priority]"}
			{options {{#news.Max_priority# 0} {#news.Normal_priority# 3}}}
	}
    {publish_body:richtext(richtext),nospell
            {label "[_ news.publish_body]"}
            {html {cols 70}}}
    
}

if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
        ad_form -extend -name news -form {
            {category_ids:integer(category),multiple {label "[_ news.Categories]"}
                {html {size 3}} {value {$item_id $package_id}}
            }
        }
}

set lang_enable_p [parameter::get -parameter LangEnableP -default 0]
if {$lang_enable_p} {
	 foreach lang_option [lang::system::get_locales] {
			lappend options [list $lang_option $lang_option]
	 }

     ad_form -extend -name news -form {
            {lang:text(select) {label "[_ news.Lang]"}
                {options $options}
            }
     }
}



ad_form -extend -name news -on_request {
	
    db_1row select_item {}
    set publish_body [list $publish_body]
    template::util::richtext::set_property contents $publish_body $publish_body
    set archive_date_select $archive_date 
    set publish_date_select $publish_date
    
    
    set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
    if {[exists_and_not_null image_id]} {
	set image_item_id [content::revision::item_id -revision_id $image_id]
	content::item::get -item_id $image_item_id -array_name image_details
	set imgdescription $image_details(description)
    }
    
}

ad_form -extend -name news -on_submit {
    if {$publish_date_select == "" && $immediate_approve_p} {
	set publish_date_select now
    }
    
    if {![exists_and_not_null lang]} {
	set lang [lang::conn::locale]
    }
    
    
    set publish_date_ansi $publish_date_select
    set archive_date_ansi $archive_date_select
    set approval_date $publish_date_select
    
    set publish_body [template::util::richtext::get_property contents $publish_body]
    set mime_type "text/html"
    set package_id [ad_conn package_id]
    
    if {$priority == ""} {
	set priority [db_string get_priority {select priority from news_items_live_or_submitted where item_id = :item_id} -default ""] 
    }
    
    set news_id [db_exec_plsql create_news_revision {}]
    
    set tmpfile ""
    if {[exists_and_not_null imgfile]} {

	# Copy original image to avoid distortion
	set tmp_filename [ns_tmpnam]
	file copy [lindex $imgfile 1] $tmp_filename
	set tmp_name  [lindex $imgfile 0]
	set tmpfile "$tmp_name $tmp_filename"


	# ImageMagick package will check its tmp directory for the file, so no
	# need to expand the path.
	db_1row item {
	    select item_id from cr_revisions where revision_id = :news_id
	}
	
	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	set size-2-image_id [ImageMagick::util::get_image_id -item_id $item_id -name "size-2"]
	set size-3-image_id [ImageMagick::util::get_image_id -item_id $item_id -name "size-3"]

	
	if {$image_id != ""} {
	    set image_item_id [content::revision::item_id -revision_id $image_id]
	    ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width $image_width_size -description $imgdescription
	} else {
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -width $image_width_size -description $imgdescription
	}
	
	if {${size-2-image_id} != ""} {
	    set image_item_id [content::revision::item_id -revision_id ${size-2-image_id}]
	    ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width 170 -description $imgdescription -name "size-2"
	} else {
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -name "size-2" -width 170 -description $imgdescription
	}
	
	if {${size-3-image_id} != ""} {
	    set image_item_id [content::revision::item_id -revision_id ${size-3-image_id}]
	    ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width 100 -description $imgdescription -name "size-3"
	} else {
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -name "size-3" -width 100 -description $imgdescription
	}
	
	
    } else {
	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	if {$image_id != ""} {
	    ImageMagick::util::update_description -description $imgdescription -image_id $image_id
	}
    }
    
    if {[exists_and_not_null category_ids]} {
	db_1row item {
	    select item_id from cr_revisions where revision_id = :news_id
	}
	category::map_object -remove_old -object_id $item_id $category_ids
     } 
    
    
    

    set replicate_item_p [parameter::get -package_id $package_id -parameter "ReplicateNewsItemP" -default 0]
    set rel_p [db_0or1row select_rel_p {
	SELECT rel_id FROM acs_rels WHERE rel_type = 'replicated_news' AND object_id_one = :item_id
    }]
    
    if {$replicate_item_p && $rel_p} {
	news_revise_replicated_item -revision_id $news_id -imgfile $imgfile
    }
    
    
    util_memoize_flush_regexp "news*"

    
    if { $immediate_approve_p && [apm_package_installed_p dotlrn]} {
	news_do_notification $package_id $news_id
    }


    set preview_item_p [parameter::get -package_id $package_id -parameter "PreviewNewsItemP" -default 0]
    
    if {$preview_item_p} {
	ad_returnredirect [export_vars -base preview { item_id }]
	ad_script_abort
    } else {
	
	if {[string equal "open" [ad_parameter ApprovalPolicy "news" "open"]] } {
	    ad_returnredirect "item?item_id=$item_id"
	} elseif {[ad_permission_p $package_id news_admin]} {
	    ad_returnredirect "item?item_id=$item_id"
	} else {
	    ad_returnredirect $confirm_url
	}
    }    
    ad_script_abort    
}


