-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.25d-0.26d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.25d-0.26d.sql', '');




ALTER TABLE cn_resources DROP COLUMN fabricant;
ALTER TABLE cn_resources DROP COLUMN lcvm;;
ALTER TABLE cn_resources DROP COLUMN model;
ALTER TABLE cn_resources DROP COLUMN version;
ALTER TABLE cn_resources DROP COLUMN code;
ALTER TABLE cn_resources RENAME COLUMN code_unum TO code;



CREATE FUNCTION cn_resource__new(
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
) RETURNS integer AS '
  DECLARE
	p_code		ALIAS FOR $1;
	p_name		ALIAS FOR $2;
	p_pretty_name	ALIAS FOR $3;
	p_description	ALIAS FOR $4;
	p_class_id	ALIAS FOR $5;
	p_ncm_class	ALIAS FOR $6;
	p_unit		ALIAS FOR $7;
	p_creation_ip 	ALIAS FOR $8;
	p_creation_user ALIAS FOR $9;
	p_context_id	ALIAS FOR $10;

	v_id		integer;

  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_resource'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );

	INSERT INTO cn_resources (
	       resource_id,
	       code,
	       name,
	       pretty_name,
	       description,
	       class_id,
	       ncm_class,
	       unit
	) VALUES (
	       v_id,
	       p_code,
	       p_name,
	       p_pretty_name,
	       p_description,
	       p_class_id,
	       p_ncm_class,
	       p_unit
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';




DROP FUNCTION cn_resource__new(
       varchar,	-- code_unum
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar, -- version
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
);


CREATE FUNCTION cn_resource__edit (
       integer, -- resource_id
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar	-- unit
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_name		ALIAS FOR $3;
	p_pretty_name	ALIAS FOR $4;
	p_description	ALIAS FOR $5;
	p_class_id	ALIAS FOR $6;
	p_ncm_class	ALIAS FOR $7;
	p_unit		ALIAS FOR $8;

  BEGIN
  
  	UPDATE cn_resources SET 
	       code = p_code,
	       name = p_name,
	       pretty_name = p_pretty_name,
	       description = p_description,
	       class_id = p_class_id,
	       ncm_class = p_ncm_class,
	       unit = p_unit
	WHERE resource_id = p_resource_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



DROP FUNCTION cn_resource__edit (
       integer, -- resource_id
       varchar,	-- code_unum
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar  -- version
);



CREATE TABLE cn_renavam (
       renavam_id	integer PRIMARY KEY,
       resource_id	integer
       			CONSTRAINT cn_renavam_resource_id_fk
			REFERENCES cn_resources (resource_id),
       code		varchar(255)
    			CONSTRAINT cn_renavam_code_un UNIQUE,  
       fabricant 	varchar(255),
       lcvm		varchar(255),
       model		varchar(255),
       version		varchar(255)
);


DROP FUNCTION cn_renavam__new (
       integer, -- renavam_id
       integer, -- resource_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
);



CREATE OR REPLACE FUNCTION cn_renavam__new (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
) RETURNS integer AS '
  DECLARE
	p_renavam_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_fabricant	ALIAS FOR $3;
	p_lcvm		ALIAS FOR $4;
	p_model		ALIAS FOR $5;
	p_version	ALIAS FOR $6;

  BEGIN
  
	INSERT INTO cn_renavam (
	       	renavam_id,
		code,
		fabricant,
		lcvm,
		model,
		version
	) VALUES (
	  	 p_renavam_id,
		 p_code,
		 p_fabricant,
		 p_lcvm,
		 p_model,
		 p_version
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_renavam__edit (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
) RETURNS integer AS '
  DECLARE
	p_renavam_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_fabricant	ALIAS FOR $3;
	p_lcvm		ALIAS FOR $4;
	p_model		ALIAS FOR $5;
	p_version	ALIAS FOR $6;

  BEGIN
  
	UPDATE cn_renavam SET 
		code = p_code,
		fabricant = p_fabricant,
		lcvm = p_lcvm,
		model = p_model,
		version = p_version
	WHERE renavam_id = p_renavam_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION cn_renavam__delete (
       integer -- renavam_id
) RETURNS integer AS '
  DECLARE 
  	  p_renavam_id	ALIAS FOR $1;  
  
  BEGIN
	DELETE FROM cn_renavam WHERE renavam_id = p_renavam_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';

ALTER TABLE cn_vehicles DROP CONSTRAINT cn_vehicles_model_id_fk;
ALTER TABLE cn_vehicles DROP COLUMN model_id;
