# /packages/news/www/item.tcl

ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: item.tcl,v 1.4 2006/10/18 13:37:27 alessandrol Exp $
    
} {

    item_id:integer,notnull

} -properties {
    title:onevalue
    context:onevalue 
    item_exist_p:onevalue
    publish_title:onevalue
    publish_date:onevalue
    publish_body:onevalue
    html_p:onevalue
    creator_link:onevalue
    comments:onevalue
    comment_link:onevalue
}

template::head::add_css -href "/resources/acs-templating/fontsize/font-size.css"
template::head::add_javascript -src "/resources/acs-templating/fontsize/font-size.js"


set user_id [ad_conn untrusted_user_id]
set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set site_url [ad_url]
set return_url [ad_return_url]
ah::requires -sources "lightboxJS"
# live view of a news item in its active revision

#set live_revision [content::item::get_live_revision -item_id $item_id]
set live_revision [db_string get_live_revision {select revision_id from cr_revisions where item_id = :item_id order by revision_id desc limit 1} -default ""]
set lang_enable_p [parameter::get -parameter LangEnableP -default 0]
if {$lang_enable_p} {
	set user_locale [lang::conn::locale]
	set lang_live_revision [db_string get_lang_live_revision {select revision_id from cr_revisions where item_id = :item_id and nls_language = :user_locale order by revision_id desc limit 1} -default 0]

	if {$lang_live_revision != 0} {
		set live_revision $lang_live_revision
	}
} 


set item_exist_p [db_0or1row one_item {}]




set publish_title_one $publish_title
set item_id_orig $item_id
if { $item_exist_p } {

	permission::require_permission \
    		-object_id $item_id \
    		-party_id  $user_id \
    		-privilege read


    # workaround to get blobs with >4000 chars into a var, content.blob_to_string fails! 
    # when this'll work, you get publish_body by selecting 'publish_body' directly from above view
    #
    # RAL: publish_body is already snagged in the 1st query above for postgres.
    #
    
	set publish_body [db_string get_content "select  content
	from    cr_revisions
	where   revision_id = :live_revision"]
    

    # text-only body
    if {[info exists html_p] && [string equal $html_p "f"]} {
	set publish_body [ad_text_to_html -- $publish_body]
    }
    
    regsub -all {size=} $publish_body {removed=} publish_body
    regsub -all {color=} $publish_body {removed=} publish_body
    if { [ad_parameter SolicitCommentsP "news" 0] && [ad_permission_p $item_id general_comments_create] } {
	set comment_link [general_comments_create_link $item_id "[ad_conn package_url]item?item_id=$item_id"]
	set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
		$item_id "[ad_conn package_url]item?item_id=$item_id"]
    } else {
	set comment_link ""
        set comments ""
    }
	
	set videos_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key videos]
	set sounds_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key sounds]
	set fs_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key file-storage]
	set attach_p 0
	set attach_link ""
	set delete_link ""
	set image_edit_link ""
    set status_link ""
    set edit_link ""
	set replicate_link ""
if {$videos_package_id != "" || $sounds_package_id != "" || $fs_package_id != ""} {
		set attach_p 1
	}


    if {[permission::permission_p -object_id $item_id -privilege news_admin] } {
	set replicate_link "<a href=\"admin/replicate-news?revision_id=$live_revision&return_url=$return_url\">#news.Replicate_News_Item#</a>"
	set edit_link "<a href=\"item-edit?revision_id=$live_revision\">#news.Revise#</a>"
        set delete_link "<a href=\"admin/process?action=delete&n_items=$item_id\">#news.Delete#</a>"
	
	set image_edit_link "<a href=\"image-edit?item_id=$item_id\">#news.Revise_image#</a>"
        if {$attach_p} {
	    set attach_link "<a href=\"item-attach-file?item_id=$item_id\">#news.Attach_file#</a>"
	}
	if {$status eq "unapproved"} {
	    set status_link "<a class=\"approve\" href=\"admin/approve?n_items=$item_id&return_url=$return_url\">#news.Approve#</a>"
	}
    }

	set image_width_size [parameter::get -parameter WidthImageSize -default "480"]

    set title $publish_title
    set context [list $title]
    set publish_title {}
   
    set user_id [ad_conn user_id]
    set displayed_object_id $item_id


    set SolicitRatingP [parameter::get -parameter SolicitRatingP -package_id [ad_conn package_id] -default 1]
if {[apm_package_installed_p ratings] && $SolicitRatingP} {
    
	set rate_form [ratings::form -object_id $displayed_object_id]
	set current_rating [ratings::get -object_id $displayed_object_id -user_id $user_id]
	array set ratings [ratings::aggregates::get -object_id $displayed_object_id]
	
	if {[info exists ratings(all_rating_ave)]} {
	    set ratings(stars) [ratings::icon::html_fragment -rating $ratings(all_rating_ave)]
	} else {
	    set ratings(all_ratings) 0
	    set ratings(stars) {}
	}
	if {![empty_string_p $current_rating]} {
	    set stars [ratings::icon::html_fragment -rating $current_rating]
	}
	
    }

	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]


	if {![empty_string_p $image_id]} { 
	  	set publish_image "./image/$image_id"
		set image_item_id [content::revision::item_id -revision_id $image_id]
	
		content::item::get -item_id $image_item_id -array_name image_details
	} else {
	  set publish_image ""
	}


	set publish_body54 [util_close_html_tags $publish_body "120" "120" "..." ""]

	template::head::add_meta -name "og:title" -content $title 
	template::head::add_meta -name "og:description" -content $publish_body54
	if {[exists_and_not_null image_id]} {
		template::head::add_meta -name "og:image" -content "${site_url}${package_url}image/$image_id"
	}



} else {
    set context {}
    set title "[_ news.Error]"
    set SolicitRatingP 0
}


if {![exists_and_not_null image_details(description)]} {
	set image_details(description) ""
}


set file_list ""
set videos_list ""
set sounds_list ""


# check if have a linked video
set video_ids [application_data_link::get_linked_content -from_object_id $item_id -to_content_type videos_object]
set videos_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key videos]

foreach video_id $video_ids {
 	append videos_list [template::adp_include /packages/videos/templates/portal-playlist-mini-portlet \
				[list package_id $videos_package_id video_id $video_id width 320 height 202 playlist_size 0]]
}


# check if have a linked sound! TODO
#set sound_ids [application_data_link::get_linked -from_object_id $item_id -to_object_type sounds_object]
#set sounds_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key sounds]

#foreach sound_id $sound_ids {
#	lappend sounds_list {
#			<include src="/packages/sounds/templates/portal-playlist-mini-portlet" package_id="$sounds_package_id" video_id="$sound_id">
#	}
#}


# check if have a linked file
set file_ids [application_data_link::get_linked_content -from_object_id $item_id -to_content_type file_storage_object]

foreach file_id $file_ids {
	set name [acs_object_name $file_id]
	append file_list "<li><a title=\"$name\" alt=\"$name\" href=\"/o/$file_id\">$name</a></li>"
}


db_multirow news_items item_list {} {
}





# Stuff for ratings.
#set rate_form [ratings::widget -object_one $displayed_object_id]


ah::requires -sources "jquery"
template::head::add_javascript -script "
	\$( document ).ready(
		function()
		{
			\$( \"#sendemail\" ).click( function(){  \$( \"#sendemailform\" ).fadeIn(); } );
		}
	);

	function sendEmail( objForm )
	{
		\$( \"#sucesso\" ).css( \"display\", \"none\" );
		\$( \"#erro\" ).css( \"display\", \"none\" );
		var strError = \"\";
		if( objForm.name.value == \"\" )
		{
			strError += \"Informe o seu nome.\";
		}
		if( objForm.email.value == \"\" )
		{
			strError += \"Informe o e-mail de destinatário.\";
		}
		if( strError != \"\" )
		{
			\$( \"#erro-texto\" ).empty();
			\$( \"#erro-texto\" ).append( strError );
			\$( \"#erro\" ).fadeIn();
		} else {

			var strParameters = \"name=\" + objForm.name.value;
			strParameters += \"&email=\" + objForm.email.value;
			strParameters += \"&texto=\" + objForm.texto.value;
			strParameters += \"&item_id=\" + objForm.item_id.value;
			var strUrl = objForm.action;

 			\$( \"#loading\" )
			.ajaxStart
			(
				function()
				{
					\$( this ).fadeIn();
					\$( \"#sendemailform\" ).fadeOut();
				}
			)
			.ajaxStop
			(
				function()
				{
					\$( this ).fadeOut();
				}
			);

			var strResult;
			$.ajax({ type: \"POST\", async: false, dataType: \"json\", url: strUrl, data: strParameters, success: function( data ){ strResult = data; } });
			setData( strResult );
		}
	}

	function setData( objResult )
	{
		\$( \"#sucesso\" ).css( \"display\", \"block\" );
		\$( \"#sucesso-texto\" ).empty();
		\$( \"#sucesso-texto\" ).append( 'E-mail enviado com sucesso!' );
	}
" -order 9
