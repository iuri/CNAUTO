-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql','');

DROP FUNCTION cn_spreadsheet_elements__new(integer, varchar, varchar);

CREATE OR REPLACE FUNCTION cn_spreadsheet_element__new (
    integer, -- _spreadsheet_id
    varchar, -- name
    varchar  -- email
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


	RETURN p_spreadsheet_id;
END;' language 'plpgsql';

