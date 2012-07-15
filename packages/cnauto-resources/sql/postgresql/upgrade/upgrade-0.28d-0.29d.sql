-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.28d-0.29d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.28d-0.29d.sql', '');




------------------------------------
-- Table cn_assets
------------------------------------

CREATE TABLE cn_assets (
       asset_id	       integer
       		       CONSTRAINT cn_assets_asset_id_pk PRIMARY KEY,
       resource_id     integer
       		       CONSTRAINT cn_assets_resource_id_fk
		       REFERENCES cn_resources (resource_id),
       asset_code      varchar(255),
       serial_number   varchar(255),
       location	       varchar(255),
       quantity	       integer
);


      

------------------------------------
-- Object Type: cn_asset
------------------------------------

SELECT acs_object_type__create_type (
    'cn_asset',            -- object_type
    'CN Asset',            -- pretty_name
    'CN Assets',    	   -- pretty_plural
    'acs_object',     	   -- supertype
    'cn_assets',           -- table_name
    'asset_id',     	   -- id_column
    null,		   -- name_method
    'f',
    null,
    null
);

CREATE OR REPLACE FUNCTION cn_asset__delete(integer) 
RETURNS integer AS '
  DECLARE
	p_asset_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_assets WHERE asset_id = p_asset_id;

	RETURN 0;
  END;' LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION cn_asset__new(
       integer, -- resource_id
       varchar,	-- asset_code
       varchar,	-- serial_number
       varchar,	-- location
       integer,	-- quantity
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_asset_code	ALIAS FOR $2;
	p_serial_number	ALIAS FOR $3;
	p_location	ALIAS FOR $4;
	p_quantity	ALIAS FOR $5;
	p_creation_ip 	ALIAS FOR $6;
	p_creation_user ALIAS FOR $7;
	p_context_id	ALIAS FOR $8;

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
	       location,
	       quantity
	 ) VALUES (
	       v_id,
	       p_resource_id,
	       p_asset_code,
	       p_serial_number,
	       p_location,
	       p_quantity
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';

      
