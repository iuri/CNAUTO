<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="one_item">      
      <querytext>
      
select item_id,
       live_revision,
       publish_title,
       html_p,
       to_char(publish_date, 'DD/MM/YYYY HH24:MI') as publish_date,
       publish_body,
       '<a href="/shared/community-member?user_id=' || creation_user || '">' || item_creator ||  '</a>' as creator_link
from   news_items_live_or_submitted
where  item_id = :item_id
      </querytext>
</fullquery>
 
<fullquery name="item_list">      
      <querytext>
      
select item_id,
       publish_title
from   news_items_approved
where    package_id = :package_id
order  by publish_date desc, item_id desc
limit 5
      </querytext>
</fullquery>


</queryset>
