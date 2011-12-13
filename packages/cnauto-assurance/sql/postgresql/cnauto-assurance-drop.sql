-- /package/cnauto-assurance/sql/postgresql/cnauto-assurance-drop.sql

DROP FUNCTION cn_assurance__delete ( integer );


DROP FUNCTION cn_assurance__new (
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
       varchar		   -- ttl_sg		   
);



SELECT acs_object_type__drop_type (
    'cn_assurance',	    -- object_type
    't'
);



DROP TABLE cn_assurances;





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



DROP TABLE cn_distributors;

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


