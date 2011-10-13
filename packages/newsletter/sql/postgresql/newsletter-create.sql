--
-- The News Letter Package
--
-- @author Alessandro Landim (alessandro.landim@gmail.com)
-- @creation-date 2010-03-09
--
-- create the object types

select acs_object_type__create_type (
    'newsletter',           -- object_type
    'NewsLetter',          -- pretty_name
    'NewsLetters',         -- pretty_plural
    'acs_object',           -- supertype
    'newsletters',          -- table_name
    'newsletter_id',        -- id_column
    'newsletters.name',      -- name_method
    'f',
    null,
    null
);

select acs_object_type__create_type (
    'newsletter_field',     -- object_type
    'NewsLetter Field',     -- pretty_name
    'NewsLetter Fields',    -- pretty_plural
    'acs_object',            -- supertype
    'newsletters_fields',    -- table_name
    'field_id', 	             -- id_column
    'newsletters_fields.name', -- name_method
    'f',
    null,
    null
);

select acs_object_type__create_type (
    'newsletter_item',      -- object_type
    'NewsLetter Item',     -- pretty_name
    'NewsLetter Items',    -- pretty_plural
    'acs_object',           -- supertype
    'newsletters_items',   -- table_name
    'newsletter_item_id', 	    -- id_column
    'newsletter_item.name', -- name_method
    'f',
    null,
    null
);


create table newsletters (
	   newsletter_id      integer primary key
                              constraint newsletter_id_fk 
                              references acs_objects on delete cascade,
	   name               varchar NOT NULL,
	   description        text
);


create table newsletters_fields (
           field_id		integer primary key
                                constraint newsletters_fields_field_id_fk 
                                references acs_objects on delete cascade,
	   newsletter_id	integer NOT NULL
                                constraint newsletters_fields_newsletter_id_fk
				references newsletters on delete cascade,
	   name		        varchar NOT NULL
);

create table newsletters_emails (
           email		varchar NOT NULL,
	   newsletter_id	integer NOT NULL
                                constraint newsletters_emails_newsletter_id_fk
				references newsletters on delete cascade,
	   name		        varchar,
	   valid		boolean NOT NULL default true,
	   constraint newsletters_emails_un
	   unique (email, newsletter_id)
);

create table newsletters_data (
           email		varchar NOT NULL,
	   field_id		integer NOT NULL 
                                constraint newsletters_data_field_id_fk
				references newsletters_fields on delete cascade,
	   data		        varchar,
	   constraint newsletters_data_un
	   unique (field_id, email)
);

create table newsletters_items (
           newsletter_item_id	integer primary key
                                constraint newsletters_fields_field_id_fk 
                                references acs_objects on delete cascade,
	   newsletter_id	integer NOT NULL
                                constraint newsletters_emails_newsletter_id_fk
				references newsletters on delete cascade,
	   title	        varchar NOT NULL,
	   content 		text,
	   item_number 		integer,
	   email_list 		varchar,
	   constraint newsletters_items_un
	   unique (newsletter_id, item_number)
);





create or replace function newsletters__new (
    integer, -- newsletter_id
    varchar, -- name
    varchar, -- description
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
    p_package_id            alias for $4;
    p_creation_date         alias for $5;
    p_creation_user         alias for $6;
    p_creation_ip           alias for $7;
    p_context_id            alias for $8;
  
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
	   (newsletter_id, name, description) 
	values
	   (v_newsletter_id, p_name, p_description);

	return v_newsletter_id;
end;
' language 'plpgsql';



create or replace function newsletters__del (
    integer -- newsletter_id
)
returns integer as '
declare
    p_newsletter_id         alias for $1;
begin

    perform acs_object__delete(p_newsletter_id);

    return 0;
end;
' language 'plpgsql';


create or replace function newsletters__edit (
    integer, -- newsletter_id
    varchar, -- name
    varchar -- description
)
returns integer as '
declare
    p_newsletter_id         alias for $1;
    p_name                  alias for $2;
    p_description           alias for $3;
begin


	update newsletters
	set 	name = p_name,
		description = p_description
	where newsletter_id = p_newsletter_id;

	return 0;
end;
' language 'plpgsql';



create or replace function newsletters_fields__new (
    integer, -- field_id
    integer, -- newsletter_id
    varchar, -- name
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_field_id         	    alias for $1;
    p_newsletter_id         alias for $2;
    p_name                  alias for $3;
    p_package_id            alias for $4;
    p_creation_date         alias for $5;
    p_creation_user         alias for $6;
    p_creation_ip           alias for $7;
    p_context_id            alias for $8;
  
    v_field_id               integer;
begin

	v_field_id := acs_object__new (
		p_field_id,		 -- object_id
		''newsletter_field'',    -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	        p_name,                  -- title
	        p_package_id             -- package_id
	);

	insert into newsletters_fields
	   (field_id, newsletter_id, name) 
	values
	   (v_field_id, p_newsletter_id, p_name);

	return v_field_id;
end;
' language 'plpgsql';

create or replace function newsletters_fields__edit (
    integer, -- field_id
    varchar, -- name
    integer, -- sort_order
    boolean  -- ignore
)
returns integer as '
declare
    p_field_id         alias for $1;
    p_name             alias for $2;
    p_sort_order       alias for $3;
    p_ignore           alias for $4;
begin


    update newsletters_fields
    set     name = p_name,
            sort_order = p_sort_order,
            ignore     = p_ignore
    where field_id = p_field_id;

    return 0;
end;
' language 'plpgsql';


create or replace function newsletters_fields__del (
    integer -- field_id
)
returns integer as '
declare
    p_field_id         alias for $1;
begin

    perform acs_object__delete(p_field_id);
    return 0;
end;
' language 'plpgsql';

create or replace function newsletters_data__del (
    integer -- newsletter_id
)
returns integer as '
declare
    p_newsletter_id         alias for $1;
begin

    delete from newsletters_data where field_id in (select field_id from newsletters_fields where newsletter_id = p_newsletter_id);
    delete from newsletters_emails where newsletter_id = p_newsletter_id;
    return 0;
end;
' language 'plpgsql';

create or replace function newsletters_email__new (
    integer, -- newsletter_id
    varchar, -- name
    varchar  -- email
)
returns integer as '
declare
    p_newsletter_id        alias for $1;
    p_name                 alias for $2;
    p_email                alias for $3;
begin

	insert into newsletters_emails
	   (name, newsletter_id, email) 
	values
	   (p_name, p_newsletter_id, p_email);

	return p_newsletter_id;
end;
' language 'plpgsql';

create or replace function newsletters_data__new (
    integer, -- field_id
    varchar, -- email
    varchar  -- data
)
returns integer as '
declare
    p_field_id        	   alias for $1;
    p_email                alias for $2;
    p_data                 alias for $3;
begin

	insert into newsletters_data
	   (data, field_id, email) 
	values
	   (p_data, p_field_id, p_email);

	return 0;
end;
' language 'plpgsql';

create or replace function newsletters_items__new (
    integer, -- newsletter_item_id
    integer, -- newsletter_id
    varchar, -- title
    varchar, -- content
    integer, -- item_number 
    varchar, -- email_list
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
)
returns integer as '
declare
    p_newsletter_item_id    alias for $1;
    p_newsletter_id         alias for $2;
    p_title                 alias for $3;
    p_content		    alias for $4;
    p_item_number           alias for $5;
    p_email_list            alias for $6;
    p_package_id            alias for $7;
    p_creation_date         alias for $8;
    p_creation_user         alias for $9;
    p_creation_ip           alias for $10;
    p_context_id            alias for $11;
  
    v_newsletter_item_id    integer;
begin

	v_newsletter_item_id := acs_object__new (
		p_newsletter_item_id,	 -- object_id
		''newsletter_item'',     -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	        p_title,                  -- title
	        p_package_id             -- package_id
	);

	insert into newsletters_items
	   (newsletter_item_id, newsletter_id, content, title, item_number, email_list) 
	values
	   (v_newsletter_item_id, p_newsletter_id, p_content, p_title, p_item_number, p_email_list);

	return v_newsletter_item_id;
end;
' language 'plpgsql';

create or replace function newsletters_items__del (
    integer -- newsletter_item_id
)
returns integer as '
declare
    p_newsletter_item_id         alias for $1;
begin

    perform acs_object__delete(p_newsletter_item_id);

    return 0;
end;
' language 'plpgsql';


