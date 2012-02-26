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


CREATE OR REPLACE FUNCTION cn_assurance__edit (
       integer,		   -- assurance_id
       timestamptz,	   -- assurance_date
       varchar,		   -- service_order
       integer,		   -- vehicle_id
       numeric,		   -- kilometers
       integer,		   -- owner_id
       integer		   -- distributor_id	  
) RETURNS integer AS '
  DECLARE
       	p_assurance_id		ALIAS FOR $1;
       	p_assurance_date	ALIAS FOR $2; 
       	p_service_order		ALIAS FOR $3;
        p_vehicle_id		ALIAS FOR $4;
	p_kilometers		ALIAS FOR $5;
	p_owner_id		ALIAS FOR $6;
	p_distributor_id	ALIAS FOR $7;

  BEGIN
	UPDATE cn_assurances SET	
	       assurance_date = p_assurance_date,
	       service_order = p_service_order,
	       vehicle_id = p_vehicle_id,
	       kilometers = p_kilometers,
	       owner_id = p_owner_id,
	       distributor_id = p_distributor_id
	WHERE assurance_id = p_assurance_id;


	RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_assurance__update_costs (
       integer,		   -- assurance_id
       varchar,		   -- status
       text,		   -- description
       numeric,		   -- parts_total_cost
       numeric,		   -- assurance_total_cost
       numeric,		   -- third_total_cost
       numeric,		   -- mo_total_cost
       numeric		   -- total_cost	  
) RETURNS integer AS '
  DECLARE
       	p_assurance_id		ALIAS FOR $1;
	p_status		ALIAS FOR $2;
       	p_description		ALIAS FOR $3;
       	p_parts_total_cost	ALIAS FOR $4; 
       	p_assurance_total_cost	ALIAS FOR $5;
        p_third_total_cost	ALIAS FOR $6;
	p_mo_total_cost		ALIAS FOR $7;
	p_total_cost		ALIAS FOR $8;


  BEGIN
	UPDATE cn_assurances SET
	       status = p_status,
	       description = p_description,	
	       parts_total_cost = p_parts_total_cost,
	       assurance_total_cost = p_assurance_total_cost,
	       third_total_cost = p_third_total_cost,
	       mo_total_cost = p_mo_total_cost,
	       total_cost = p_total_cost
	WHERE assurance_id = p_assurance_id;


	RETURN 0;
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





------------------------------------
-- Table cn_assurance_part_requests
------------------------------------

CREATE TABLE cn_assurance_part_requests (
       map_id				integer
					CONSTRAINT cn_aprm_map_id_pk PRIMARY KEY,
       assurance_id			integer
       					CONSTRAINT cn_aprm_assurance_id_fk
					REFERENCES cn_assurances (assurance_id),
       part_id				integer
       					CONSTRAINT cn_aprm_part_id_fk
					REFERENCES cn_parts (part_id),
       cost				numeric,
       quantity				integer,
       assurance_cost			numeric,
       incomes				numeric,
       mo_code				varchar(255),
       mo_time				varchar(255),
       third_services_cost		numeric
);


------------------------------------
-- PL/SQL FUNCTIONS cn_aprm__new cn_aprm__delete
------------------------------------

CREATE OR REPLACE FUNCTION cn_apr__delete (
       integer -- map_id
) RETURNS integer AS '
  DECLARE
    p_map_id	ALIAS FOR $1;

  BEGIN

    DELETE FROM cn_assurance_part_requests WHERE map_id = p_map_id;

  RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_apr__new (
       integer,	  	   -- map_id
       integer,	      	   -- assurance_id
       integer,		   -- part_id              
       numeric,		   -- cost
       integer,		   -- quantity
       numeric,		   -- assurance_cost
       numeric,		   -- incomes
       varchar,		   -- mo_code
       integer,		   -- mo_time
       numeric		   -- third_services_cost
) RETURNS integer AS '
  DECLARE
    p_map_id			ALIAS FOR $1;
    p_assurance_id		ALIAS FOR $2;
    p_part_id           	ALIAS FOR $3;
    p_cost			ALIAS FOR $4;
    p_quantity			ALIAS FOR $5;
    p_assurance_cost		ALIAS FOR $6;
    p_incomes			ALIAS FOR $7;
    p_mo_code		  	ALIAS FOR $8;
    p_mo_time			ALIAS FOR $9;
    p_third_services_cost	ALIAS FOR $10;

  BEGIN
  
	INSERT INTO cn_assurance_part_requests (
               map_id,
	       assurance_id,
	       part_id,
	       cost,              
	       quantity,
	       assurance_cost,
	       incomes,
	       mo_code,
	       mo_time,
	       third_services_cost
	) VALUES (
	       p_map_id,
	       p_assurance_id,
	       p_part_id,              
	       p_cost,
	       p_quantity,
	       p_assurance_cost,
	       p_incomes,
	       p_mo_code,
	       p_mo_time,
	       p_third_services_cost
	);

	RETURN p_map_id;

END;' LANGUAGE 'plpgsql';


-- Create a file object to storage assurance files using content repository
SELECT content_type__create_type (
       'assurance_file_object',	 -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'Assurance File Object',  -- pretty_name
       'Assurance File Objects', -- pretty_plural
       NULL,        -- table_name
       -- DAVEB: acs_object_types supports a null table name so we do that
       -- instead of passing a false value so we can actually use the
       -- content repository instead of duplicating all the code in file-storage
       NULL,	         -- id_column
       'assurance_file__get_title' -- name_method
);
