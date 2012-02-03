-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.19d-0.20d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.19d-0.20d.sql','');


CREATE OR REPLACE FUNCTION cn_resource__edit (
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
