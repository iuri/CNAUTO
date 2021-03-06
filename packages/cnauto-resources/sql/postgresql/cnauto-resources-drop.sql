-- /packages/cnauto-assurance/sql/postgresql/cnauto-resources-create.sql

--
-- The CN Auto Resources Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--



------------------------------------
-- Table cn_vehicles
------------------------------------
DROP TABLE cn_vehicles; 

------------------------------------
-- Object Type: cn_vehicles
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_vehicle',	    -- object_type
    't'
);


------------------------------------
-- cn_vehicles PL/SQL Functions
------------------------------------
DROP FUNCTION cn_vehicle__new (
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
); 

DROP FUNCTION cn_vehicle__edit (
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
);



DROP FUNCTION cn_vehicle__delete (integer);






DROP FUNCTION cn_vehicle_renavam__new (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
);

DROP FUNCTION cn_vehicle_renavam__edit (
       integer, -- renavam_id
       varchar, -- code
       varchar, -- fabricant
       varchar, -- lcvm
       varchar, -- model
       varchar -- version
);

DROP FUNCTION cn_vehicle_renavam__delete (
       integer -- renavam_id
);


DROP TABLE cn_vehicle_renavam;


------------------------------------
-- Table: cn_part
------------------------------------

DROP TABLE cn_parts;

------------------------------------
-- Object Type: cn_part
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_part',	           -- object_type
    't');






DROP  FUNCTION cn_part__delete (integer);



DROP FUNCTION cn_part__new(
       varchar, -- code
       varchar, -- name
       varchar, -- pretty_name
       integer, -- resource_id
       integer, -- model_id
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
);


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




------------------------------------
-- Table cn_persons
------------------------------------
DROP TABLE cn_persons;

------------------------------------
-- Object Type: cn_person
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_person',	   -- object_type
    't'
);



DROP FUNCTION cn_person__new (
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
);


DROP FUNCTION cn_person__edit (
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
);


DROP FUNCTION cn_person__delete (
       integer	  	   -- person_id
);








------------------------------------
-- Table: cn_resources
------------------------------------
DROP TABLE cn_resources;


SELECT acs_object_type__drop_type (
    'cn_resource',	   -- object_type
    't'
);



DROP FUNCTION cn_resource__new(
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar,	-- unit
       varchar, -- creation_ip
       integer, -- creation_user
       integer	-- context_id
);

DROP FUNCTION cn_resource__edit (
       integer, -- resource_id
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       integer,	-- class_id
       varchar,	-- ncm_class
       varchar	-- unit
);


DROP FUNCTION cn_resource__delete (integer); 



