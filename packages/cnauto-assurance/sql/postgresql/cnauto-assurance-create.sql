-- /package/cnauto-assurance/sql/postgresql/cnauto-assurance-create.sql

--
-- The CN Auto Assurance Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-11-24
--


------------------------------------
-- Table cn_colors
------------------------------------
CREATE TABLE cn_colors (
       code      varchar(10)
		 PRIMARY KEY,       
       name	 varchar(50)
       		 CONSTRAINT cn_colors_name_nn NOT NULL
       		 CONSTRAINT cn_colors_name_un UNIQUE
);




------------------------------------
-- Table cn_vehicles
------------------------------------
-- vin (vehicle identification number) - chassi
CREATE TABLE cn_vehicles (
       vehicle_id		integer PRIMARY KEY
       				CONSTRAINT cn_vehicles_vehicle_id_fk
				REFERENCES acs_objects ON DELETE CASCADE,
       vin			varchar(50)
       				CONSTRAINT cn_vehicles_vin_nn NOT NULL
				CONSTRAINT cn_vehicles_vin_un UNIQUE,
       engine			varchar(100),
       model			varchar(100),
       year_of_model		integer,
       year_of_fabrication 	integer,
       color			varchar(10)
       				CONSTRAINT cn_vehicles_color_fk
				REFERENCES cn_colors
);


------------------------------------
-- Object Type: cn_vehicles
------------------------------------

SELECT acs_object_type__create_type (
    'cn_vehicle',	    -- object_type
    'CN Vehicle',           -- pretty_name
    'CN Vehicles',    	    -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_vehicles',          -- table_name
    'vehicle_id',     	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);



------------------------------------
-- cn_vehicles PL/SQL Functions
------------------------------------
CREATE OR REPLACE FUNCTION cn_vehicle__new (
      integer, 	  	   -- vehicle_id 
      varchar,		   -- chassis vin - vehicle identification number
      varchar, 		   -- engine
      varchar,		   -- model
      integer, 	   	   -- year of model
      integer,	   	   -- year of fabrication
      varchar,		   -- color
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
) RETURNS integer AS '
  DECLARE
       p_vehicle_id		ALIAS FOR $1;
       p_vin			ALIAS FOR $2; 
       p_model		      	ALIAS FOR $3;
       p_engine		      	ALIAS FOR $4;
       p_year_of_model	      	ALIAS FOR $5;		
       p_year_of_fabrication 	ALIAS FOR $6;
       p_color			ALIAS FOR $7;
       p_creation_ip		ALIAS FOR $8;
       p_creation_user		ALIAS FOR $9;
       p_context_id		ALIAS FOR $10;

       v_id	integer;		
       v_type	varchar;

  BEGIN

       -- v_type := "cn_vehicle";

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
	      color
       ) VALUES (
       	      v_id,
	      p_vin,
	      p_engine,
	      p_model,
	      p_year_of_model,
	      p_year_of_fabrication,
	      p_color
       );

       RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_vehicle__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_vehicle_id	ALIAS FOR $1;
  BEGIN

  	DELETE FROM cn_vehicles WHERE vehicle_id = p_vehicle_id;
 
	PERFORM acs_object__delete(p_vehicle_id); 

	RETURN 0;
  END;' language 'plpgsql';






CREATE TABLE cn_distributors (
       code      varchar(10)
       		 CONSTRAINT cn_distributors_code__nn NOT NULL
       		 CONSTRAINT cn_distributors_code_un UNIQUE,       
       name	 varchar(50)
);



------------------------------------
-- Table cn_assurances
------------------------------------

CREATE TABLE cn_assurances (
       assurance_id	   integer PRIMARY KEY,
       vehicle_id	   integer
       			   CONSTRAINT cn_assurances_vehicle_id_fk
			   REFERENCES cn_vehicles,
       purchase_date	   timestamptz,
       arrival_date	   timestamptz,
       billing_date	   timestamptz,
       duration	   	   varchar(10),
       owner		   varchar(255),
       distributor_code	   varchar(10),
       notes		   text,
       postal_address 	   varchar(255),
       postal_address2 	   varchar(255),
       postal_code 	   varchar(50),
       state_abbrev 	   varchar(2)
       		    	   CONSTRAINT cn_assurances_state_abbrev_fk
 		           REFERENCES br_states (abbrev),
       municipality 	   varchar(100),
       country_code 	   varchar(2)
       		    	   CONSTRAINT cn_assurances_country_code_fk
			   REFERENCES countries (iso),
       phone		   varchar(15)
);



------------------------------------
-- Object Type: cn_vehicles
------------------------------------

SELECT acs_object_type__create_type (
    'cn_assurance',	    -- object_type
    'CN Assurance',         -- pretty_name
    'CN Assurances',   	    -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_assurance',         -- table_name
    'assurance_id',    	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);



------------------------------------
-- cn_vehicles PL/SQL Functions
------------------------------------

CREATE OR REPLACE FUNCTION cn_assurance__new (
       integer,	  	   -- assurance_id
       integer,	  	   -- vehicle_id
       timestamptz,	   -- purchase_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- billing_date
       varchar,		   -- duration
       varchar,		   -- owner *
       varchar,		   -- distributor_code
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_abbrev
       varchar,		   -- municipality
       varchar,		   -- country
       varchar,		   -- phone
       text,		   -- notes
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE

       p_assurance_id	   ALIAS FOR $1;
       p_vehicle_id	   ALIAS FOR $2;
       p_purchase_date	   ALIAS FOR $3;
       p_arrival_date	   ALIAS FOR $4;
       p_billing_date	   ALIAS FOR $5;
       p_duration	   ALIAS FOR $6;
       p_distributor_code  ALIAS FOR $7;
       p_owner		   ALIAS FOR $8;
       p_phone		   ALIAS FOR $9;
       p_postal_address    ALIAS FOR $10;
       p_postal_address2   ALIAS FOR $11;
       p_postal_code 	   ALIAS FOR $12;
       p_state_abbrev 	   ALIAS FOR $13;    		    	 
       p_municipality 	   ALIAS FOR $14;
       p_country_code 	   ALIAS FOR $15;
       p_notes		   ALIAS FOR $16;
       p_creation_ip	   ALIAS FOR $17;
       p_creation_user	   ALIAS FOR $18;
       p_context_id	   ALIAS FOR $19;
  
       v_id	integer;		
       v_type	varchar;

  BEGIN

       v_type := "cn_assurance";

       v_id := acs_object__new (
       		  null,
		  v_type,
		  now(),
		  p_creation_user,
		  p_creation_ip,
		  p_context_id,
		  true
       );

	INSERT INTO cn_assurances (
	       assurance_id, 
	       vehicle_id, 
	       purchase_date, 
	       arrival_date, 
	       billing_date, 
	       duration, 
	       owner, 
	       distributor_code,
	       postal_address,
	       postal_address2,
	       postal_code,
	       state_abbrev,
	       municipality,
	       country_code,
	       phone,
	       notes
	) VALUES (
	       v_id,
       	       p_vehicle_id,
	       p_purchase_date,
               p_arrival_date,
	       p_billing_date,
       	       p_duration,
       	       p_owner,
	       p_distributor_code,
	       p_postal_address, 
	       p_postal_address2,
	       p_postal_code,
	       p_state_abbrev,    		    	 
	       p_municipality,
	       p_country_code,
	       p_phone,
	       p_notes
	 );
	 
	 RETURN 0;

  END;' language 'plpgsql';




CREATE OR REPLACE FUNCTION cn_assurance__delete (integer)
RETURNS integer AS '
  DECLARE
	p_assurance_id	ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_assurances WHERE assurance_id = p_assurance_id;

	PERFORM acs_object__delete(p_assurance_id); 

	RETURN 0;

  END;' language 'plpgsql';
