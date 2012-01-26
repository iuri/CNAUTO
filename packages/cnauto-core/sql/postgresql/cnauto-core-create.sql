-- /packages/cnauto-assurance/sql/postgresql/cnauto-core-create.sql

--
-- The CN Auto Core Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-26
--




------------------------------------
-- Table cn_colors
------------------------------------
CREATE TABLE cn_categories (
       category_id     integer
       		       CONSTRAINT cn_categories_category_id_pk PRIMARY KEY, 
       package_id      integer,
       name	       varchar(50),
       pretty_name     varchar(50),
       object_type     varchar(20)
       		       CONSTRAINT cn_categories_object_type_fk
		       REFERENCES acs_object_types(object_type)
);

