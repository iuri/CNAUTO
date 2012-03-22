-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.5d-0.6d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.5d-0.6d.sql', '');


ALTER TABLE cn_assurances DROP COLUMN dcn;
ALTER TABLE cn_assurances DROP COLUMN lp;
ALTER TABLE cn_assurances DROP COLUMN lp_date;
ALTER TABLE cn_assurances DROP COLUMN lp_2;
ALTER TABLE cn_assurances DROP COLUMN lp_2_date;



DROP  FUNCTION cn_assurance__edit (
       integer,		   -- assurance_id
       timestamptz,	   -- assurance_date
       integer,		   -- service_order
       integer,		   -- vehicle_id
       numeric		   -- kilometers	  
); 


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
       text,		   -- description
       numeric,		   -- parts_total_cost
       numeric,		   -- assurance_total_cost
       numeric,		   -- third_total_cost
       numeric,		   -- mo_total_cost
       numeric		   -- total_cost	  
) RETURNS integer AS '
  DECLARE
       	p_assurance_id		ALIAS FOR $1;
       	p_description		ALIAS FOR $2;
       	p_parts_total_cost	ALIAS FOR $3; 
       	p_assurance_total_cost	ALIAS FOR $4;
        p_third_total_cost	ALIAS FOR $5;
	p_mo_total_cost		ALIAS FOR $6;
	p_total_cost		ALIAS FOR $7;


  BEGIN
	UPDATE cn_assurances SET	
	       parts_total_cost = p_parts_total_cost,
	       assurance_total_cost = p_assurance_total_cost,
	       third_total_cost = p_third_total_cost,
	       mo_total_cost = p_third_toal_cost,
	       total_cost = p_total_cost
	WHERE assurance_id = p_assurance_id;


	RETURN 0;
  END;' language 'plpgsql';



DROP FUNCTION cn_aprm__new (
       integer,	  	   -- map_id
       integer,	      	   -- assurance_id
       integer,		   -- part_id              
       integer,		   -- part_group
       integer,		   -- part_quantity
       integer,		   -- part_assurance_cost
       integer,		   -- extra_incomes
       integer,		   -- mo_code
       integer,		   -- mo_time
       integer		   -- third_services_cost
);



DROP TABLE cn_assurance_part_requests;



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

CREATE OR REPLACE FUNCTION cn_aprm__delete (
       integer -- map_id
) RETURNS integer AS '
  DECLARE
  p_map_id	ALIAS FOR $1;

  BEGIN

  DELETE FROM cn_assurance_part_requests WHERE map_id = p_map_id;

  RETURN 0;
  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_aprm__new (
       integer,	  	   -- map_id
       integer,	      	   -- assurance_id
       integer,		   -- part_id              
       numeric,		   -- cost
       integer,		   -- quantity
       numeric,		   -- assurance_cost
       numeric,		   -- incomes
       integer,		   -- mo_code
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

