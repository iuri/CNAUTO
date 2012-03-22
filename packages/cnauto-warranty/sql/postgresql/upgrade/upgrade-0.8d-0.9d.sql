-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.8d-0.9d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.8d-0.9d.sql', '');


DROP FUNCTION cn_assurance__new (
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
);


CREATE OR REPLACE FUNCTION cn_assurance__new (
       integer,		   -- assurance_number
       timestamptz,	   -- assurance_date
       varchar,		   -- service_order
       timestamptz,	   -- service_order_date
       integer,		   -- vehicle_id
       numeric,		   -- kilometers	  
       varchar,		   -- status
       integer,		   -- owner_id
       integer,		   -- distributor_id
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
	p_owner_id		ALIAS FOR $8;
	p_distributor_id	ALIAS FOR $9;
	p_creation_ip		ALIAS FOR $10;
	p_creation_user		ALIAS FOR $11;	
	p_context_id		ALIAS FOR $12;

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
	       status,
	       owner_id,
	       distributor_id
	) VALUES (
	       v_id,
	       p_assurance_number,
	       p_assurance_date,
	       p_service_order, 
	       p_service_order_date,
	       p_vehicle_id,
	       p_kilometers,
	       p_status,
	       p_owner_id,
	       p_distributor_id
	);


	RETURN v_id;
  END;' language 'plpgsql';
