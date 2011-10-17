<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="one_item">      
      <querytext>
      
select item_id,
       live_revision,
       publish_title,
       publish_lead,
       html_p,
       publish_date,
       '<a href="/shared/community-member?user_id=' || creation_user || '">' || item_creator ||  '</a>' as creator_link
from   news_items_live_or_submitted
where  item_id = :item_id
      </querytext>
</fullquery>


<fullquery name="get_content">      
      <querytext>
      select  content
    from    cr_revisions
    where   revision_id = :live_revision
      </querytext>
</fullquery>
 
</queryset>
