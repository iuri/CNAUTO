-- /packages/cnauto-core/sql/postgresql/cnauto-core-drop.sql

--
-- The CN Auto Core Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-26
--




------------------------------------
-- Table cn_categories
------------------------------------
DROP TABLE cn_categories;

DROP FUNCTION cn_category__new (
       integer,	  -- category_id
       integer,	  -- package_id
       integer,	  -- parent_id
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
);


DROP FUNCTION cn_category__edit (
       integer,	  -- category_id
       integer,	  -- package_id
       integer,	  -- parent_id
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
);


DROP FUNCTION cn_category__delete (
       integer	  -- category_id
);



------------------------------------
-- Table cn_colors
------------------------------------
DROP TABLE cn_colors;



DROP SEQUENCE cn_core_file_number_seq;
