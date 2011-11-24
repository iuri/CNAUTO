-- /package/cnauto-assurance/sql/postgresql/cnauto-assurance-drop.sql


DROP FUNCTION cn_assurance__delete (integer);

DROP FUNCTION cn_assurance__new (
       integer,	  	   -- assurance_id
       varchar,	  	   -- vin - vehicle identification number
       timestamptz,	   -- purchase_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- billin_date
       varchar,		   -- duration
       varchar,		   -- owner *
       varchar,		   -- distributor_code
       text,		   -- notes
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_abbrev
       varchar,		   -- municipality
       varchar,		   -- country
       varchar		   -- phone
);

DROP TABLE cn_assurances;


DROP TABLE cn_distributors;

DROP TABLE cn_colors CASCADE;


DROP FUNCTION cn_vehicle__delete (integer); 

DROP FUNCTION cn_vehicle__new (
      integer, 	  	   -- vin - vehicle identification number
      integer, 		   -- engine
      varchar,		   -- model
      varchar, 	   	   -- year of model
      varchar,	   	   -- year of fabrication
      varchar,		   -- color
      integer,             -- creation_user
      varchar,             -- creation_ip
      integer		   -- context_id
);

SELECT acs_object_type__drop_type (
    'cn_vehicle',	    -- object_type
    't'
);


DROP TABLE cn_vehicles;