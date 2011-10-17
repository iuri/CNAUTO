<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="select_item">      
      <querytext>
      
select 
       title as publish_title,
       to_char (archive_date, 'YYYY-MM-DD') as archive_date,
       publish_date,
	   nls_language as lang,
       content as publish_body,
	   priority,
	   publish_date
from   cr_revisions,
	   cr_news
where  revision_id = :revision_id
and    cr_revisions.revision_id = cr_news.news_id
      </querytext>
</fullquery>

<fullquery name="create_news_revision">      
      <querytext>
 

select news__revision_new (
	 :item_id,   		--p_item_id
	 :publish_date_ansi,  	--p_publish_date
	 :publish_body, 	--publish_body
	 :publish_title,        --publish_title
	 null,                  --description
	 :mime_type,            --p_mime_type
	 :package_id,           --package_id
	 :archive_date_ansi,    --archive_date
	 :approval_user,        --approval_user
	 :approval_date,        --approval_date
	 :approval_ip,          --approval_ip
	 null,                  --creation_date
	 :creation_ip,          --creation_ip
	 :user_id,              --creation_user
	 :live_revision_p,      --p_is_live_p
	 :publish_lead,			--p_lead
	 :priority, 			--priority
	 :lang 				--nsl_language		
		);        
      </querytext>
</fullquery>


</queryset>
