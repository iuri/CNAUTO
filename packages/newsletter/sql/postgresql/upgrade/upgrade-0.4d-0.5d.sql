ALTER TABLE newsletters ADD COLUMN layout character varying;
DROP FUNCTION newsletters__new(integer, character varying, character varying, integer, timestamp with time zone, integer, character varying, integer);
DROP FUNCTION newsletters__edit(integer, character varying, character varying);

create or replace function newsletters__new (
    integer, -- newsletter_id
    varchar, -- name
    varchar, -- description
	varchar, -- layout
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_newsletter_id         alias for $1;
    p_name                  alias for $2;
    p_description           alias for $3;
    p_layout 		        alias for $4;
    p_package_id            alias for $5;
    p_creation_date         alias for $6;
    p_creation_user         alias for $7;
    p_creation_ip           alias for $8;
    p_context_id            alias for $9;
  
    v_newsletter_id               integer;
begin

	v_newsletter_id := acs_object__new (
		p_newsletter_id,	 -- object_id
		''newsletter'',         -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	        p_name,                  -- title
	        p_package_id             -- package_id
	);

	insert into newsletters
	   (newsletter_id, name, description, layout) 
	values
	   (v_newsletter_id, p_name, p_description, p_layout);

	return v_newsletter_id;
end;
' language 'plpgsql';



create or replace function newsletters__edit (
    integer, -- newsletter_id
    varchar, -- name
    varchar, -- description
    varchar  -- layout
)
returns integer as '
declare
    p_newsletter_id         alias for $1;
    p_name                  alias for $2;
    p_description           alias for $3;
    p_layout                alias for $4;
begin


	update newsletters
	set 	name = p_name,
		description = p_description,
		layout = p_layout
	where newsletter_id = p_newsletter_id;

	return 0;
end;
' language 'plpgsql';

