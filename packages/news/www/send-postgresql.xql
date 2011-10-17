<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="one_item">
      <querytext>
	   select publish_title,
       		  html_p,
       		  to_char(publish_date, 'DD/MM/YYYY HH:MI') as publish_date,
       		  '<a href=/shared/community-member?user_id=' || creation_user || '>' || item_creator ||  '</a>' as creator_link,
	   		  status
from   news_item_revisions
where  revision_id  = :live_revision 
      </querytext>
</fullquery>
 
</queryset>
