-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.17d-0.18d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.17d-0.18d.sql','');

DROP FUNCTION cn_resource__new(
       integer,	-- resource_id 
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       varchar,	-- class
       varchar,	-- ncm_class
       varchar	-- unit
) 


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


