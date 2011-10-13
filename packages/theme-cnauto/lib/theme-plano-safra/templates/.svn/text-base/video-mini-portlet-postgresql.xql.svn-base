<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_videos">
        <querytext>
	    select video_id,
		   package_id,
		   video_name,
		   video_description as hr,
		    to_date(video_date::text, 'YYYY-MM-DD') as date,
            acs_object__name(apm_package__parent_id(v.package_id)) as parent_name,
            (select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = v.package_id) as url
            from videos v
	    where v.package_id = :videos_package_id
            and 't' = acs_permission__permission_p(v.video_id, :user_id, 'read')
			and video_date is not null
            order by video_date desc
	    limit 1
        </querytext>
    </fullquery>

</queryset>
