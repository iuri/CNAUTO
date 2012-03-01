-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.4d-0.5d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.4d-0.5d.sql', '');


ALTER TABLE cn_assurances ALTER COLUMN service_order TYPE varchar(255); 


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
       numeric,		   -- kilometers
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
);




CREATE OR REPLACE FUNCTION cn_assurance__new (
       integer,		   -- assurance_number
       timestamptz,	   -- assurance_date
       varchar,		   -- service_order
       timestamptz,	   -- service_order_date
       integer,		   -- vehicle_id
       numeric,		   -- kilometers	  
       varchar,		   -- status
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id	   
) RETURNS integer AS '
  DECLARE
       	p_assurance_number	ALIAS FOR $1;
       	p_assurance_date	ALIAS FOR $2;
       	p_service_order		ALIAS FOR $3; 
       	p_service_order_date   	ALIAS FOR $4;
       	p_vehicle_id		ALIAS FOR $5;
        p_kilometers		ALIAS FOR $6;
 	p_status		ALIAS FOR $7;
	p_creation_ip		ALIAS FOR $8;
	p_creation_user		ALIAS FOR $9;	
	p_context_id		ALIAS FOR $10;

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
	       assurance_number,
	       assurance_date,
	       service_order, 
	       service_order_date,
	       vehicle_id,
	       kilometers,
	       status
	) VALUES (
	       v_id,
	       p_assurance_number,
	       p_assurance_date,
	       p_service_order, 
	       p_service_order_date,
	       p_vehicle_id,
	       p_kilometers,
	       p_status
	);


	RETURN v_id;
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
