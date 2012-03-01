-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.6d-0.7d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.6d-0.7d.sql', '');


DROP FUNCTION cn_aprm__new (
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
);

DROP FUNCTION cn_aprm__delete (
       integer -- map_id
);

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
       varchar,		   -- mo_time
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
	       mo_total_cost = p_mo_total_cost,
	       total_cost = p_total_cost
	WHERE assurance_id = p_assurance_id;


	RETURN 0;
  END;' language 'plpgsql';
