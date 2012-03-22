-- /package/cnauto-warranty/sql/postgresql/cnauto-warranty-drop.sql

SELECT content_type__drop_type (
       'claim_file_object',  -- content_type
       't',
       't'
);


DROP FUNCTION cn_cpr__delete (
       integer -- map_id
);


DROP FUNCTION cn_cpr__new (
       integer,	  	   -- request_id
       integer,	      	   -- claim_id
       integer,		   -- part_id              
       numeric,		   -- cost
       integer,		   -- quantity
       numeric,		   -- claim_cost
       numeric,		   -- incomes
       varchar,		   -- mo_code
       integer,		   -- mo_time
       numeric		   -- third_services_cost
);


DROP TABLE cn_claim_part_requests;




DROP FUNCTION cn_claim__delete (integer);

DROP FUNCTION cn_claim__update_costs (
       integer,		   -- claim_id
       varchar,		   -- status
       text,		   -- description
       numeric,		   -- parts_total_cost
       numeric,		   -- claim_total_cost
       numeric,		   -- third_total_cost
       numeric,		   -- mo_total_cost
       numeric		   -- total_cost	  
);


DROP FUNCTION cn_claim__edit (
       integer,		   -- claim_id
       integer,		   -- warranty_id       
       timestamptz,	   -- claim_date
       varchar,		   -- service_order
       integer,		   -- vehicle_id
       numeric,		   -- kilometers
       varchar,		   -- status
       integer,		   -- owner_id
       integer		   -- distributor_id	  
);

DROP FUNCTION cn_claim__new (
       integer,	  	   -- warranty_id
       integer,		   -- claim_number
       timestamptz,	   -- claim_date
       integer,		   -- service_order
       timestamptz,	   -- service_order_date
       integer,		   -- vehicle_id
       numeric,		   -- kilometers	  
       varchar,		   -- status
       integer,		   -- owner_id
       integer,		   -- distributor_id
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id	   
);

DROP SEQUENCE cn_claim_id_seq;


SELECT acs_object_type__drop_type (
    'cn_claim',	    -- object_type
    't'
);


DROP TABLE cn_claims;



DROP FUNCTION cn_warranty__delete ( integer );


DROP FUNCTION cn_warranty__new (
       integer,	  -- vehicle_id
       varchar,	  -- creation_ip
       integer,	  -- creation_user
       integer	  -- context_id
);


SELECT acs_object_type__drop_type (
    'cn_warranty',	    -- object_type
    't'
);



DROP TABLE cn_warranties;
