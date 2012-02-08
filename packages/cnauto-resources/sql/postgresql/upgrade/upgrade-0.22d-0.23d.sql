-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.22d-0.23d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.22d-0.23d.sql','');


ALTER TABLE cn_parts ALTER COLUMN name TYPE varchar(255);

ALTER TABLE cn_parts ADD COLUMN pretty_name varchar(255);
ALTER TABLE cn_parts ADD COLUMN model_id integer;
ALTER TABLE cn_parts ADD CONSTRAINT cn_parts_model_id_fk FOREIGN KEY (model_id) REFERENCES cn_categories (category_id);



DROP FUNCTION cn_part__new(
       varchar, -- code
       varchar, -- name
       varchar, -- resource_id
       varchar, -- quantity
       varchar, -- price
       varchar, -- width
       varchar, -- height
       varchar,	-- depth
       varchar,	-- weight
       varchar,	-- volume
       varchar,	-- dimensions
       integer, -- context_id
       integer, -- creation_user 
       varchar	-- creation_ip
);



CREATE OR REPLACE FUNCTION cn_part__new(
       varchar, -- code
       varchar, -- name
       varchar, -- pretty_name
       integer, -- resource_id
       integer, -- model_id
       varchar, -- quantity
       varchar, -- price
       varchar, -- width
       varchar, -- height
       varchar,	-- depth
       varchar,	-- weight
       varchar,	-- volume
       varchar,	-- dimensions
       integer, -- context_id
       integer, -- creation_user 
       varchar	-- creation_ip
) RETURNS integer AS '
  DECLARE
       p_code		ALIAS FOR $1;
       p_name		ALIAS FOR $2;
       p_pretty_name	ALIAS FOR $3;
       p_resource_id	ALIAS FOR $4;
       p_model_id	ALIAS FOR $5;
       p_quantity	ALIAS FOR $6;
       p_price		ALIAS FOR $7;
       p_width		ALIAS FOR $8;
       p_height 	ALIAS FOR $9;
       p_depth		ALIAS FOR $10;
       p_weight	   	ALIAS FOR $11;
       p_volume	   	ALIAS FOR $12;
       p_dimensions	ALIAS FOR $13;
       p_context_id	ALIAS FOR $14;
       p_creation_user  ALIAS FOR $15;
       p_creation_ip	ALIAS FOR $16;
     
       v_id	integer;
       

  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_part'',		-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );

       INSERT INTO cn_parts (
       	      part_id,
	      code,
	      name,
	      pretty_name,
	      resource_id,
	      model_id,
	      quantity,
	      price,
	      width,
	      height,
	      depth,
	      weight,
	      volume,
	      dimensions
       ) VALUES (
       	      v_id,
	      p_code,
	      p_name,
	      p_pretty_name,
	      p_resource_id,
	      p_model_id,
	      p_quantity,
	      p_price,
	      p_width,
	      p_height,
	      p_depth,
	      p_weight,
	      p_volume,
	      p_dimensions
       );
       
       RETURN v_id;

  END;' LANGUAGE 'plpgsql';






CREATE OR REPLACE FUNCTION cn_part__edit (
       integer,	  -- part_id	  
       varchar,   -- code
       varchar,   -- name
       varchar,   -- pretty_name
       integer,   -- resource_id
       integer,   -- model_id
       varchar,   -- quantity
       varchar,   -- price
       varchar,   -- width
       varchar,   -- height
       varchar,	  -- depth
       varchar,	  -- weight
       varchar,	  -- volume
       varchar	  -- dimensions
) RETURNS integer AS '
  DECLARE
	p_part_id	ALIAS FOR $1;	
       	p_code		ALIAS FOR $2;
       	p_name		ALIAS FOR $3;
       	p_pretty_name	ALIAS FOR $4;
       	p_resource_id	ALIAS FOR $5;
       	p_model_id	ALIAS FOR $6;
       	p_quantity	ALIAS FOR $7;
       	p_price		ALIAS FOR $8;
       	p_width		ALIAS FOR $9;
       	p_height 	ALIAS FOR $10;
       	p_depth		ALIAS FOR $11;
       	p_weight	ALIAS FOR $12;
       	p_volume	ALIAS FOR $13;
       	p_dimensions	ALIAS FOR $14;  

  BEGIN

       UPDATE cn_parts SET     	      
 	      code = p_code,
	      name = p_name,
	      pretty_name = p_pretty_name,
	      resource_id = p_resource_id,
	      model_id = p_model_id,
	      quantity = p_quantity,
	      price = p_price,
	      width = p_width,
	      height = p_height,
	      depth = p_depth,
	      weight = p_weight,
	      volume = p_volume,
	      dimensions = p_dimensions
       WHERE part_id = p_part_id;
       
       RETURN 0;

  END;' LANGUAGE 'plpgsql';


