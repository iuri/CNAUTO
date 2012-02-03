-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.8d-0.9d.sql

SELECT acs_log__debug (' /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.8d-0.9d.sql','');

CREATE OR REPLACE FUNCTION cn_wsom__new (
       integer,   	   -- map_id	  
       integer,		   -- workflow_id
       integer,	  	   -- step_id
       integer,		   -- order_id
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       timestamptz,	   -- estimated_date
       timestamptz	   -- executed_date
) RETURNS integer AS '
  DECLARE
	p_map_id		ALIAS FOR $1;
	p_workflow_id		ALIAS FOR $2;
	p_step_id		ALIAS FOR $3;
	p_order_id		ALIAS FOR $4;
	p_assigner_id		ALIAS FOR $5;
	p_assignee_id		ALIAS FOR $6;
	p_department_id		ALIAS FOR $7;
	p_estimated_date	ALIAS FOR $8;
	p_executed_date		ALIAS FOR $9;

  BEGIN
	INSERT INTO cn_workflow_step_order_map ( 
	       map_id, 			       
	       workflow_id,
	       step_id,
	       order_id,
	       assigner_id,
	       assignee_id,
	       department_id,
	       estimated_date,
	       executed_date
	 ) VALUES (
	       p_map_id,
	       p_workflow_id,
	       p_step_id, 
	       p_order_id,
	       p_assigner_id,
	       p_assignee_id,
	       p_department_id,
	       p_estimated_date,
	       p_executed_date
	  );  
	
	RETURN 0;
  END;' language 'plpgsql';
