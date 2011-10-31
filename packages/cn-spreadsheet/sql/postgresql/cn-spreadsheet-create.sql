--
-- The CN SpreadSheet Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-09-18
--


------------------------------------
-- CN SpreadSheets
------------------------------------

SELECT acs_object_type__create_type (
    'cn_spreadsheet',		    -- object_type
    'CN SpreadSheets',              -- pretty_name
    'CN SpreadSheets',         	    -- pretty_plural
    'acs_object',           	    -- supertype
    'cn_spreadsheets',              -- table_name
    'spreadsheet_id',        	    -- id_column
    'spreadhseet.name',      	    -- name_method
    'f',
    null,
    null
);

CREATE TABLE cn_spreadsheets (
	   spreadsheet_id     integer primary key
                              constraint cn_spreadsheets_spreadsheet_id_fk 
                              references acs_objects on delete cascade,
	   name               varchar NOT NULL,
	   description        text
);



CREATE OR REPLACE FUNCTION cn_spreadsheet__new (
    integer, -- spreadsheet_id
    varchar, -- name
    varchar, -- description
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id        alias for $1;
    p_name                  alias for $2;
    p_description           alias for $3;
    p_package_id            alias for $4;
    p_creation_date         alias for $5;
    p_creation_user         alias for $6;
    p_creation_ip           alias for $7;
    p_context_id            alias for $8;
  
    v_spreadsheet_id               integer;
BEGIN

	v_spreadsheet_id := acs_object__new (
		p_spreadsheet_id,	 -- object_id
		''cn_spreadsheet'',      -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	        p_name,                  -- title
	        p_package_id             -- package_id
	);

	INSERT INTO cn_spreadsheets
	   (spreadsheet_id, name, description) 
	VALUES
	   (v_spreadsheet_id, p_name, p_description);

	RETURN v_spreadsheet_id;
END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_spreadsheet__del (
    integer -- spreadsheet_id
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id         ALIAS FOR $1;
BEGIN

    perform acs_object__delete(p_spreadsheet_id);

    RETURN 0;
END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_spreadsheet__edit (
    integer, -- spreadsheet_id
    varchar, -- name
    varchar -- description
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id        alias for $1;
    p_name                  alias for $2;
    p_description           alias for $3;
BEGIN

	UPDATE cn_spreadsheets
	SET 	name = p_name,
		description = p_description
	WHERE spreadsheet_id = p_spreadsheet_id;

	RETURN 0;
END;' language 'plpgsql';






------------------------------------
-- CN SpreadSheet Fields
------------------------------------

SELECT acs_object_type__create_type (
    'cn_spreadsheet_field',	    -- object_type
    'CN SpreadSheet Field',    	    -- pretty_name
    'CN SpreadSheet Fields',   	    -- pretty_plural
    'acs_object',            	    -- supertype
    'cn_spreadsheet_fields',   	    -- table_name
    'field_id',              	    -- id_column
    'spreadsheet_fields.name', 	    -- name_method
    'f',
    null,
    null
);




CREATE TABLE cn_spreadsheet_fields (
           field_id		integer primary key
                                constraint cn_spreadsheet_fields_field_id_fk 
                                references acs_objects on delete cascade,
	   spreadsheet_id	integer NOT NULL
                                constraint cn_spreadsheet_fields_spreadsheet_id_fk
				references cn_spreadsheets on delete cascade,
	   name			varchar(40) NOT NULL,
	   label		varchar(40),
	   sort_order		integer,
	   required_p		boolean,
);



CREATE OR REPLACE FUNCTION cn_spreadsheet_fields__new (
    integer, -- spreadsheet_id, context_id
    varchar, -- name
    varchar, -- label
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar  -- creation_ip
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id        alias for $1;
    p_name                  alias for $2;
    p_label                 alias for $3;
    p_package_id            alias for $4;
    p_creation_date         alias for $5;
    p_creation_user         alias for $6;
    p_creation_ip           alias for $7;
  
    v_field_id               integer;
BEGIN

	v_field_id := acs_object__new (
		null,			 -- object_id
		''cn_spreadsheet_field'',-- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_spreadsheet_id,        -- context_id
	        p_name,                  -- title
	        p_package_id             -- package_id
	);

	insert into cn_spreadsheet_fields
	   (field_id, spreadsheet_id, name, label) 
	values
	   (v_field_id, p_spreadsheet_id, p_name, p_label);

	return v_field_id;
END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_spreadsheet_fields__edit (
    integer, -- field_id
    varchar, -- name
    varchar, -- label
    integer, -- sort_order
    boolean  -- required_p
) RETURNS integer AS '
DECLARE
    p_field_id         alias for $1;
    p_name             alias for $2;
    p_label            alias for $3;
    p_sort_order       alias for $4;
    p_required_p       alias for $5;
BEGIN

    UPDATE cn_spreadsheet_fields
    SET     name = p_name,
    	    label = p_label,
            sort_order = p_sort_order,
            required_p = p_required_p
    WHERE field_id = p_field_id;

    RETURN 0;

END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_spreadsheet_fields__del (
    integer -- field_id
) RETURNS integer AS '
DECLARE
    p_field_id         alias for $1;
BEGIN

    PERFORM acs_object__delete(p_field_id);
    
    RETURN 0;
END;' language 'plpgsql';




------------------------------------
-- CN SpreadSheet Items
------------------------------------

SELECT acs_object_type__create_type (
    'cn_spreadsheet_item',	    -- object_type
    'CN SpreadSheet Item',     	    -- pretty_name
    'CN Spreadsheet Items',    	    -- pretty_plural
    'acs_object',           	    -- supertype
    'cn_spreadsheet_items',  	    -- table_name
    'item_id', 	    		    -- id_column
    'spreadsheet_item.name',	    -- name_method
    'f',
    null,
    null
);


CREATE TABLE cn_spreadsheet_items (
       	   item_id		integer primary key
                                constraint spreadsheet_item_id_fk 
                                references acs_objects on delete cascade,
       	   spreadsheet_id	integer NOT NULL
                                constraint spreadsheet_items_spreadsheet_id_fk
				references cn_spreadsheets on delete cascade,
	   title	        varchar NOT NULL,
	   content 		text,
	   item_number 		integer,
	   element_list 		varchar,
	   constraint cn_spreadsheet_items_un
	   unique (spreadsheet_id, item_number)
);



CREATE OR REPLACE FUNCTION cn_spreadsheet_items__new (
    integer, -- item_id
    integer, -- spreadsheet_id
    varchar, -- title
    varchar, -- content
    integer, -- item_number 
    varchar, -- email_list
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
    integer  -- context_id
) RETURNS integer AS '
DECLARE
    p_item_id		alias for $1;
    p_spreadsheet_id    alias for $2;
    p_title             alias for $3;
    p_content		alias for $4;
    p_item_number       alias for $5;
    p_email_list        alias for $6;
    p_package_id        alias for $7;
    p_creation_date     alias for $8;
    p_creation_user     alias for $9;
    p_creation_ip       alias for $10;
    p_context_id        alias for $11;
  
    v_item_id    integer;
BEGIN

	v_item_id := acs_object__new (
		p_item_id,    	 	 -- object_id
		''cn_spreadsheet_item'', -- object_type
		p_creation_date,         -- creation_date
		p_creation_user,         -- creation_user
		p_creation_ip,           -- creation_ip
		p_context_id,            -- context_id
	        p_title,                  -- title
	        p_package_id             -- package_id
	);

	INSERT INTO cn_spreadsheet_items
	   (item_id, spreadsheet_id, content, title, item_number, email_list) 
	VALUES
	   (v_item_id, p_spreadsheet_id, p_content, p_title, p_item_number, p_email_list);

	RETURN v_item_id;
END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_spreadsheet_items__del (
    integer -- item_id
) RETURNS integer AS '
DECLARE
    p_item_id         alias for $1;
BEGIN

    PERFORM acs_object__delete(p_item_id);

    RETURN 0;
END;' language 'plpgsql';




------------------------------------
-- CN SpreadSheet Elements
------------------------------------


CREATE TABLE cn_spreadsheet_elements (
           element	        varchar NOT NULL,
	   spreadsheet_id	integer NOT NULL
                                constraint spreadsheet_elements_spreadsheet_id_fk
				references cn_spreadsheets on delete cascade,
	   name		        varchar,
	   valid		boolean NOT NULL default true,
	   constraint cn_spreadsheet_elements_un
	   unique (element, spreadsheet_id)
);



CREATE OR REPLACE FUNCTION cn_spreadsheet_element__new (
    integer, -- spreadsheet_id
    varchar, -- name
    varchar  -- element
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id      alias for $1;
    p_name                 alias for $2;
    p_element              alias for $3;
BEGIN

	INSERT INTO cn_spreadsheet_elements
	   (name, spreadsheet_id, element) 
	VALUES
	   (p_name, p_spreadsheet_id, p_element);


	RETURN p_element;
END;' language 'plpgsql';



------------------------------------
-- CN SpreadSheet Data
------------------------------------

CREATE TABLE cn_spreadsheet_data (
           element		varchar NOT NULL,
	   field_id		integer NOT NULL 
                                constraint cn_spreadsheet_data_field_id_fk
				references cn_spreadsheet_fields on delete cascade,
	   data		        varchar,
	   constraint cn_spreadsheet_data_un
	   unique (field_id, element)
);




CREATE OR REPLACE FUNCTION cn_spreadsheet_data__new (
    integer, -- field_id
    varchar, -- element
    varchar  -- data
) RETURNS integer AS '
DECLARE
    p_field_id        	   alias for $1;
    p_element              alias for $2;
    p_data                 alias for $3;
BEGIN

	insert into cn_spreadsheet_data
	   (data, field_id, element) 
	values
	   (p_data, p_field_id, p_element);

	RETURN 0;
END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_spreadsheet_data__del (
    integer -- spreadsheet_id
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id         alias for $1;
BEGIN

    DELETE FROM cn_spreadsheet_data WHERE field_id in (SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = p_spreadsheet_id);
    DELETE FROM cn_spreadsheet_elements WHERE spreadsheet_id = p_spreadsheet_id;

    RETURN 0;
END;' language 'plpgsql';



