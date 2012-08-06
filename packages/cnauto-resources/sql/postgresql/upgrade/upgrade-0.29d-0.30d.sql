-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.29d-0.30d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.29d-0.30d.sql', '');




------------------------------------
-- Table cn_assets
------------------------------------

ALTER TABLE cn_assets DROP COLUMN quantity;

      


DROP  FUNCTION cn_asset__new(
       integer, -- resource_id
       varchar,	-- asset_code
       varchar,	-- serial_number
       varchar,	-- location
       integer,	-- quantity
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
);

CREATE OR REPLACE FUNCTION cn_asset__new(
       integer, -- resource_id
       varchar,	-- asset_code
       varchar,	-- serial_number
       varchar,	-- location
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_asset_code	ALIAS FOR $2;
	p_serial_number	ALIAS FOR $3;
	p_location	ALIAS FOR $4;
	p_creation_ip 	ALIAS FOR $5;
	p_creation_user ALIAS FOR $6;
	p_context_id	ALIAS FOR $7;

	v_id		integer;

  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_asset'',		-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );

	INSERT INTO cn_assets (
	       asset_id,
	       resource_id,
	       asset_code,
	       serial_number,
	       location
	 ) VALUES (
	       v_id,
	       p_resource_id,
	       p_asset_code,
	       p_serial_number,
	       p_location
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';