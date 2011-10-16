ALTER TABLE newsletters_fields ADD COLUMN sort_order integer;
ALTER TABLE newsletters_fields ADD COLUMN ignore boolean default false;
DROP FUNCTION newsletters__fields__edit(integer, character varying);

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



