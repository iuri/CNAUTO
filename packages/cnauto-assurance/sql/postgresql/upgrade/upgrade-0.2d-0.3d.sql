-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.2d-0.3d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.2d-0.3d.sql', '');



ALTER TABLE cn_assurances DROP COLUMN part_id;
ALTER TABLE cn_assurances DROP COLUMN part_quantity;
ALTER TABLE cn_assurances RENAME COLUMN damage_description TO description;
ALTER TABLE cn_assurances DROP COLUMN part_group;			

ALTER TABLE cn_assurances DROP COLUMN third_service;
ALTER TABLE cn_assurances DROP COLUMN cost_price;
ALTER TABLE cn_assurances DROP COLUMN assurance_price;
ALTER TABLE cn_assurances DROP COLUMN tmo_code;
ALTER TABLE cn_assurances DROP COLUMN tmo_duration;
ALTER TABLE cn_assurances DROP COLUMN cost;
ALTER TABLE cn_assurances DROP COLUMN ttl_sg;


ALTER TABLE cn_assurances DROP COLUMN person_id;
ALTER TABLE cn_assurances ADD COLUMN owner_id integer CONSTRAINT cn_assurances_owner_id_fk REFERENCES cn_persons (person_id);
ALTER TABLE cn_assurances ADD COLUMN distributor_id integer CONSTRAINT cn_assurances_distributor_id_fk REFERENCES cn_persons (person_id);

ALTER TABLE cn_assurances ADD COLUMN parts_total_cost numeric;
ALTER TABLE cn_assurances ADD COLUMN assurance_total_cost numeric;
ALTER TABLE cn_assurances ADD COLUMN third_total_cost numeric;
ALTER TABLE cn_assurances ADD COLUMN mo_total_cost numeric;
ALTER TABLE cn_assurances ADD COLUMN total_cost numeric;



------------------------------------
-- Table cn_assurance_part_requests
------------------------------------

CREATE TABLE cn_assurance_part_requests (
       map_id				    integer
       					    CONSTRAINT cn_aprm_map_id_pk PRIMARY KEY,
       assurance_id			    integer
					    CONSTRAINT cn_aprm_assurance_id_fk
					    REFERENCES cn_assurances (assurance_id),
       part_id				    integer
       					    CONSTRAINT cn_aprm_part_id_fk
					    REFERENCES cn_parts (part_id),
       part_group			    varchar(255),
       part_cost			    numeric,
       part_quantity			    integer,
       part_assurance_cost		    numeric,
       extra_incomes			    numeric,
       mo_code				    varchar(255),
       mo_time				    varchar(255),
       third_services_cost		    numeric
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
       integer,		   -- assurance_id
       integer,		   -- part_id              
       integer,		   -- part_group
       integer,		   -- part_quantity
       integer,		   -- part_assurance_cost
       integer,		   -- extra_incomes
       integer,		   -- mo_code
       integer,		   -- mo_time
       integer		   -- third_services_cost
) RETURNS integer AS '
  DECLARE
	p_map_id		ALIAS FOR $1;
       	p_assurance_id		ALIAS FOR $2;
       	p_part_id              	ALIAS FOR $3;
       	p_part_group		ALIAS FOR $4;
       	p_part_quantity		ALIAS FOR $5;
       	p_part_assurance_cost	ALIAS FOR $6;
       	p_extra_incomes		ALIAS FOR $7;
       	p_mo_code		ALIAS FOR $8;
       	p_mo_time		ALIAS FOR $9;
       	p_third_services_cost	ALIAS FOR $10;

  BEGIN
	
	INSERT INTO cn_assurance_part_requests (
	       map_id,
	       assurance_id,
	       part_id,              
	       part_group,
	       part_quantity,
	       part_assurance_cost,
	       extra_incomes,
	       mo_code,
	       mo_time,
	       third_services_cost
	) VALUES (
	       p_map_id,
	       p_assurance_id,
	       p_part_id,              
	       p_part_group,
	       p_part_quantity,
	       p_part_assurance_cost,
	       p_extra_incomes,
	       p_mo_code,
	       p_mo_time,
	       p_third_services_cost
	);

	RETURN p_map_id;

END;' LANGUAGE 'plpgsql';