-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.27d-0.28d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.27d-0.28d.sql', '');

ALTER TABLE cn_vehicles DROP COLUMN engine;
ALTER TABLE cn_vehicles ADD COLUMN license_date timestamptz;


DROP FUNCTION cn_vehicle__new (
      varchar,		   -- chassis vin - vehicle identification number
      integer,		   -- resource_id
      varchar, 		   -- engine
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- warranty_time
      integer,		   -- distributor_id
      integer,		   -- owner_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
);



CREATE OR REPLACE FUNCTION cn_vehicle__new (
      varchar,		   -- chassis vin - vehicle identification number
      integer,		   -- resource_id
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      timestamptz,	   -- license_date
      timestamptz,	   -- purchase_date
      varchar,		   -- warranty_time
      integer,		   -- distributor_id
      integer,		   -- owner_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
) RETURNS integer AS '
  DECLARE
       p_vin			ALIAS FOR $1; 
       p_resource_id		ALIAS FOR $2;
       p_year_of_model	      	ALIAS FOR $3;		
       p_year_of_fabrication 	ALIAS FOR $4;
       p_color			ALIAS FOR $5;
       p_arrival_date		ALIAS FOR $6;
       p_billing_date		ALIAS FOR $7;
       p_license_date		ALIAS FOR $8;
       p_purchase_date		ALIAS FOR $9;
       p_warranty_time		ALIAS FOR $10;
       p_distributor_id		ALIAS FOR $11;
       p_owner_id		ALIAS FOR $12;
       p_notes			ALIAS FOR $13;
       p_creation_ip		ALIAS FOR $14;
       p_creation_user		ALIAS FOR $15;
       p_context_id		ALIAS FOR $16;

       v_id	integer;		

  BEGIN

       v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_vehicle'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );

       INSERT INTO cn_vehicles (
       	      vehicle_id,
	      vin,
	      resource_id,
	      year_of_model,
	      year_of_fabrication,
	      color,
	      arrival_date, 
	      billing_date, 
	      license_date, 
	      purchase_date, 
	      warranty_time, 
	      distributor_id, 
	      owner_id,
	      notes
       ) VALUES (
       	      v_id,
	      p_vin,
	      p_resource_id,
	      p_year_of_model,
	      p_year_of_fabrication,
	      p_color,
              p_arrival_date,
	      p_billing_date,
	      p_license_date,
	      p_purchase_date,
       	      p_warranty_time,
	      p_distributor_id, 
	      p_owner_id,
	      p_notes
       );

       RETURN v_id;
  END;' language 'plpgsql';


DROP FUNCTION cn_vehicle__edit (
       integer,	  	   -- vehicle_id
       varchar,		   -- chassis vin - vehicle identification number
       integer,		   -- resource_id
       varchar, 	   -- engine
       integer, 	   -- year of model
       integer,	   	   -- year of fabrication
       varchar,		   -- color
       timestamptz,	   -- purchase_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- billing_date
       varchar,		   -- warranty_time
       integer,		   -- distributor_id
       integer,		   -- owner_id
       text		   -- notes
);


CREATE OR REPLACE FUNCTION cn_vehicle__edit (
       integer,	  	   -- vehicle_id
       varchar,		   -- chassis vin - vehicle identification number
       integer,		   -- resource_id
       integer, 	   -- year of model
       integer,	   	   -- year of fabrication
       varchar,		   -- color
       timestamptz,	   -- arrival_date
       timestamptz,	   -- billing_date
       timestamptz,	   -- license_date
       timestamptz,	   -- purchase_date
       varchar,		   -- warranty_time
       integer,		   -- distributor_id
       integer,		   -- owner_id
       text		   -- notes
) RETURNS integer AS '
  DECLARE
	p_vehicle_id		ALIAS FOR $1;	
	p_vin			ALIAS FOR $2; 
       	p_resource_id		ALIAS FOR $3;
       	p_year_of_model	      	ALIAS FOR $4;		
       	p_year_of_fabrication 	ALIAS FOR $5;
       	p_color			ALIAS FOR $6;
       	p_arrival_date		ALIAS FOR $7;
       	p_billing_date		ALIAS FOR $8;
       	p_license_date		ALIAS FOR $9;
       	p_purchase_date		ALIAS FOR $10;
       	p_duration		ALIAS FOR $11;
       	p_distributor_id	ALIAS FOR $12;
       	p_owner_id		ALIAS FOR $13;
       	p_notes			ALIAS FOR $14;
       
  BEGIN

       UPDATE cn_vehicles SET 
	      vin = p_vin,
	      resource_id = p_resource_id,
	      year_of_model = p_year_of_model,
	      year_of_fabrication = p_year_of_fabrication,
	      color = p_color,
	      arrival_date = p_arrival_date, 
	      billing_date = p_billing_date, 
	      license_date = p_license_date, 
	      purchase_date = p_purchase_date, 
	      warranty_time = p_warranty_time, 
	      distributor_id = p_distributor_id, 
	      owner_id = p_owner_id,
	      notes = p_notes;

       RETURN 0;

  END;' language 'plpgsql';




DROP FUNCTION cn_part__edit(
       integer,	  -- part_id	  
       varchar,   -- code
       varchar,   -- name
       varchar,   -- pretty_name
       integer,   -- resource_id
       integer,   -- model_id
       integer,   -- quantity
       varchar,   -- price
       varchar,   -- width
       varchar,   -- height
       varchar,	  -- depth
       varchar,	  -- weight
       varchar,	  -- volume
       varchar	  -- dimensions
);


CREATE OR REPLACE FUNCTION cn_part__edit(
       integer,	  -- part_id	  
       varchar,   -- code
       varchar,   -- name
       varchar,   -- pretty_name
       integer,   -- resource_id
       integer,   -- quantity
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
       	p_quantity	ALIAS FOR $6;
       	p_price		ALIAS FOR $7;
       	p_width		ALIAS FOR $8;
       	p_height 	ALIAS FOR $9;
       	p_depth		ALIAS FOR $10;
       	p_weight	ALIAS FOR $11;
       	p_volume	ALIAS FOR $12;
       	p_dimensions	ALIAS FOR $13;  

  BEGIN

       UPDATE cn_parts SET     	      
 	      code = p_code,
	      name = p_name,
	      pretty_name = p_pretty_name,
	      resource_id = p_resource_id,
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


