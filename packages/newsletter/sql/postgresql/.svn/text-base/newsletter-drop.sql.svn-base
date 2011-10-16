--
-- The News Letter Package
--
-- @author Alessandro Landim (alessandro.landim@gmail.com)
-- @creation-date 2010-03-09
--
-- drop the object types



create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__drop_type (
        ''newsletter'', ''f''
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();

create function inline_0 ()
returns integer as '
begin
    perform acs_object_type__drop_type (
        ''newsletter_field'', ''f''
    );

    return null;
end;' language 'plpgsql';

select inline_0();
drop function inline_0 ();

drop table newsletters_data;
drop table newsletters_fields;
drop table newsletters_emails;
drop table newsletters;

