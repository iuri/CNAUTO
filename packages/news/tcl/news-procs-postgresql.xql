<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="news_items_archive.news_item_archive">      
      <querytext>

          select news__archive(
	      :id, -- item_id
	      :when -- archive_date
	  );
      </querytext>
</fullquery>

 
<fullquery name="news_items_make_permanent.news_item_make_permanent">      
      <querytext>

          select news__make_permanent(:id);
	
      </querytext>
</fullquery>

 
<fullquery name="news_items_delete.news_item_delete">      
      <querytext>

          select news__delete(:id);
	
      </querytext>
</fullquery>


 
<fullquery name="news_delete_replicated_items.news_item_delete">      
      <querytext>

          select news__delete(:id);
	
      </querytext>
</fullquery>


<fullquery name="news_util_get_url.get_url_stub">
      <querytext>

	  select site_node__url(node_id) as url_stub
          from site_nodes
          where object_id=:package_id      
          limit 1
	
      </querytext>
</fullquery>

<fullquery name="news__rss_datasource.get_news_items">
        <querytext>
        select cn.*,
        ci.item_id,
        cr.content,
        cr.title,
        cr.mime_type,
        cr.description,
        to_char(o.last_modified, 'YYYY-MM-DD HH24:MI:SS') as last_modified
        from cr_news cn,
        cr_revisions cr,
        cr_items ci,
        acs_objects o
        where cn.package_id=:summary_context_id
        and cr.revision_id=cn.news_id
        and cn.news_id=o.object_id
        and cr.item_id=ci.item_id
        and cr.revision_id=ci.live_revision
        order by o.last_modified desc
        limit $limit
        </querytext>
</fullquery>
 
<fullquery name="news_revision_set_image_id.set_image_rel">
        <querytext>
select acs_rel__new(null, 'relationship', :revision_id, :image_id, null, :creation_user, :peeraddr)
        </querytext>
</fullquery>

<fullquery name="news_get_mda_portlet_html_not_cached.select_news_items">      
      <querytext>
            select news_items_approved.package_id,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   news_items_approved.priority,
                   to_char(news_items_approved.publish_date, 'DD/MM/YYYY') as publish_date_ansi,
                   item_creator,
                   creation_user,
		   news_items_approved.publish_body
            from news_items_approved
		where package_id = :package_id
            and (news_items_approved.archive_date >= current_timestamp or news_items_approved.archive_date is null)
	    	and news_items_approved.publish_date < current_timestamp
            order by news_items_approved.priority, news_items_approved.publish_date desc
	    limit :limit
      </querytext>
</fullquery>


<fullquery name="news_replicate_item.select_item_id">
  <querytext>

      SELECT item_id 
      FROM cr_revisions
      WHERE revision_id = :revision_id 

  </querytext>
</fullquery>


<fullquery name="news_replicate_item.select_news_info">
  <querytext>
	SELECT lead AS publish_lead, priority
	FROM cr_news
	WHERE news_id = :revision_id 

  </querytext>
</fullquery>

<fullquery name="news_replicate_item.select_content">
  <querytext>

      SELECT content 
      FROM cr_revisions 
      WHERE revision_id = :revision_id

  </querytext>
</fullquery>

<fullquery name="news_replicate_item.select_imgdescription">
  <querytext>
    SELECT description AS imgdescription
    FROM cr_revisions
    WHERE revision_id = :image_id

  </querytext>
</fullquery>


<fullquery name="news_replicate_item.create_news_item">
  <querytext>

    SELECT news__new(
    null,               -- p_item_id
    null,              -- p_locale
    :publish_date_ansi, -- p_publish_date
    :publish_body,      -- p_text
    :lang,               -- p_nls_language
    :publish_title,     -- p_title
    :mime_type,         -- p_mime_type
    :package_id,        -- p_package_id
    null,               -- p_archive_date
    :approval_user,     -- p_approval_user
    :approval_date,     -- p_approval_date
    :approval_ip,       -- p_approval_ip
    null,               -- p_relation_tag
    :approval_ip,       -- p_creation_ip
    :approval_user,     -- p_creation_user
    :live_revision_p,   -- p_is_live_p
    :publish_lead,      -- p_lead
    :priority           -- p_priority
    );
    
  </querytext>
</fullquery>


<fullquery name="news_replicate_item.select_new_item_id">
  <querytext>
    SELECT item_id AS new_item_id
    FROM cr_revisions
    WHERE revision_id = :news_id
    
  </querytext>
</fullquery>


<fullquery name="news_revise_replicated_item.select_item_id">
  <querytext>

      SELECT item_id 
      FROM cr_revisions
      WHERE revision_id = :revision_id 

  </querytext>
</fullquery>

<fullquery name="news_revise_replicated_item.select_news_info">
  <querytext>
	SELECT lead AS publish_lead, priority, archive_date
	FROM cr_news
	WHERE news_id = :revision_id

  </querytext>
</fullquery>

<fullquery name="news_revise_replicated_item.select_content">
  <querytext>

      SELECT content FROM cr_revisions WHERE revision_id = :revision_id

  </querytext>
</fullquery>


<fullquery name="news_revise_replicated_item.select_imgdescription">
  <querytext>

    SELECT description AS imgdescription FROM cr_revisions WHERE revision_id = :image_id
  </querytext>
</fullquery>


<fullquery name="news_revise_replicated_item.select_replicated_revision_ids">
  <querytext>

    SELECT live_revision FROM cr_items WHERE item_id IN (SELECT object_id_two FROM acs_rels WHERE object_id_one = :item_id)

  </querytext>
</fullquery>



<fullquery name="news_revise_replicated_item.select_package_id">
  <querytext>

    SELECT package_id FROM acs_objects WHERE object_id = :replicated_item_id

  </querytext>
</fullquery>



<fullquery name="news_revise_replicated_item.create_news_revision">
  <querytext>
    
    SELECT news__revision_new (
    :replicated_item_id,   --p_item_id
    :publish_date_ansi,    --p_publish_date
    :publish_body,         --publish_body
    :publish_title,        --publish_title
    null,                  --description
    :mime_type,            --p_mime_type
    :package_id,           --package_id
    :archive_date_ansi,    --archive_date
    :approval_user,        --approval_user
    :approval_date,        --approval_date
    :approval_ip,          --approval_ip
    :approval_date,        --creation_date
    :approval_ip,          --creation_ip
    :approval_user,        --creation_user
    :live_revision_p,      --p_is_live_p
    :publish_lead,         --p_lead
    :priority,             --priority
    :lang                  --nsl_language
    );
  </querytext>
</fullquery>


</queryset>
