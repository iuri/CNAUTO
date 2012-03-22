-- /packages/cnauto-core/sql/postgresql/cnauto-core-create.sql

--
-- The CN Auto Core Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-26
--




------------------------------------
-- Table cn_categories
------------------------------------

CREATE TABLE cn_categories (
       category_id     integer
       		       CONSTRAINT cn_categories_category_id_pk PRIMARY KEY, 
       package_id      integer
       		       CONSTRAINT cn_categories_package_id_fk
		       REFERENCES apm_packages (package_id),
       parent_id       integer
       		       CONSTRAINT cn_categories_parent_id_fk
		       REFERENCES cn_categories (category_id),
       code	       varchar(50),
       name	       varchar(255),
       pretty_name     varchar(255),
       object_type     varchar(20)
       		       CONSTRAINT cn_categories_object_type_fk
		       REFERENCES acs_object_types(object_type)
);

CREATE OR REPLACE FUNCTION cn_category__new (
       integer,	  -- category_id
       integer,	  -- package_id
       integer,	  -- parent_id
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
) RETURNS integer AS '
  DECLARE 
  	  p_category_id		ALIAS FOR $1;
	  p_package_id		ALIAS FOR $2;
	  p_parent_id		ALIAS FOR $3;
	  p_name		ALIAS FOR $4;
	  p_pretty_name		ALIAS FOR $5;
	  p_object_type		ALIAS FOR $6;
  BEGIN

	INSERT INTO cn_categories (
	       category_id,
	       package_id,
	       parent_id,
	       name,
	       pretty_name,
	       object_type
	) VALUES (
	       p_category_id,
	       p_package_id,
	       p_parent_id,
	       p_name,
	       p_pretty_name,
	       p_object_type
        );

	RETURN 0;

  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_category__edit (
       integer,	  -- category_id
       integer,	  -- package_id
       integer,	  -- parent_id
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
) RETURNS integer AS '
  DECLARE 
  	  p_category_id		ALIAS FOR $1;
	  p_package_id		ALIAS FOR $2;
	  p_parent_id		ALIAS FOR $3;
	  p_name		ALIAS FOR $4;
	  p_pretty_name		ALIAS FOR $5;
	  p_object_type		ALIAS FOR $6;
  BEGIN

	UPDATE cn_categories SET 
	       package_id = p_package_id,
	       parent_id = p_parent_id,
	       name = p_name,
	       pretty_name = p_prety_name,
	       object_type = p_object_type
	WHERE category_id = p_category_id;

	RETURN 0;

  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_category__delete (
       integer	  -- category_id
) RETURNS integer AS '
  DECLARE 
  	  p_category_id		ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_categories WHERE category_id = p_category_id;

	RETURN 0;

  END;' language 'plpgsql';



------------------------------------
-- Table cn_colors
------------------------------------
CREATE TABLE cn_colors (
       code      varchar(10)
       		 CONSTRAINT cn_colors_code_pk  PRIMARY KEY,       
       name	 varchar(255)
       		 CONSTRAINT cn_colors_name_nn NOT NULL
       		 CONSTRAINT cn_colors_name_un UNIQUE,
       pretty_name varchar(255)
);





CREATE SEQUENCE cn_core_file_number_seq cache 1000;
