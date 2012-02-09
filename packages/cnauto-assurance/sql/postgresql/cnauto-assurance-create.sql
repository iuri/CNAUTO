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
       assurance_number		integer,
       assurance_date		timestamptz,
       service_order		varchar(255), 
       service_order_date   	timestamptz,
       vehicle_id		integer
       				CONSTRAINT cn_assurances_vehicle_id_fk
				REFERENCES cn_vehicles (vehicle_id) ON DELETE CASCADE,
       kilometers		numeric,
       status			varchar(50),
       dcn			integer,
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
       description   		text,
       parts_total_cost		numeric,
       assurance_total_cost	numeric,
       third_total_cost		numeric,
       mo_total_cost		numeric,
       total_cost		numeric
);

CREATE SEQUENCE cn_assurance_id_seq cache 1000; 

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
       integer,		   -- assurance_number
       timestamptz,	   -- assurance_date
       integer,		   -- service_order
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

