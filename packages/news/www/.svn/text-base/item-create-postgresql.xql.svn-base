<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_news_item">
      <querytext>

    select news__new(
        null,               -- p_item_id
        null,              -- p_locale
        :publish_date_ansi, -- p_publish_date
        :publish_body,      -- p_text
        :lang,               -- p_nls_language
        :publish_title,     -- p_title
        :mime_type,         -- p_mime_type
        :package_id,        -- p_package_id
        null, 		    -- p_archive_date
        :approval_user,     -- p_approval_user
        :approval_date,     -- p_approval_date
        :approval_ip,       -- p_approval_ip
        null,               -- p_relation_tag
        :creation_ip,       -- p_creation_ip
        :user_id,           -- p_creation_user
        :live_revision_p,   -- p_is_live_p
        :publish_lead,      -- p_lead
		:priority			-- p_priority
    );

      </querytext>
</fullquery>


<fullquery name="week">      
      <querytext>
      select to_char(current_timestamp + interval '[ad_parameter ActiveDays "news" 14] days', 'YYYY-MM-DD')
      </querytext>
</fullquery>

 
</queryset>
