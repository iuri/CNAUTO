-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql','');


ALTER TABLE cn_spreadsheet_fields ADD COLUMN label varchar(40);


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
    boolean  -- ignore
) RETURNS integer AS '
DECLARE
    p_field_id         alias for $1;
    p_name             alias for $2;
    p_label            alias for $3;
    p_sort_order       alias for $4;
    p_ignore           alias for $5;
BEGIN

    UPDATE cn_spreadsheet_fields
    SET     name = p_name,
    	    label = p_label,
            sort_order = p_sort_order,
            ignore     = p_ignore
    WHERE field_id = p_field_id;

    RETURN 0;

END;' language 'plpgsql';

