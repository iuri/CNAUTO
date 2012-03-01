-- /packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.7d-0.8d.sql

SELECT acs_log__debug ('/packages/cnauto-assurance/sql/postgrersql/upgrade/upgrade-0.7d-0.8d.sql', '');

DROP FUNCTION cn_assurance__update_costs (
       integer,		   -- assurance_id
       text,		   -- description
       numeric,		   -- parts_total_cost
       numeric,		   -- assurance_total_cost
       numeric,		   -- third_total_cost
       numeric,		   -- mo_total_cost
       numeric		   -- total_cost	  
);

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
