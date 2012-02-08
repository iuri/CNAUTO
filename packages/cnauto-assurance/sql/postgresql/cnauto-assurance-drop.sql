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
