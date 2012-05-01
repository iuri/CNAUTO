-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.24d-0.25d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.24d-0.25d.sql', '');




ALTER TABLE cn_resources ADD COLUMN code_unum varchar(255);
ALTER TABLE cn_resources ADD COLUMN fabricant varchar(255);
ALTER TABLE cn_resources ADD COLUMN lcvm varchar(255);
ALTER TABLE cn_resources ADD COLUMN model varchar(255);
ALTER TABLE cn_resources ADD COLUMN version varchar(255);
ALTER TABLE cn_resources ADD COLUMN code varchar(255) CONSTRAINT cn_resources_code_un UNIQUE;



DROP FUNCTION cn_resource__new(
       varchar,	-- code_unum
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
);


CREATE OR REPLACE FUNCTION cn_resource__new(
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
) RETURNS integer AS '
  DECLARE
	p_code_unum	ALIAS FOR $1;
	p_name		ALIAS FOR $2;
	p_pretty_name	ALIAS FOR $3;
	p_description	ALIAS FOR $4;
	p_class_id	ALIAS FOR $5;
	p_ncm_class	ALIAS FOR $6;
	p_unit		ALIAS FOR $7;
	p_code		ALIAS FOR $8;
	p_fabricant	ALIAS FOR $9;
	p_lcvm		ALIAS FOR $10;
	p_model		ALIAS FOR $11;
	p_version	ALIAS FOR $12;
	p_creation_ip 	ALIAS FOR $13;
	p_creation_user ALIAS FOR $14;
	p_context_id	ALIAS FOR $15;

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
	       code_unum,
	       name,
	       pretty_name,
	       description,
	       class_id,
	       ncm_class,
	       unit,
	       code,	
	       fabricant,
	       lcvm,
	       model,
	       version
	) VALUES (
	       v_id,
	       p_code_unum,
	       p_name,
	       p_pretty_name,
	       p_description,
	       p_class_id,
	       p_ncm_class,
	       p_unit,
	       p_code,	
	       p_fabricant,
	       p_lcvm,
	       p_model,
	       p_version
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



DROP FUNCTION cn_resource__edit (
       integer, -- resource_id
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar	-- unit
);


CREATE OR REPLACE FUNCTION cn_resource__edit (
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
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_code_unum	ALIAS FOR $2;
	p_name		ALIAS FOR $3;
	p_pretty_name	ALIAS FOR $4;
	p_description	ALIAS FOR $5;
	p_class_id	ALIAS FOR $6;
	p_ncm_class	ALIAS FOR $7;
	p_unit		ALIAS FOR $8;
	p_code		ALIAS FOR $9;
	p_fabricant	ALIAS FOR $10;
	p_lcvm		ALIAS FOR $11;
	p_model		ALIAS FOR $12;
	p_version	ALIAS FOR $13;

  BEGIN
  
  	UPDATE cn_resources SET 
	       code_unum = p_code_unum,
	       name = p_name,
	       pretty_name = p_pretty_name,
	       description = p_description,
	       class_id = p_class_id,
	       ncm_class = p_ncm_class,
	       unit = p_unit,
	       code = p_code,	
	       fabricant = p_fabricant,
	       lcvm = p_lcvm,
	       model = p_model,
	       version = p_version
	WHERE resource_id = p_resource_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';
