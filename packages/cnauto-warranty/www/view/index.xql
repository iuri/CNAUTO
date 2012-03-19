<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>
    <fullquery name="select_recent_videos">
      <querytext>
	select v.video_id,
	  v.package_id,
	  v.video_name,
	  v.autor,
          acs_object__name(apm_package__parent_id(v.package_id)) as parent_name,
          (select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = v.package_id) as url
        from videos v
	where v.package_id = :package_id
        and 't' = acs_permission__permission_p(v.video_id, :user_id, 'read')
	limit 5

      </querytext>
    </fullquery>

    <fullquery name="select_popular_videos">
      <querytext>
	select DISTINCT v.video_id,
	  v.package_id,
	  v.video_name,
	  v.autor,
          acs_object__name(apm_package__parent_id(v.package_id)) as parent_name,
          (select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = v.package_id) as url
        from videos v, videos_rank vr
	where v.package_id = :package_id
	and vr.video_id = v.video_id
	and vr.counter > 2
        and 't' = acs_permission__permission_p(v.video_id, :user_id, 'read')
	limit 10

      </querytext>
    </fullquery>


    <fullquery name="select_videos">
      <querytext>
	select v.video_id,
	  v.package_id,
	  v.video_name,
	  v.video_description,
	  v.autor,
          acs_object__name(apm_package__parent_id(v.package_id)) as parent_name,
          (select site_node__url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = v.package_id) as url
        from videos v
	where v.package_id = :package_id
        and 't' = acs_permission__permission_p(v.video_id, :user_id, 'read')
	order by random()
	limit 2
	
      </querytext>
    </fullquery>
    
</queryset>

