-- /packages/cnauto-resources/sql/postgresql/cnauto-resources-create.sql

--
-- The CN Auto Resources Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--

------------------------------------
-- Table: cn_resources
------------------------------------
CREATE TABLE cn_resources (
    resource_id integer
    		CONSTRAINT cn_resources_resource_id_pk PRIMARY KEY,
    code 	varchar(255) NOT NULL,
    name 	varchar(255),
    pretty_name varchar(255),
    description text,
    type_id 	integer 
    		CONSTRAINT cn_resources_class_id_fk
    		REFERENCES cn_categories (category_id),
    unit 	varchar(50),
    ncm_class 	varchar(50)
);



------------------------------------
-- Object Type: cn_resource
------------------------------------

SELECT acs_object_type__create_type (
    'cn_resource',         -- object_type
    'CN Resource',         -- pretty_name
    'CN Resources',    	   -- pretty_plural
    'acs_object',     	   -- supertype
    'cn_resources',        -- table_name
    'resource_id',     	   -- id_column
    null,		   -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_resource__delete(integer) 
RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_resources WHERE resource_id = p_resource_id;

	RETURN 0;
  END;' LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION cn_resource__new(
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- type_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
) RETURNS integer AS '
  DECLARE
	p_code		ALIAS FOR $1;
	p_name		ALIAS FOR $2;
	p_pretty_name	ALIAS FOR $3;
	p_description	ALIAS FOR $4;
	p_type_id	ALIAS FOR $5;
	p_ncm_class	ALIAS FOR $6;
	p_unit		ALIAS FOR $7;
	p_creation_ip 	ALIAS FOR $8;
	p_creation_user ALIAS FOR $9;
	p_context_id	ALIAS FOR $10;

	v_id		integer;

  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_resource'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );

	INSERT INTO cn_resources (
	       resource_id,
	       code,
	       name,
	       pretty_name,
	       description,
	       type_id,
	       ncm_class,
	       unit
	) VALUES (
	       v_id,
	       p_code,
	       p_name,
	       p_pretty_name,
	       p_description,
	       p_type_id,
	       p_ncm_class,
	       p_unit
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_resource__edit (
       integer, -- resource_id
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- type_id
       varchar,	-- ncm_class
       varchar	-- unit
) RETURNS integer AS '
  DECLARE
	p_resource_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_name		ALIAS FOR $3;
	p_pretty_name	ALIAS FOR $4;
	p_description	ALIAS FOR $5;
	p_type_id	ALIAS FOR $6;
	p_ncm_class	ALIAS FOR $7;
	p_unit		ALIAS FOR $8;

  BEGIN
  
  	UPDATE cn_resources SET 
	       code = p_code,
	       name = p_name,
	       pretty_name = p_pretty_name,
	       description = p_description,
	       type_id = p_type_id,
	       ncm_class = p_ncm_class,
	       unit = p_unit
	WHERE resource_id = p_resource_id;

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
    code 	      varchar(255)
		      CONSTRAINT cn_parts_code_un UNIQUE,
    name 	      varchar(255),
    pretty_name	      varchar(255),
    resource_id       integer
    		      CONSTRAINT cn_parts_resource_id_fk
		      REFERENCES cn_resources(resource_id),
    model_id	      integer
    		      CONSTRAINT cn_parts_model_id_fk
    		      REFERENCES cn_categories (category_id),
    quantity 	      integer,
    price 	      varchar(100),
    width 	      varchar(100),
    height 	      varchar(100),
    depth 	      varchar(100),
    weight 	      varchar(100),
    volume 	      varchar(100),
    dimensions 	      varchar(100)
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
       varchar, -- pretty_name
       integer, -- resource_id
       integer, -- quantity
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
       p_quantity	ALIAS FOR $5;
       p_price		ALIAS FOR $6;
       p_width		ALIAS FOR $7;
       p_height 	ALIAS FOR $8;
       p_depth		ALIAS FOR $9;
       p_weight	   	ALIAS FOR $10;
       p_volume	   	ALIAS FOR $11;
       p_dimensions	ALIAS FOR $12;
       p_context_id	ALIAS FOR $13;
       p_creation_user  ALIAS FOR $14;
       p_creation_ip	ALIAS FOR $15;
     
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






------------------------------------
-- Table cn_persons
------------------------------------
CREATE TABLE cn_persons (
       person_id	integer not null
       			CONSTRAINT cn_persons_person_id_pk PRIMARY KEY,
       cpf_cnpj		varchar(30),
       legal_name	varchar(100),
       pretty_name	varchar(100),
       code		varchar(100),
       type_id		integer
       			CONSTRAINT cn_persons_type_id_fk
			REFERENCES cn_categories (category_id),	
       contact_id	integer
       			CONSTRAINT cn_persons_contact_id_fk
 		        REFERENCES acs_objects (object_id),
       email		varchar(255),
       postal_address 	varchar(255),
       postal_address2 	varchar(255),
       postal_code 	varchar(50),
       state_code 	varchar(2)
       		    	CONSTRAINT cn_persons_state_code_fk
 		        REFERENCES br_states (abbrev),
       city_code	integer,
       country_code 	varchar(2)
       		    	CONSTRAINT cn_persons_country_code_fk
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
       varchar,	  	   -- legal_name
       varchar,		   -- pretty_name
       varchar,		   -- code
       integer,		   -- type_id
       integer,		   -- contact_id
       varchar,		   -- email
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_code
       integer,		   -- city_code
       varchar,		   -- country_code
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
	p_cpf_cnpj		ALIAS FOR $1;
	p_legal_name		ALIAS FOR $2;
	p_pretty_name		ALIAS FOR $3;
	p_code			ALIAS FOR $4;
	p_type_id		ALIAS FOR $5;
	p_contact_id		ALIAS FOR $6;
	p_email			ALIAS FOR $7;
       	p_phone		   	ALIAS FOR $8;
       	p_postal_address    	ALIAS FOR $9;
       	p_postal_address2   	ALIAS FOR $10;
       	p_postal_code 	   	ALIAS FOR $11;
       	p_state_code 	   	ALIAS FOR $12;    		    	 
       	p_city_code 	   	ALIAS FOR $13;
       	p_country_code 	   	ALIAS FOR $14;
	p_creation_ip		ALIAS FOR $15;
       	p_creation_user		ALIAS FOR $16;
       	p_context_id		ALIAS FOR $17;

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
	      legal_name,
	      pretty_name,
	      code,
	      type_id,
	      contact_id,
	      email,
	      phone,
	      postal_address,
	      postal_address2,
	      postal_code,
	      state_code,
	      city_code,
	      country_code
	) VALUES (
	  v_id,
	  p_cpf_cnpj,
	  p_legal_name,
	  p_pretty_name,
	  p_code,
	  p_type_id,
	  p_contact_id,
	  p_email,
       	  p_phone,
       	  p_postal_address,
       	  p_postal_address2,
       	  p_postal_code,
       	  p_state_code,    		    	 
       	  p_city_code,
       	  p_country_code
	);

	RETURN v_id;

END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_person__edit (
       integer,	  	   -- person_id
       varchar,	  	   -- cpf_cnpj
       varchar,	  	   -- legal_name
       varchar,		   -- pretty_name
       varchar,		   -- code
       integer,		   -- type_id
       integer,		   -- contact_id
       varchar,		   -- email
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_code
       integer,		   -- city_code
       varchar		   -- country_code
) RETURNS integer AS '
  DECLARE
	p_person_id		ALIAS FOR $1;
	p_cpf_cnpj		ALIAS FOR $2;
	p_legal_name		ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;
	p_code			ALIAS FOR $5;
	p_type_id		ALIAS FOR $6;
	p_contact_id		ALIAS FOR $7;
	p_email			ALIAS FOR $8;
       	p_phone		   	ALIAS FOR $9;
       	p_postal_address    	ALIAS FOR $10;
       	p_postal_address2   	ALIAS FOR $11;
       	p_postal_code 	   	ALIAS FOR $12;
       	p_state_code 	   	ALIAS FOR $13;    		    	 
       	p_city_code 	   	ALIAS FOR $14;
       	p_country_code 	   	ALIAS FOR $15;

  BEGIN

       UPDATE cn_persons SET 
	      cpf_cnpj = p_cpf_cnpj,
	      legal_name = p_legal_name,
	      pretty_name = p_pretty_name,
	      code = p_code,
	      type_id = p_type_id,
	      contact_id = p_contact_id,
	      email = p_email,
	      phone = p_phone,
	      postal_address = p_postal_address,
	      postal_address2 = p_postal_address2,
	      postal_code = p_postal_code,
	      state_code = p_state_code,
	      city_code = p_city_code,
	      country_code = p_country_code
	WHERE person_id = p_person_id;

	RETURN 0;

END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_person__delete (
       integer	  	   -- person_id
) RETURNS integer AS '
DECLARE 
	p_person_id	ALIAS FOR $1;
	
BEGIN
	
	-- REmove user first

	DELETE FROM cn_persons WHERE person_id = p_person_id;
 	
	PERFORM acs_object__delete (p_person_id);

	RETURN 0;

END;' language 'plpgsql';




------------------------------------
-- Table cn_vehicles
------------------------------------
-- vin (vehicle identification number) - chassi
CREATE TABLE cn_vehicles (
       vehicle_id		integer PRIMARY KEY
       				CONSTRAINT cn_vehicles_vehicle_id_fk
				REFERENCES acs_objects (object_id) ON DELETE CASCADE,
       vin			varchar(50)
       				CONSTRAINT cn_vehicles_vin_nn NOT NULL,
       resource_id		integer
       				CONSTRAINT cn_vehicles_resource_id_fk
				REFERENCES cn_resources (resource_id),
       year_of_model		integer,
       year_of_fabrication 	integer,
       color			varchar(10)
       				CONSTRAINT cn_vehicles_color_fk
				REFERENCES cn_colors,
       arrival_date	   	timestamptz,
       billing_date	   	timestamptz,
       license_date	   	timestamptz,
       purchase_date	   	timestamptz,
       warranty_time   	   	varchar(10),
       distributor_id	   	integer
       			   	CONSTRAINT cn_vehicles_distributor_id_fk
			   	REFERENCES cn_persons (person_id),
       owner_id			integer
       			   	CONSTRAINT cn_vehicles_owner_id_fk
			   	REFERENCES cn_persons (person_id),
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



CREATE OR REPLACE FUNCTION cn_vehicle__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_vehicle_id	ALIAS FOR $1;
  BEGIN

  	DELETE FROM cn_vehicles WHERE vehicle_id = p_vehicle_id;
 
	PERFORM acs_object__delete(p_vehicle_id); 

	RETURN 0;
  END;' language 'plpgsql';




CREATE TABLE cn_vehicle_renavam (
       renavam_id	integer PRIMARY KEY,
       resource_id	integer
       			CONSTRAINT cn_renavam_resource_id_fk
			REFERENCES cn_resources (resource_id),
       code		varchar(255)
    			CONSTRAINT cn_renavam_code_un UNIQUE,  
       fabricant 	varchar(255),
       lcvm		varchar(255),
       model		varchar(255),
       version		varchar(255)
);


CREATE OR REPLACE FUNCTION cn_vehicle_renavam__new (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
) RETURNS integer AS '
  DECLARE
	p_renavam_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_fabricant	ALIAS FOR $3;
	p_lcvm		ALIAS FOR $4;
	p_model		ALIAS FOR $5;
	p_version	ALIAS FOR $6;

  BEGIN
  
	INSERT INTO cn_vehicle_renavam (
	       	renavam_id,
		code,
		fabricant,
		lcvm,
		model,
		version
	) VALUES (
	  	 p_renavam_id,
		 p_code,
		 p_fabricant,
		 p_lcvm,
		 p_model,
		 p_version
	);

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_vehicle_renavam__edit (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
) RETURNS integer AS '
  DECLARE
	p_renavam_id	ALIAS FOR $1;
	p_code		ALIAS FOR $2;
	p_fabricant	ALIAS FOR $3;
	p_lcvm		ALIAS FOR $4;
	p_model		ALIAS FOR $5;
	p_version	ALIAS FOR $6;

  BEGIN
  
	UPDATE cn_vehicle_renavam SET 
		code = p_code,
		fabricant = p_fabricant,
		lcvm = p_lcvm,
		model = p_model,
		version = p_version
	WHERE renavam_id = p_renavam_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_vehicle_renavam__delete (
       integer -- renavam_id
) RETURNS integer AS '
  DECLARE 
  	  p_renavam_id	ALIAS FOR $1;  
  BEGIN
	DELETE FROM cn_vehicle_renavam WHERE renavam_id = p_renavam_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';






------------------------------------
-- Table cn_assets
------------------------------------

CREATE TABLE cn_assets (
       asset_id	       integer
       		       CONSTRAINT cn_assets_asset_id_pk PRIMARY KEY,
       resource_id     integer
       		       CONTRAINT cn_assets_resource_id_fk
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

	DELETE FROM cn_asset WHERE asset_id = p_asset_id;

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
	       asset_id
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

      
