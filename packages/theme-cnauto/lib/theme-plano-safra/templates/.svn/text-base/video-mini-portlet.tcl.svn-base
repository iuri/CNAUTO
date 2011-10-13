ad_page_contract {
    A chunked version of a folder

    @author Iuri Sampaio (iuri.sampaio@iurix.com.br)
    @creation-date 2011-06-27
}


ns_log Notice "PAGE VIDEO_MINI_PORTLET"

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set videos_package_id [db_string select_package_id {
    SELECT object_id FROM site_nodes sn WHERE name = 'tvsafra' AND parent_id = (
		     SELECT node_id FROM site_nodes WHERE object_id = :package_id)
} -default ""]

set videos_url [apm_package_url_from_id $videos_package_id]


set query select_videos

if {![exists_and_not_null width]} {
	set width 170 
}

if {![exists_and_not_null height]} {
	set height 200
}


set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]


template::head::add_javascript -src "/resources/videos/swfobject.js"



set videos_p [db_0or1row select_videos {
    SELECT video_id FROM videos WHERE v.package_id = :videos_package_id
}]

if { $videos_p } {
    db_1row select_video {
	SELECT 
	video_id, 
	package_id, 
	video_name, 
	video_description as hr, 
	to_date(video_date::text, 'YYYY-MM-DD') as date, 
	acs_object__name(apm_package__parent_id(v.package_id)) as parent_name, 
	(select site_node__url(site_nodes.node_id) from site_nodes where site_nodes.object_id = v.package_id) as url
	FROM videos v
	WHERE v.package_id = :videos_package_id 
	AND video_date = (select max(video_date) FROM videos WHERE video_date IS NOT NULL)
	LIMIT 1
    } -column_array video

    
    set video_id 3626538
    #$video(video_id)
    ns_log Notice "VIDEO ID $video_id"

    set video_image_path [db_string select_image_path {
	SELECT cr.content FROM cr_revisions cr, acs_rels r WHERE r.object_id_one = :video_id AND r.rel_type = 'videos_image_thumbnail_rel' AND cr.item_id = r.object_id_two
    }]
    set video_image_path "/var/www/mda/content-repository-content-files/$video_image_path"

    ns_log Notice "$video(video_name)"
    set video_date_splited [split $date "-"]
    set videos_date "[lindex $video_date_splited 2]/[lindex $video_date_splited 1]"
    set hr [ad_html_to_text $hr]
    set hr [util_close_html_tags $hr "90" "90" "..." ""]
    set hr [string trimleft $hr "*"]
}
