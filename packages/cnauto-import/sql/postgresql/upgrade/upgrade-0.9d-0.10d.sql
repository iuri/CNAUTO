-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.9d-0.10d.sql

SELECT acs_log__debug (' /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.9d-0.10d.sql','');

CREATE OR REPLACE FUNCTION cn_workflow_order_map__new (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer		   -- order_id
) RETURNS integer AS '
  DECLARE
	p_map_id			ALIAS FOR $1;
	p_worflow_id			ALIAS FOR $2;
	p_order_id			ALIAS FOR $3;
	
  BEGIN
	INSERT INTO cn_workflow_order_map (
	       map_id,
	       workflow_id,
	       order_id
	) VALUES (
	       p_map_id,
	       p_workflow_id,
	       p_order_id
        );  
	
	RETURN 0;
  END;' language 'plpgsql';
