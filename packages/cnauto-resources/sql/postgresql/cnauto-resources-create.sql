------------------------------------
-- Table: cn_resources
------------------------------------
CREATE TABLE cn_resources (
    resource_id integer
    		CONSTRAINT cn_resources_resource_id_pk PRIMARY KEY,
    code 	varchar(100) NOT NULL,
    name 	varchar(100),
    pretty_name varchar(100),
    description text,
    class 	varchar(50),
    unit 	varchar(50),
    ncm_class 	varchar(50)
);




CREATE FUNCTION cn_resource__delete(integer) 
RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_resources WHERE resource_id = p_resource_id;

	RETURN 0;
  END;' LANGUAGE 'plpgsql';



CREATE FUNCTION cn_resource__new(
       integer,	-- resource_id 
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       varchar,	-- class
       varchar,	-- ncm_class
       varchar	-- unit
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_name		ALIAS FOR $3;
	p_pretty_name	ALIAS FOR $4;
	p_description	ALIAS FOR $5;
	p_class		ALIAS FOR $6;
	p_ncm_class	ALIAS FOR $7;
	p_unit		ALIAS FOR $8;

  BEGIN

	INSERT INTO cn_resources (
	       resource_id,
	       code,
	       name,
	       pretty_name,
	       description,
	       class,
	       ncm_class,
	       unit
	) VALUES (
	       p_resource_id,
	       p_code,
	       p_name,
	       p_pretty_name,
	       p_description,
	       p_class,
	       p_ncm_class,
	       p_unit
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';




------------------------------------
-- Table: cn_part
------------------------------------

CREATE TABLE cn_parts (
    part_id  	      integer
    		      CONSTRAINT cn_resources_resoure_id_pk PRIMARY KEY
    		      CONSTRAINT cn_parts_part_id_fk 
		      REFERENCES acs_objects(object_id),
    code 	      varchar(10)
		      CONSTRAINT cn_parts_code_un UNIQUE,
    name 	      varchar(50),
    resource_id       integer
    		      CONSTRAINT cn_parts_resource_id_fk
		      REFERENCES cn_resources(resource_id),
    quantity 	      varchar(10),
    price 	      varchar(10),
    width 	      varchar(10),
    height 	      varchar(10),
    depth 	      varchar(10),
    weight 	      varchar(10),
    volume 	      varchar(10),
    dimensions 	      varchar(10)
);


------------------------------------
-- Object Type: cn_part
------------------------------------

SELECT acs_object_type__create_type (
    'cn_part',	           -- object_type
    'CN Part',             -- pretty_name
    'CN Parts',    	   -- pretty_plural
    'acs_object',     	   -- supertype
    'cn_parts',            -- table_name
    'part_id',     	   -- id_column
    null,		   -- name_method
    'f',
    null,
    null
);






CREATE OR REPLACE FUNCTION cn_part__delete(integer) 
RETURNS integer AS '
  DECLARE
	p_part_id	ALIAS FOR $1;
	
  BEGIN
	
	DELETE FROM cn_parts WHERE part_id = p_part_id;
 	
	PERFORM acs_object__delete (p_part_id);

	RETURN 0;

END;' language 'plpgsql';




CREATE OR REPLACE FUNCTION cn_part__new(
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
) RETURNS integer AS '
  DECLARE
       p_code		ALIAS FOR $1;
       p_name		ALIAS FOR $2;
       p_resource_id	ALIAS FOR $3;
       p_quantity	ALIAS FOR $4;
       p_price		ALIAS FOR $5;
       p_width		ALIAS FOR $6;
       p_height 	ALIAS FOR $7;
       p_depth		ALIAS FOR $8;
       p_weight	   	ALIAS FOR $9;
       p_volume	   	ALIAS FOR $10;
       p_dimensions	ALIAS FOR $11;
       p_context_id	ALIAS FOR $12;
       p_creation_user  ALIAS FOR $13;
       p_creation_ip	ALIAS FOR $14;
     
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
	      resource,
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
	      p_resource,
	      p_quantity,
	      p_price,
	      p_width,
	      p_height,
	      p_depth,
	      p_weight,
	      p_volume,
	      p_dimensions
       );
       
       return v_id;

  END;' LANGUAGE 'plpgsql';






------------------------------------
-- Table cn_persons
------------------------------------
CREATE TABLE cn_persons (
       person_id	integer not null
       			CONSTRAINT cn_persons_person_id_pk PRIMARY KEY
       			CONSTRAINT cn_persons_person_id_fk
			REFERENCES  acs_objects (object_id),
       cpf_cnpj		varchar(25)
       			CONSTRAINT cn_persons_cpf_cnpj_un UNIQUE,
       first_names	varchar (30),
       last_name	varchar(30),
       type		varchar(10),	
       email		varchar(30),
       postal_address 	varchar(255),
       postal_address2 	varchar(255),
       postal_code 	varchar(50),
       state_abbrev 	varchar(2)
       		    	CONSTRAINT cn_assurances_state_abbrev_fk
 		        REFERENCES br_states (abbrev),
       municipality 	varchar(100),
       country_code 	varchar(2)
       		    	CONSTRAINT cn_assurances_country_code_fk
			REFERENCES countries (iso),
       phone		varchar(15)
);


------------------------------------
-- Object Type: cn_person
------------------------------------

SELECT acs_object_type__create_type (
    'cn_person',	   -- object_type
    'CN Person',           -- pretty_name
    'CN Persons',    	   -- pretty_plural
    'acs_object',     	   -- supertype
    'cn_persons',          -- table_name
    'person_id',     	   -- id_column
    null,		   -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_person__new (
       varchar,	  	   -- cpf_cnpj
       varchar,	  	   -- first_names
       varchar,		   -- last_name
       varchar,		   -- email
       varchar,		   -- type
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_abbrev
       varchar,		   -- municipality
       varchar,		   -- country
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
	p_cpf_cnpj		ALIAS FOR $1;
	p_first_names		ALIAS FOR $2;
	p_last_name		ALIAS FOR $3;
	p_email			ALIAS FOR $4;
	p_type			ALIAS FOR $5;
       	p_phone		   	ALIAS FOR $6;
       	p_postal_address    	ALIAS FOR $7;
       	p_postal_address2   	ALIAS FOR $8;
       	p_postal_code 	   	ALIAS FOR $9;
       	p_state_abbrev 	   	ALIAS FOR $10;    		    	 
       	p_municipality 	   	ALIAS FOR $11;
       	p_country_code 	   	ALIAS FOR $12;
	p_creation_ip		ALIAS FOR $13;
       	p_creation_user		ALIAS FOR $14;
       	p_context_id		ALIAS FOR $15;

       	v_id	integer;		
       	v_type	varchar;

  BEGIN

       v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_person'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );


       INSERT INTO cn_persons (
       	      person_id,
	      cpf_cnpj,
	      first_names,
	      last_name,
	      email,
	      type,
	      phone,
	      postal_address,
	      postal_address2,
	      postal_code,
	      state_abbrev,
	      municipality,
	      country_code
	) VALUES (
	  v_id,
	  p_cpf_cnpj,
	  p_first_names,
	  p_last_name,
	  p_email,
	  p_type,
       	  p_phone,
       	  p_postal_address,
       	  p_postal_address2,
       	  p_postal_code,
       	  p_state_abbrev,    		    	 
       	  p_municipality,
       	  p_country_code
	);

	RETURN v_id;

END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_person__delete (
       integer	  	   -- person_id
) RETURNS integer AS '
DECLARE 
	p_person_id	ALIAS FOR $1;
	
BEGIN
	
	DELETE FROM cn_persons WHERE person_id = p_person_id;
 	
	PERFORM acs_object__delete (p_person_id);

	RETURN 0;

END;' language 'plpgsql';






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
				REFERENCES cn_colors,
       purchase_date	   	timestamptz,
       arrival_date	   	timestamptz,
       billing_date	   	timestamptz,
       duration	   	   	varchar(10),
       person_id	   	integer
       			   	CONSTRAINT cn_vehicles_person_id_fk
			   	REFERENCES cn_persons (person_id),
       distributor_code	   	varchar(10),
       notes		   	text
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
      timestamptz,	   -- purchase_date
      timestamptz,	   -- arrival_date
      timestamptz,	   -- billing_date
      varchar,		   -- duration
      varchar,		   -- distributor_code
      integer,		   -- person_id
      text,		   -- notes
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
       p_purchase_date		ALIAS FOR $8;
       p_arrival_date		ALIAS FOR $9;
       p_billing_date		ALIAS FOR $10;
       p_duration		ALIAS FOR $11;
       p_distributor_code	ALIAS FOR $12;
       p_person_id		ALIAS FOR $13;
       p_notes			ALIAS FOR $14;
       p_creation_ip		ALIAS FOR $15;
       p_creation_user		ALIAS FOR $16;
       p_context_id		ALIAS FOR $17;

       v_id	integer;		
       v_type	varchar;

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
	      distributor_code,
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
	      p_distributor_code,
	      p_notes
       );

       RETURN v_id;
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