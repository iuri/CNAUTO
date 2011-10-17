DROP FUNCTION news__revision_new(integer, timestamp with time zone, text, character varying, text, character varying, integer, timestamp with time zone, integer, timestamp with time zone, character varying, timestamp with time zone, character varying, integer, boolean, character varying);
DROP FUNCTION news__revision_new(integer, timestamp with time zone, text, character varying, text, character varying, integer, timestamp with time zone, integer, timestamp with time zone, character varying, timestamp with time zone, character varying, integer, boolean, character varying, integer);

create or replace function news__revision_new (integer,timestamptz,text,varchar,text,
       varchar,integer,timestamptz,integer,timestamptz,varchar,timestamptz,varchar,
       integer,boolean, varchar, integer,varchar)
returns integer as '
declare
    p_item_id                alias for $1;
    --
    p_publish_date           alias for $2;  -- default null
    p_text                   alias for $3;  -- default null
    p_title                  alias for $4;
    --
    -- here goes the revision log
    p_description            alias for $5;
    --
    p_mime_type              alias for $6;  -- default ''text/plain''
    p_package_id             alias for $7;  -- default null
    p_archive_date           alias for $8;  -- default null
    p_approval_user          alias for $9;  -- default null
    p_approval_date          alias for $10; -- default null
    p_approval_ip            alias for $11; -- default null
    --
    p_creation_date          alias for $12; -- default current_timestamp
    p_creation_ip            alias for $13; -- default null
    p_creation_user          alias for $14; -- default null
    --
    p_make_active_revision_p alias for $15; -- default ''f''
    p_lead                   alias for $16;
	p_priority				 alias for $17;
	p_lang					 alias for $18; 

    v_revision_id    integer;
begin
    -- create revision
    v_revision_id := content_revision__new(
        p_title,         -- title
        p_description,   -- description
        p_publish_date,  -- publish_date
        p_mime_type,     -- mime_type
        p_lang,          -- nls_language
        p_text,          -- text
        p_item_id,       -- item_id
        null,            -- revision_id
        p_creation_date, -- creation_date
        p_creation_user, -- creation_user
        p_creation_ip    -- creation_ip
    );
    -- create new news entry with new revision
    insert into cr_news
        (news_id, 
         lead,
         package_id,
         archive_date, 
         approval_user, 
         approval_date, 
         approval_ip,
		 priority)
    values
        (v_revision_id, 
         p_lead,
         p_package_id,
         p_archive_date, 
         p_approval_user, 
         p_approval_date,
         p_approval_ip,
		 p_priority);
    -- make active revision if indicated
    if p_make_active_revision_p = ''t'' then
        PERFORM news__revision_set_active(v_revision_id);
    end if;
    return v_revision_id;
end;
' language 'plpgsql';


