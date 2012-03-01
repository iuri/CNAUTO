-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.5d-0.6d.sql','');

ALTER TABLE cn_spreadsheet_elements ADD COLUMN element_id integer;

CREATE OR REPLACE FUNCTION inline_0 () 
RETURNS integer AS '
  DECLARE
	row	record;
	v_id	integer;
	
  BEGIN

    FOR row IN
    	SELECT element FROM cn_spreadsheet_elements
    LOOP

	SELECT INTO v_id NEXTVAL(''cn_spreadsheet_element_id_seq'');

	UPDATE cn_spreadhseet_elements SET element_id = v_id WHERE element = row.element;

    END LOOP;

    RETURN 0;

  END;' LANGUAGE 'plpgsql';

SELECT inline_0 ();
DROP FUNCTION inline_0 ();

ALTER TABLE cn_spreadsheet_elements ADD CONSTRAINT cn_spreadsheet_elements_element_id_pk PRIMARY KEY (element_id);


CREATE OR REPLACE FUNCTION cn_spreadsheet_element__new (
    integer, -- spreadsheet_id
    varchar, -- name
    varchar  -- element
) RETURNS varchar AS '
  DECLARE
    p_spreadsheet_id	alias for $1;
    p_name              alias for $2;
    p_element           alias for $3;

    v_id		integer;
  BEGIN
  
	SELECT INTO v_id NEXTVAL(''cn_spreadsheet_element_id_seq'');
	

	INSERT INTO cn_spreadsheet_elements
	   (element_id, name, spreadsheet_id, element) 
	VALUES
	   (v_id, p_name, p_spreadsheet_id, p_element);


	RETURN p_element;
END;' language 'plpgsql';