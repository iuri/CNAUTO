-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.12d-0.13d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.12d-0.13d.sql','');

-- ALTER TABLE cn_vehicles DROP COLUMN person_id; 
-- ALTER TABLE cn_vehicles ADD COLUMN client_id integer;

--ALTER TABLE cn_vehicles DROP CONSTRAINT cn_vehicles_person_id_fk;

ALTER TABLE cn_vehicles RENAME COLUMN person_id TO client_id
ALTER TABLE cn_vehicles ADD CONSTRAINT cn_vehicles_client_id_fk FOREIGN KEY (client_id) REFERENCES cn_persons (person_id);




ALTER TABLE cn_vehicles ADD COLUMN distributor_id integer;

ALTER TABLE cn_vehicles ADD CONSTRAINT cn_vehicles_distributor_id_fk FOREIGN KEY (distributor_id) REFERENCES cn_persons (person_id);



------------------------------------
-- cn_vehicles PL/SQL Functions
------------------------------------



DROP FUNCTION cn_vehicle__new (
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
      integer,		   -- person_id
      integer,		   -- resource_id
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
      integer,		   -- distributor_id
      integer,		   -- client_id
      integer,		   -- resource_id
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
       p_distributor_id		ALIAS FOR $11;
       p_client_id		ALIAS FOR $12;
       p_resource_id		ALIAS FOR $13;
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
	      engine,
	      model,
	      year_of_model,
	      year_of_fabrication,
	      color,
	      purchase_date, 
	      arrival_date, 
	      billing_date, 
	      duration, 
	      distributor_id, 
	      client_id,
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
	      p_distributor_id, 
	      p_client_id,
	      p_resource_id,
	      p_notes
       );

       RETURN v_id;
  END;' language 'plpgsql';
