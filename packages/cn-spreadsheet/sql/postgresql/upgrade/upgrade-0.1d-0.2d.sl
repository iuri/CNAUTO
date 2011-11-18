-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql','');


CREATE OR REPLACE FUNCTION cn_spreadsheet_fields__new (
    integer, -- spreadsheet_id, context_id
    varchar, -- name
    integer, -- package_id
    timestamp with time zone, -- creation_date
    integer, -- creation_user
    varchar, -- creation_ip
) RETURNS integer AS '
DECLARE
    p_spreadsheet_id        alias for $1;
    p_name                  alias for $2;
    p_package_id            alias for $3;
    p_creation_date         alias for $4;
    p_creation_user         alias for $5;
    p_creation_ip           alias for $6;
  
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
	   (field_id, spreadsheet_id, name) 
	values
	   (v_field_id, p_spreadsheet_id, p_name);

	return v_field_id;
END;' language 'plpgsql';
