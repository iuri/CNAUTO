-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.9d-0.10d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.9d-0.10d.sql', '');


-- Create a file object to storage assurance files using content repository
SELECT content_type__create_type (
       'assurance_file_object',	 -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'Assurance File Object',  -- pretty_name
       'Assurance File Objects', -- pretty_plural
       NULL,        -- table_name
       -- DAVEB: acs_object_types supports a null table name so we do that
       -- instead of passing a false value so we can actually use the
       -- content repository instead of duplicating all the code in file-storage
       NULL,	         -- id_column
       'assurance_file__get_title' -- name_method
);
