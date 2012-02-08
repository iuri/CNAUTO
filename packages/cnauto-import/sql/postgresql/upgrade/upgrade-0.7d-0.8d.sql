-- /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.7d-0.8d.sql

SELECT acs_log__debug (' /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.7d-0.8d.sql','');


ALTER TABLE cn_workflow_steps DROP COLUMN order_id;
ALTER TABLE cn_workflow_steps DROP CONSTRAINT cn_workflow_steps_order_id_fk;

ALTER TABLE cn_workflow_steps DROP COLUMN assigner_id;
ALTER TABLE cn_workflow_steps DROP CONSTRAINT cn_workflow_steps_assigner_id_fk;

ALTER TABLE cn_workflow_steps DROP COLUMN assignee_id;
ALTER TABLE cn_workflow_steps DROP  CONSTRAINT cn_workflow_steps_assignee_id_fk;
				
ALTER TABLE cn_workflow_steps DROP COLUMN department_id;
ALTER TABLE cn_workflow_steps DROP CONSTRAINT cn_workflow_steps_department_id_fk;
     
ALTER TABLE cn_workflow_steps DROP COLUMN estimated_date;
ALTER TABLE cn_workflow_steps DROP COLUMN executed_date;

DROP FUNCTION cn_workflow_step__edit (
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
);





------------------------------------
-- Table: cn_workflow_step_order_map
------------------------------------

CREATE TABLE cn_workflow_step_order_map (
       map_id			integer
       				CONSTRAINT cn_wsom_map_ip_pk PRIMARY KEY,
       workflow_id		integer
       				CONSTRAINT cn_wsom_workflow_id_fk
				REFERENCES cn_workflows (workflow_id),   
       step_id		        integer
       				CONSTRAINT cn_wsom_step_id_fk 
				REFERENCES cn_workflow_steps (step_id),   
       order_id			integer
       				CONSTRAINT cn_wsom_order_id_fk
       				REFERENCES cn_orders (order_id),
       assigner_id		integer
				CONSTRAINT cn_wsom_assigner_id_fk
				REFERENCES acs_objects (object_id),
       assignee_id		integer
				CONSTRAINT cn_wsom_assignee_id_fk
				REFERENCES acs_objects (object_id),
       department_id		integer
				CONSTRAINT cn_wsom_department_id_fk
				REFERENCES cn_persons (person_id),     
       estimated_date		timestamptz,
       executed_date		timestamptz
);


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



CREATE OR REPLACE FUNCTION cn_wsom__edit (
       integer,	  	   -- map_id
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
	p_order_id		aLIAS FOR $4;
	p_assigner_id		ALIAS FOR $5;
	p_assignee_id		ALIAS FOR $6;
	p_department_id		ALIAS FOR $7;
	p_estimated_date	ALIAS FOR $8;
	p_executed_date		ALIAS FOR $9;

  BEGIN
	UPDATE cn_workflow_step_order_map SET 
	       workflow_id = p_workflow_id,
	       step_id = p_step_id,
	       order_id = p_order_id,
	       assigner_id = p_assigner_id,
	       assignee_id = p_assignee_id,
	       department_id = p_department_id,
	       estimated_date = p_estimated_date,
	       executed_date = p_executed_date
        WHERE map_id = p_map_id;  
	
	RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_wsom__delete (
       integer		   -- map_id
) RETURNS integer AS '
  DECLARE
	p_map_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_workflow_step_order_map WHERE map_id = p_map_id;
	
	RETURN 0;
  END;' language 'plpgsql';

