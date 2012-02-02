-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.13d-0.14d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.13d-0.14d.sql','');


SELECT acs_object_type__create_type (
    'cn_resource',         -- object_type
    'CN Resource',         -- pretty_name
    'CN Resources',    	   -- pretty_plural
    'acs_object',     	   -- supertype
    'cn_resources',        -- table_name
    'resource_id',     	   -- id_column
    null,		   -- name_method
    'f',
    null,
    null
);
