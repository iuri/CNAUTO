-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.6d-0.7d.sql

SELECT acs_log__debug (' /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.6d-0.7d.sql','');

ALTER TABLE cn_workflow_steps DROP COLUMN estimated_days;

DROP FUNCTION cn_workflow_step__edit (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar,		   -- pretty_name
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       integer,		   -- estimatyed_days
       timestamptz,	   -- estimated_date
       timestamptz,	   -- executed_date
       integer		   -- sort_order
);



CREATE OR REPLACE FUNCTION cn_workflow_step__edit (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar,		   -- pretty_name
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       timestamptz,	   -- estimated_date
       timestamptz,	   -- executed_date
       integer		   -- sort_order
) RETURNS integer AS '
  DECLARE
	p_step_id		ALIAS FOR $1;
	p_workflow_id		ALIAS FOR $2;
	p_name			ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;
	p_assigner_id		ALIAS FOR $5;
	p_assignee_id		ALIAS FOR $6;
	p_department_id		ALIAS FOR $7;
	p_estimated_date	ALIAS FOR $8;
	p_executed_date		ALIAS FOR $9;
	p_sort_order		ALIAS FOR $10;

  BEGIN
	UPDATE cn_workflow_steps SET 
	       workflow_id = p_workflow_id,
	       name = p_name,
	       pretty_name = p_pretty_name,
	       assigner_id = p_assigner_id,
	       assignee_id = p_assignee_id,
	       department_id = p_department_id,
	       estimated_date = p_estimated_date,
	       executed_date = p_executed_date,
	       sort_order = p_sort_order
        WHERE step_id = p_step_id;  
	
	RETURN 0;
  END;' language 'plpgsql';

