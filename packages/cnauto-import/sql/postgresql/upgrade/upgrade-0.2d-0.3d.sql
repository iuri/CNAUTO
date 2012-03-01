-- /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql

 
------------------------------------
-- Table: cn_workflows
------------------------------------
CREATE TABLE cn_workflows (
       workflow_id		integer
       				CONSTRAINT cn_workflows_workflow_id_pk PRIMARY KEY,   
       name			varchar(255),
       pretty_name		varchar(255)
);



CREATE OR REPLACE FUNCTION cn_workflow__new (
       integer,	  	   -- workflow_id
       varchar, 	   -- name
       varchar		   -- pretty_name
) RETURNS integer AS '
  DECLARE
	p_workflow_id		ALIAS FOR $1;
	p_name			ALIAS FOR $2;
	p_pretty_name		ALIAS FOR $3;

  BEGIN
	INSERT INTO cn_workflows (
	       workflow_id,
	       name,
	       pretty_name
	) VALUES (
	       p_workflow_id,
	       p_name,
	       p_pretty_name
        );  
	
	RETURN 0;
  END;' language 'plpgsql';

  
 			 
CREATE OR REPLACE FUNCTION cn_workflow__delete (
       integer		   -- workflow_id
) RETURNS integer AS '
  DECLARE
	p_workflow_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_workflows WHERE workflow_id = p_workflow_id;
	
	RETURN 0;
  END;' language 'plpgsql';


------------------------------------
-- Table: cn_workflow_steps
------------------------------------
CREATE TABLE cn_workflow_steps (
       step_id		       integer
       				CONSTRAINT cn_workflow_steps_step_id_pk PRIMARY KEY,   
       workflow_id		integer
       				CONSTRAINT cn_workflow_steps_workflow_id_fk
				REFERENCES cn_workflows (workflow_id),   
       name			varchar(255),
       pretty_name		varchar(255),
       assigner_id		integer
				CONSTRAINT cn_workflow_steps_assigner_id_fk
				REFERENCES acs_objects (object_id),
       assignee_id		integer
				CONSTRAINT cn_workflow_steps_assignee_id_fk
				REFERENCES acs_objects (object_id),
       department_id		integer
				CONSTRAINT cn_workflow_steps_department_id_fk
				REFERENCES cn_persons (person_id),     
       estimated_days		integer,
       estimated_date		timestamptz,
       executed_date		timestamptz,
       sort_order		integer
);


CREATE OR REPLACE FUNCTION cn_workflow_step__new (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar		   -- pretty_name
) RETURNS integer AS '
  DECLARE
	p_step_id		ALIAS FOR $1;
	p_workflow_id		ALIAS FOR $2;
	p_name			ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;

  BEGIN
	INSERT INTO cn_workflow_steps (
	       step_id,
	       workflow_id,
	       name,
	       pretty_name
	) VALUES (
	       p_step_id,
	       p_workflow_id,
	       p_name,
	       p_pretty_name
        );  
	
	RETURN 0;
  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_workflow_step__edit (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar,		   -- pretty_name
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       integer,		   -- estimated_days
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
	p_estimated_days	ALIAS FOR $8;
	p_estimated_date	ALIAS FOR $9;
	p_executed_date		ALIAS FOR $10;
	p_sort_order		ALIAS FOR $11;

  BEGIN
	UPDATE cn_workflow_steps SET 
	       workflow_id = p_workflow_id,
	       name = p_name,
	       pretty_name = p_pretty_name,
	       assigner_id = p_assigner_id,
	       assignee_id = p_assignee_id,
	       department_id = p_department_id,
	       estimated_days = p_estimated_days,
	       estimated_date = p_estimated_date,
	       executed_date = p_executed_date,
	       sort_order = p_sort_order
        WHERE step_id = p_step_id;  
	
	RETURN 0;
  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_workflow_step__delete (
       integer		   -- step_id
) RETURNS integer AS '
  DECLARE
	p_step_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_workflow_steps WHERE step_id = p_step_id;
	
	RETURN 0;
  END;' language 'plpgsql';






  
------------------------------------
-- Table: cn_workflow_order_map
------------------------------------
CREATE TABLE cn_workflow_order_map (
       map_id		integer
       			CONSTRAINT cn_wo_map_id_pk PRIMARY KEY,       
       workflow_id	integer
			CONSTRAINT cn_wo_map_workflow_id_fk
			REFERENCES cn_workflows (workflow_id),
       order_id		integer
       			CONSTRAINT cn_wo_map_order_id_fk
       			REFERENCES cn_orders (order_id)
);

CREATE OR REPLACE FUNCTION cn_workflow_order_map__new (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer		   -- order_id
) RETURNS integer AS '
  DECLARE
	
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

 			 
CREATE OR REPLACE FUNCTION cn_workflow_order_map__delete (
       integer		   -- map_id
) RETURNS integer AS '
  DECLARE
	p_map_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_workflow_order_map WHERE map_id = p_map_id;
	
	RETURN 0;
  END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
  DECLARE
	v_workflow_id	integer;

  BEGIN
	
	SELECT acs_object_id_seq.nextval INTO v_workflow_id FROM dual;
  
	INSERT INTO cn_workflows (
	       workflow_id,
	       name,
	       pretty_name
	) VALUES (
	       v_workflow_id,
	       ''importorder'',
	       ''Import Order''
	);

	RETURN 0;

  END;' language 'plpgsql';

SELECT inline_0 ();
DROP FUNCTION inline_0 ();

CREATE OR REPLACE FUNCTION inline_0 ()
RETURNS integer AS '
  DECLARE
	v_step_id	integer;
	v_workflow_id 	integer;
	row	  	record;
  BEGIN
	

	-- SELECT nextval(''t_acs_object_id_seq'') INTO v_step_id;

	SELECT workflow_id INTO v_workflow_id FROM cn_workflows WHERE name = ''importorder'';

	FOR row IN
	    SELECT name, pretty_name, sort_order FROM cn_import_workflows
	
	LOOP
		SELECT acs_object_id_seq.nextval INTO v_step_id FROM dual;

		INSERT INTO cn_workflow_steps (
		       step_id,
		       workflow_id,
		       name,
		       pretty_name,
		       sort_order
		) VALUES (
		  	 v_step_id,
			 v_workflow_id,
			 row.name,
			 row.pretty_name,
			 row.sort_order
		);
	END LOOP;

	RETURN 0;  

  END;' language 'plpgsql';


SELECT inline_0 ();
DROP FUNCTION inline_0 ();


DROP FUNCTION cn_import_wo_map__new (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer, 	   -- order_id
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       integer,		   -- estimated_days
       timestamptz,	   -- estimated_date
       timestamptz	   -- executed_date
);


DROP FUNCTION cn_import_wo_map__delete (
       integer		   -- map_id
);


DROP TABLE cn_import_workflows CASCADE;

DROP TABLE cn_import_departments CASCADE;


------------------------------------
-- Table: cn_import_workflow_order_map
------------------------------------
 			 
DROP TABLE cn_import_workflow_order_map;


