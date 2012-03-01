-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.21d-0.22d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.21d-0.22d.sql','');



DROP FUNCTION cn_vehicle__new (
      varchar,		   -- chassis vin - vehicle identification number
      varchar, 		   -- engine
      integer,		   -- model_id
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- duration
      integer,		   -- resource_id
      integer,		   -- distributor_id
      integer,		   -- owner_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
);     



------------------------------------
-- cn_vehicles PL/SQL Functions
------------------------------------
CREATE OR REPLACE FUNCTION cn_vehicle__new (
      varchar,		   -- chassis vin - vehicle identification number
      integer,		   -- resource_id
      integer,		   -- model_id
      varchar, 		   -- engine
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- duration
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
       p_model_id	      	ALIAS FOR $3;
       p_engine		      	ALIAS FOR $4;
       p_year_of_model	      	ALIAS FOR $5;		
       p_year_of_fabrication 	ALIAS FOR $6;
       p_color			ALIAS FOR $7;
       p_purchase_date		ALIAS FOR $8;
       p_arrival_date		ALIAS FOR $9;
       p_billing_date		ALIAS FOR $10;
       p_duration		ALIAS FOR $11;
       p_distributor_id		ALIAS FOR $12;
       p_owner_id		ALIAS FOR $13;
       p_notes			ALIAS FOR $14;
       p_creation_ip		ALIAS FOR $15;
       p_creation_user		ALIAS FOR $16;
       p_context_id		ALIAS FOR $17;

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
	      model_id,
	      engine,
	      year_of_model,
	      year_of_fabrication,
	      color,
	      purchase_date, 
	      arrival_date, 
	      billing_date, 
	      duration, 
	      distributor_id, 
	      owner_id,
	      notes
       ) VALUES (
       	      v_id,
	      p_vin,
	      p_resource_id,
	      p_model_id,
	      p_engine,
	      p_year_of_model,
	      p_year_of_fabrication,
	      p_color,
	      p_purchase_date,
              p_arrival_date,
	      p_billing_date,
       	      p_duration,
	      p_distributor_id, 
	      p_owner_id,
	      p_notes
       );

       RETURN v_id;
  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_vehicle__edit (
       integer,	  	   -- vehicle_id
       varchar,		   -- chassis vin - vehicle identification number
       integer,		   -- resource_id
       integer,		   -- model_id
       varchar, 	   -- engine
       integer, 	   -- year of model
       integer,	   	   -- year of fabrication
       varchar,		   -- color
       timestamptz,	   -- purchase_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- billing_date
       varchar,		   -- duration
       integer,		   -- distributor_id
       integer,		   -- owner_id
       text		   -- notes
) RETURNS integer AS '
  DECLARE
	p_vehicle_id		ALIAS FOR $1;	
	p_vin			ALIAS FOR $2; 
       	p_resource_id		ALIAS FOR $3;
       	p_model_id	      	ALIAS FOR $4;
       	p_engine		ALIAS FOR $5;
       	p_year_of_model	      	ALIAS FOR $6;		
       	p_year_of_fabrication 	ALIAS FOR $7;
       	p_color			ALIAS FOR $8;
       	p_purchase_date		ALIAS FOR $9;
       	p_arrival_date		ALIAS FOR $10;
       	p_billing_date		ALIAS FOR $11;
       	p_duration		ALIAS FOR $12;
       	p_distributor_id	ALIAS FOR $13;
       	p_owner_id		ALIAS FOR $14;
       	p_notes			ALIAS FOR $15;
       
  BEGIN

	UPDATE cn_vehicles SET 
	      vin = p_vin,
	      resource_id = p_resource_id,
	      model_id = p_model_id,
	      engine = p_engine,
	      year_of_model = p_year_of_model,
	      year_of_fabrication = p_year_of_fabrication,
	      color = p_color,
	      purchase_date = p_purchase_date, 
	      arrival_date = p_arrival_date, 
	      billing_date = p_billing_date, 
	      duration = p_duration, 
	      distributor_id = p_distributor_id, 
	      owner_id = p_owner_id,
	      notes = p_notes;

       RETURN 0;
  END;' language 'plpgsql';
