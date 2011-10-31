-- /packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql


SELECT acs_log__debug ('/packages/cn-spreadsheet/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql','');

ALTER TABLE cn_spreadsheet_fields ADD COLUMN sort_order integer;
ALTER TABLE cn_spreadsheet_fields ADD COLUMN required_p boolean;

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
