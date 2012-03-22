-- /packages/cnauto-core/sql/postgresql/upgrade/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-core/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql','');


ALTER TABLE cn_categories ADD COLUMN code varchar(50);


CREATE OR REPLACE FUNCTION cn_category__new (
       integer,	  -- category_id
       integer,	  -- package_id
       integer,	  -- parent_id
       varchar,	  -- code
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
) RETURNS integer AS '
  DECLARE 
  	  p_category_id		ALIAS FOR $1;
	  p_package_id		ALIAS FOR $2;
	  p_parent_id		ALIAS FOR $3;
	  p_code		ALIAS FOR $4;
	  p_name		ALIAS FOR $5;
	  p_pretty_name		ALIAS FOR $6;
	  p_object_type		ALIAS FOR $7;
  BEGIN

	INSERT INTO cn_categories (
	       category_id,
	       package_id,
	       parent_id,
	       code,	       
	       name,
	       pretty_name,
	       object_type
	) VALUES (
	       p_category_id,
	       p_package_id,
	       p_parent_id,
	       p_code,
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
       varchar,	  -- code
       varchar,	  -- name
       varchar,	  -- pretty_name
       varchar	  -- object_type
) RETURNS integer AS '
  DECLARE 
  	  p_category_id		ALIAS FOR $1;
	  p_package_id		ALIAS FOR $2;
	  p_parent_id		ALIAS FOR $3;
	  p_code		ALIAS FOR $4;
	  p_name		ALIAS FOR $5;
	  p_pretty_name		ALIAS FOR $6;
	  p_object_type		ALIAS FOR $7;
  BEGIN

	UPDATE cn_categories SET 
	       package_id = p_package_id,
	       parent_id = p_parent_id,
	       code = p_code,
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
