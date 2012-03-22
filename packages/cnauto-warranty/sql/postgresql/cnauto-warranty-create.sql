-- /package/cnauto-warranty/sql/postgresql/cnauto-warranty-create.sql

--
-- The CN Auto Warranty Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-11-24
--


CREATE TABLE cn_warranties (
       warranty_id     integer
       		       CONSTRAINT cn_warranties_warranty_id_pk PRIMARY KEY,
       vehicle_id      integer
       		       CONSTRAINT cn_warranties_vehicle_id_fk
		       REFERENCES cn_vehicles (vehicle_id)
);

------------------------------------
-- Object Type: cn_warranty
------------------------------------

SELECT acs_object_type__create_type (
    'cn_warranty',	    -- object_type
    'CN Warranty',     	    -- pretty_name
    'CN Warranties',   	    -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_warranties',        -- table_name
    'warranty_id',   	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_warranty__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_warranty_id	ALIAS FOR $1;
  BEGIN

  	DELETE FROM cn_warranties WHERE warranty_id = p_warranty_id;
 
	PERFORM acs_object__delete(p_warranty_id); 

	RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_warranty__new (
       integer,	  -- vehicle_id
       varchar,	  -- creation_ip
       integer,	  -- creation_user
       integer	  -- context_id
) RETURNS integer AS '
  DECLARE
	p_vehicle_id	ALIAS FOR $1;
	p_creation_ip	ALIAS FOR $2;
	p_creation_user ALIAS FOR $3;
	p_context_id	ALIAS FOR $4;

	v_id		integer;
  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_warranty'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
        );


	INSERT INTO cn_warranties (
	       warranty_id,
	       vehicle_id
        ) VALUES (
	  v_id,
	  p_vehicle_id	
	);

	RETURN v_id;

  END;' LANGUAGE 'plpgsql';






------------------------------------
-- Table cn_claims
------------------------------------
CREATE SEQUENCE cn_claim_id_seq cache 1000; 
-- vin (vehicle identification number) - chassi
CREATE TABLE cn_claims (
       claim_id			integer 
       				CONSTRAINT cn_claims_claim_id_pk PRIMARY KEY,
       warranty_id		integer
       				CONSTRAINT cn_claims_warranty_id_fk
				REFERENCES cn_warranties (warranty_id),		
       claim_number		integer,
       claim_date		timestamptz,
       service_order		varchar(255), 
       service_order_date   	timestamptz,
       vehicle_id		integer
       				CONSTRAINT cn_claims_vehicle_id_fk
				REFERENCES cn_vehicles (vehicle_id) ON DELETE CASCADE,
       kilometers		numeric,
       status			varchar(50),
       owner_id			integer
       				CONSTRAINT cn_claims_owner_id_fk
				REFERENCES cn_persons (person_id) ON DELETE CASCADE,
       distributor_id		integer
       				CONSTRAINT cn_claims_distributor_id_fk
				REFERENCES cn_persons (person_id) ON DELETE CASCADE,
       description   		text,
       parts_total_cost		numeric,
       claim_total_cost		numeric,
       third_total_cost		numeric,
       mo_total_cost		numeric,
       total_cost		numeric
);


------------------------------------
-- Object Type: cn_claim
------------------------------------


SELECT acs_object_type__create_type (
    'cn_claim',		    -- object_type
    'CN Claim',     	    -- pretty_name
    'CN Claims',   	    -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_claims',            -- table_name
    'claim_id',   	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);




CREATE OR REPLACE FUNCTION cn_claim__new (
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
) RETURNS integer AS '
  DECLARE
	p_warranty_id		ALIAS FOR $1;
       	p_claim_number		ALIAS FOR $2;
       	p_claim_date		ALIAS FOR $3;
       	p_service_order		ALIAS FOR $4; 
       	p_service_order_date   	ALIAS FOR $5;
       	p_vehicle_id		ALIAS FOR $6;
        p_kilometers		ALIAS FOR $7;
 	p_status		ALIAS FOR $8;
	p_owner_id		ALIAS FOR $9;
	p_distributor_id	ALIAS FOR $10;
	p_creation_ip		ALIAS FOR $11;
	p_creation_user		ALIAS FOR $12;	
	p_context_id		ALIAS FOR $13;

	v_id			integer;

  BEGIN
	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_claim'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
        );


	INSERT INTO cn_claims (
	       claim_id,
	       warranty_id,
	       claim_number,
	       claim_date,
	       service_order, 
	       service_order_date,
	       vehicle_id,
	       kilometers,
	       status,
	       owner_id,
	       distributor_id
	) VALUES (
	       v_id,
	       p_warranty_id,
	       p_claim_number,
	       p_claim_date,
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


CREATE OR REPLACE FUNCTION cn_claim__edit (
       integer,		   -- claim_id
       integer,		   -- warranty_id       
       timestamptz,	   -- claim_date
       varchar,		   -- service_order
       integer,		   -- vehicle_id
       numeric,		   -- kilometers
       varchar,		   -- status
       integer,		   -- owner_id
       integer		   -- distributor_id	  
) RETURNS integer AS '
  DECLARE
       	p_claim_id		ALIAS FOR $1;
	p_warranty_id		ALIAS FOR $2;
      	p_claim_date		ALIAS FOR $3; 
       	p_service_order		ALIAS FOR $4;
        p_vehicle_id		ALIAS FOR $5;
	p_kilometers		ALIAS FOR $7;
	p_owner_id		ALIAS FOR $8;
	p_distributor_id	ALIAS FOR $9;

  BEGIN
	UPDATE cn_warranties SET	
	       claim_date = p_claim_date,
	       warranty_id = p_warranty_id,
	       service_order = p_service_order,
	       vehicle_id = p_vehicle_id,
	       kilometers = p_kilometers,
	       owner_id = p_owner_id,
	       distributor_id = p_distributor_id
	WHERE claim_id = p_claim_id;


	RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_claim__update_costs (
       integer,		   -- claim_id
       varchar,		   -- status
       text,		   -- description
       numeric,		   -- parts_total_cost
       numeric,		   -- claim_total_cost
       numeric,		   -- third_total_cost
       numeric,		   -- mo_total_cost
       numeric		   -- total_cost	  
) RETURNS integer AS '
  DECLARE
       	p_claim_id		ALIAS FOR $1;
	p_status		ALIAS FOR $2;
       	p_description		ALIAS FOR $3;
       	p_parts_total_cost	ALIAS FOR $4; 
       	p_claim_total_cost	ALIAS FOR $5;
        p_third_total_cost	ALIAS FOR $6;
	p_mo_total_cost		ALIAS FOR $7;
	p_total_cost		ALIAS FOR $8;


  BEGIN
	UPDATE cn_claims SET
	       status = p_status,
	       description = p_description,	
	       parts_total_cost = p_parts_total_cost,
	       claim_total_cost = p_claim_total_cost,
	       third_total_cost = p_third_total_cost,
	       mo_total_cost = p_mo_total_cost,
	       total_cost = p_total_cost
	WHERE claim_id = p_claim_id;


	RETURN 0;
  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_claim__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_claim_id	ALIAS FOR $1;
  BEGIN

  	DELETE FROM cn_claims WHERE claim_id = p_claim_id;
 
	PERFORM acs_object__delete(p_claim_id); 

	RETURN 0;
  END;' language 'plpgsql';





------------------------------------
-- Table cn_claim_part_requests
------------------------------------

CREATE TABLE cn_claim_part_requests (
       request_id		integer
				CONSTRAINT cn_cpr_request_id_pk PRIMARY KEY,
       claim_id			integer
       				CONSTRAINT cn_cpr_claim_id_fk
				REFERENCES cn_claims (claim_id),
       part_id			integer
       				CONSTRAINT cn_cpr_part_id_fk
				REFERENCES cn_parts (part_id),
       cost			numeric,
       quantity			integer,
       claim_cost		numeric,
       incomes			numeric,
       mo_code			varchar(255),
       mo_time			varchar(255),
       third_services_cost	numeric
);


------------------------------------
-- PL/SQL FUNCTIONS cn_aprm__new cn_aprm__delete
------------------------------------

CREATE OR REPLACE FUNCTION cn_cpr__delete (
       integer -- request_id
) RETURNS integer AS '
  DECLARE
    p_request_id	ALIAS FOR $1;

  BEGIN

    DELETE FROM cn_claim_part_requests WHERE request_id = p_request_id;

  RETURN 0;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_cpr__new (
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
) RETURNS integer AS '
  DECLARE
    p_request_id		ALIAS FOR $1;
    p_claim_id			ALIAS FOR $2;
    p_part_id           	ALIAS FOR $3;
    p_cost			ALIAS FOR $4;
    p_quantity			ALIAS FOR $5;
    p_claim_cost		ALIAS FOR $6;
    p_incomes			ALIAS FOR $7;
    p_mo_code		  	ALIAS FOR $8;
    p_mo_time			ALIAS FOR $9;
    p_third_services_cost	ALIAS FOR $10;

  BEGIN
  
	INSERT INTO cn_claim_part_requests (
               request_id,
	       claim_id,
	       part_id,
	       cost,              
	       quantity,
	       claim_cost,
	       incomes,
	       mo_code,
	       mo_time,
	       third_services_cost
	) VALUES (
	       p_request_id,
	       p_claim_id,
	       p_part_id,              
	       p_cost,
	       p_quantity,
	       p_claim_cost,
	       p_incomes,
	       p_mo_code,
	       p_mo_time,
	       p_third_services_cost
	);

	RETURN p_map_id;

END;' LANGUAGE 'plpgsql';


-- Create a file object to storage claim files using content repository
SELECT content_type__create_type (
       'claim_file_object',	 -- content_type
       'content_revision',       -- supertype. We search revision content 
                                 -- first, before item metadata
       'Claim File Object',  -- pretty_name
       'Claim File Objects', -- pretty_plural
       NULL,        -- table_name
       -- DAVEB: acs_object_types supports a null table name so we do that
       -- instead of passing a false value so we can actually use the
       -- content repository instead of duplicating all the code in file-storage
       NULL,	         -- id_column
       'claim_file__get_title' -- name_method
);
