-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.8d-0.9d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.8d-0.9d.sql','');

DROP FUNCTION cn_vehicle__new (
      integer, 	  	   -- vehicle_id 
      varchar,		   -- chassis vin - vehicle identification number
      varchar, 		   -- engine
      varchar,		   -- model
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- duration
      integer,		   -- resource_id
      integer,		   -- person_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
); 

 


CREATE OR REPLACE FUNCTION cn_vehicle__new (
      varchar,		   -- chassis vin - vehicle identification number
      varchar, 		   -- engine
      varchar,		   -- model
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- duration
      integer,		   -- resource_id
      integer,		   -- person_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
) RETURNS integer AS '
  DECLARE
       p_vin			ALIAS FOR $1; 
       p_model		      	ALIAS FOR $2;
       p_engine		      	ALIAS FOR $3;
       p_year_of_model	      	ALIAS FOR $4;		
       p_year_of_fabrication 	ALIAS FOR $5;
       p_color			ALIAS FOR $6;
       p_purchase_date		ALIAS FOR $7;
       p_arrival_date		ALIAS FOR $8;
       p_billing_date		ALIAS FOR $9;
       p_duration		ALIAS FOR $10;
       p_resource_id		ALIAS FOR $11;
       p_person_id		ALIAS FOR $12;
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
	      engine,
	      model,
	      year_of_model,
	      year_of_fabrication,
	      color,
	      purchase_date, 
	      arrival_date, 
	      billing_date, 
	      duration, 
	      person_id, 
	      resource_id,
	      notes
       ) VALUES (
       	      v_id,
	      p_vin,
	      p_engine,
	      p_model,
	      p_year_of_model,
	      p_year_of_fabrication,
	      p_color,
	      p_purchase_date,
              p_arrival_date,
	      p_billing_date,
       	      p_duration,
       	      p_person_id,
	      p_resource_id,
	      p_notes
       );

       RETURN v_id;
  END;' language 'plpgsql';
