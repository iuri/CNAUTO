-- /packages/cnauto-assurance/sql/postgresql/cnauto-import-create.sql

--
-- The CN Auto Import Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--


------------------------------------
-- Table: cn_import_incoterms
------------------------------------

CREATE TABLE cn_import_incoterms (
       incoterm_id		 integer 
       				 CONSTRAINT cn_import_inconterms_inconterm_id_pk PRIMARY KEY,
       name			 varchar(255)
       				 CONSTRAINT cn_import_incoterms_name_un UNIQUE,
       pretty_name		 varchar(255)
);



 
------------------------------------
-- Table: cn_workflows
------------------------------------
CREATE TABLE cn_workflows (
       workflow_id		integer
       				CONSTRAINT cn_workflows_workflow_id_pk PRIMARY KEY,   
       name			varchar(255),
       pretty_name		varchar(255),
       package_id		integer
       				CONSTRAINT cn_workflows_workflow_id_fk 
				REFERENCES apm_packages (package_id)
);



CREATE OR REPLACE FUNCTION cn_workflow__new (
       integer,	  	   -- workflow_id
       integer,		   -- package_id
       varchar, 	   -- name
       varchar		   -- pretty_name
) RETURNS integer AS '
  DECLARE
	p_workflow_id		ALIAS FOR $1;
	p_package_id		ALIAS FOR $2;
	p_name			ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;

  BEGIN
	INSERT INTO cn_workflows (
	       workflow_id,
	       package_id,
	       name,
	       pretty_name
	) VALUES (
	       p_workflow_id,
	       p_package_id,
	       p_name,
	       p_pretty_name
        );  
	
	RETURN 0;
  END;' language 'plpgsql';




CREATE OR REPLACE FUNCTION cn_workflow__edit (
       integer,	  	   -- workflow_id
       integer,		   -- package_id
       varchar, 	   -- name
       varchar		   -- pretty_name
) RETURNS integer AS '
  DECLARE
	p_workflow_id		ALIAS FOR $1;
	p_package_id		ALIAS FOR $2;
	p_name			ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;

  BEGIN
	UPDATE cn_workflows SET 
	       package_id = p_package_id,
	       name = p_name,
	       pretty_name = pretty_name
	WHERE workflow_id = p_workflow_id;  
	
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
       integer		   -- sort_order
) RETURNS integer AS '
  DECLARE
	p_step_id		ALIAS FOR $1;
	p_workflow_id		ALIAS FOR $2;
	p_name			ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;
	p_sort_order		ALIAS FOR $5;

  BEGIN
	UPDATE cn_workflow_steps SET 
	       workflow_id = p_workflow_id,
	       name = p_name,
	       pretty_name = p_pretty_name,
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

 			 
CREATE OR REPLACE FUNCTION cn_workflow_order_map__delete (
       integer		   -- map_id
) RETURNS integer AS '
  DECLARE
	p_map_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_workflow_order_map WHERE map_id = p_map_id;
	
	RETURN 0;
  END;' language 'plpgsql';



