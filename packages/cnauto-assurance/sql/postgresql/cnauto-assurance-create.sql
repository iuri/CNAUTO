-- /package/cnauto-assurance/sql/postgresql/cnauto-assurance-create.sql

--
-- The CN Auto Assurance Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-11-24
--


------------------------------------
-- Table cn_assurance
------------------------------------
-- vin (vehicle identification number) - chassi
CREATE TABLE cn_assurances (
       assurance_id		integer 
       				CONSTRAINT cn_assurances_assurance_id_pk PRIMARY KEY,
       dcn			integer,
       assurance_number		integer,
       assurance_date		timestamptz,
       service_order		integer, 
       service_order_date   	timestamptz,
       lp			varchar(50),
       lp_date			timestamptz,
       lp_2			varchar(50),
       lp_2_date		timestamptz,
       owner_id			integer
       				CONSTRAINT cn_assurances_owner_id_fk
				REFERENCES cn_persons (person_id) ON DELETE CASCADE,
       distributor_id		integer
       				CONSTRAINT cn_assurances_distributor_id_fk
				REFERENCES cn_persons (person_id) ON DELETE CASCADE,
       vehicle_id		integer
       				CONSTRAINT cn_assurances_vehicle_id_fk
				REFERENCES cn_vehicles (vehicle_id) ON DELETE CASCADE,
       kilometers		integer,
       description   		text,
       status			varchar(50),
       parts_total_cost		numeric,
       assurance_total_cost	numeric,
       third_total_cost		numeric,
       mo_total_cost		numeric,
       total_cost		numeric
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

