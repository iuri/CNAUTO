-- packages/cnauto-resources/sql/postgresl/cnauto-resources-create.sql


------------------------------------
-- Object Type: cn_part
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_part',	           -- object_type
    't'
);






DROP FUNCTION cn_part__delete(integer);

DROP FUNCTION cn_part__new(
       varchar, -- code
       varchar, -- name
       varchar, -- resource_id
       varchar, -- quantity
       varchar, -- price
       varchar, -- width
       varchar, -- height
       varchar,	-- depth
       varchar,	-- volume
       varchar,	-- dimensions
       integer, -- context_id
       integer, -- creation_user 
       varchar	-- creation_ip
);



------------------------------------
-- Table: cn_part
------------------------------------

DROP TABLE cn_parts;







DROP FUNCTION cn_person__delete (integer);

DROP FUNCTION cn_person__new (
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
);

SELECT acs_object_type__drop_type (
    'cn_person',	    -- object_type
    't'
);


DROP TABLE cn_persons;




DROP TABLE cn_colors CASCADE;


DROP FUNCTION cn_vehicle__delete (integer); 


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
      varchar,		   -- distributor_code
      integer,		   -- person_id
      text,		   -- notes
      varchar,             -- creation_ip
      integer,             -- creation_user
      integer		   -- context_id
);


SELECT acs_object_type__drop_type (
    'cn_vehicle',	    -- object_type
    't'
);


DROP TABLE cn_vehicles;






------------------------------------
-- Table: cn_resources
------------------------------------
DROP TABLE cn_resources;




DROP FUNCTION cn_resource__delete(integer);



DROP FUNCTION cn_resource__new(
       integer,	-- resource_id 
       varchar,	-- code
       varchar,	-- name
       varchar,	-- pretty_name
       text,	-- description
       varchar,	-- class
       varchar,	-- ncm_class
       varchar	-- unit
);
