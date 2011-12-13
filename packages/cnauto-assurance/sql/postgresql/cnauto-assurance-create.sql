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
-- Table cn_distributors
------------------------------------
CREATE TABLE cn_distributors (
       code      varchar(10)
       		 CONSTRAINT cn_distributors_code__nn NOT NULL
       		 CONSTRAINT cn_distributors_code_un UNIQUE,       
       name	 varchar(50),
       cnpj	 varchar(20)
       		 CONSTRAINT cn_distributors_cnpj_un UNIQUE       
);


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
-- Object Type: cn_vehicles
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

       -- v_type := "cn_person";

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







------------------------------------
-- Table cn_assurance
------------------------------------
-- vin (vehicle identification number) - chassi
CREATE TABLE cn_assurances (
       assurance_id		integer 
       				CONSTRAINT cn_assurances_assurance_id PRIMARY KEY,
       dcn			integer,
       assurance_number		integer,
       assurance_date		timestamptz,
       status			varchar(50),
       lp			varchar(50),
       lp_date			timestamptz,
       lp_2			varchar(50),
       lp_2_date		timestamptz,
       service_order		integer, 
       service_order_date   	timestamptz,
       vehicle_id		integer
       				CONSTRAINT cn_assurances_vehicle_id_fk
				REFERENCES cn_vehicles ON DELETE CASCADE,
       kilometers		integer,
       part_group		varchar(10),			
       part_code		varchar(30),
       part_quantity		integer,
       damage_description   	text,
       third_service		varchar(10),
       cost_price		varchar(10),
       assurance_price		varchar(10),
       tmo_code			varchar(20),
       tmo_duration		varchar(10),
       cost			varchar(10),
       ttl_sg			varchar(10)
);


------------------------------------
-- Object Type: cn_assurance
------------------------------------

SELECT acs_object_type__create_type (
    'cn_assurance',	    -- object_type
    'CN Assurance',         -- pretty_name
    'CN Assurances',   	    -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_assurances',        -- table_name
    'assurance_id',   	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);




CREATE OR REPLACE FUNCTION cn_assurance__new (
       integer,	  	   -- dcn
       integer,		   -- integer
       timestamptz,	   -- assurance_date
       varchar,		   -- status
       varchar,		   -- lp
       timestamptz,	   -- lp_date
       varchar,		   -- lp2
       timestamptz,	   -- lp2_date
       integer,		   -- service_order
       timestamptz,	   -- service_order_date
       integer,		   -- vehicle_id
       integer,		   -- kilometers
       varchar,		   -- part_group
       varchar,		   -- part_code
       integer,		   -- part_quantity
       text,		   -- damage_description
       varchar,		   -- third_service
       varchar,		   -- cost_price
       varchar,		   -- assurance_price
       varchar,		   -- tmo_code
       varchar,		   -- tmo_duration
       varchar,		   -- cost
       varchar,		   -- ttl_sg	
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id	   
) RETURNS integer AS '
  DECLARE
	p_dcn			ALIAS FOR $1;
       	p_assurance_number	ALIAS FOR $2;
       	p_assurance_date	ALIAS FOR $3;
 	p_status		ALIAS FOR $4;
       	p_lp			ALIAS FOR $5;
       	p_lp_date		ALIAS FOR $6;
       	p_lp_2			ALIAS FOR $7;
       	p_lp_2_date		ALIAS FOR $8;
       	p_service_order		ALIAS FOR $9; 
       	p_service_order_date   	ALIAS FOR $10;
       	p_vehicle_id		ALIAS FOR $11;
        p_kilometers		ALIAS FOR $12;
       	p_part_group		ALIAS FOR $13;			
       	p_part_code		ALIAS FOR $14;
       	p_part_quantity		ALIAS FOR $15;
      	p_damage_description   	ALIAS FOR $16;
       	p_third_service		ALIAS FOR $17;
       	p_cost_price		ALIAS FOR $18;
       	p_assurance_price	ALIAS FOR $19;
      	p_tmo_code		ALIAS FOR $20;
       	p_tmo_duration		ALIAS FOR $21;
       	p_cost			ALIAS FOR $22;
       	p_ttl_sg		ALIAS FOR $23;
	p_creation_ip		ALIAS FOR $24;
	p_creation_user		ALIAS FOR $25;	
	p_context_id		ALIAS FOR $26;

	v_id			integer;

  BEGIN
	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_assurance'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
        );


	INSERT INTO cn_assurances (
	       assurance_id,
	       dcn,
	       assurance_number,
	       assurance_date,
	       status,
	       lp,
	       lp_date,
	       lp_2,
	       lp_2_date,
	       service_order, 
	       service_order_date,
	       vehicle_id,
	       kilometers,
	       part_group,
	       part_code,
	       part_quantity,
	       damage_description,
	       third_service,
	       cost_price,
	       assurance_price,
	       tmo_code,
	       tmo_duration,
	       cost,
	       ttl_sg
	) VALUES (
	       v_id,
	       p_dcn,
	       p_assurance_number,
	       p_assurance_date,
	       p_status,
	       p_lp,
	       p_lp_date,
	       p_lp_2,
	       p_lp_2_date,
	       p_service_order, 
	       p_service_order_date,
	       p_vehicle_id,
	       p_kilometers,
	       p_part_group,			
	       p_part_code,
	       p_part_quantity,
	       p_damage_description,
	       p_third_service,
	       p_cost_price,
	       p_assurance_price,
	       p_tmo_code,
	       p_tmo_duration,
	       p_cost,
	       p_ttl_sg
	);


	RETURN 0;
  END;' language 'plpgsql';




CREATE OR REPLACE FUNCTION cn_assurance__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_assurance_id	ALIAS FOR $1;
  BEGIN

  	DELETE FROM cn_assuarances WHERE assurance_id = p_assurance_id;
 
	PERFORM acs_object__delete(p_assurance_id); 

	RETURN 0;
  END;' language 'plpgsql';

