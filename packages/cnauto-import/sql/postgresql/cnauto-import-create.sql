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






CREATE TABLE cn_import_workflows (
       workflow_id		integer
       				CONSTRAINT cn_import_workflows_workflow_id_pk PRIMARY KEY,   
       name			varchar(255),
       pretty_name		varchar(255)
);


CREATE TABLE cn_import_departments (
       department_id		integer
       				CONSTRAINT cn_import_departments_department_id_pk PRIMARY KEY,   
       name			varchar(255),
       pretty_name		varchar(255)
);


  
------------------------------------
-- Table: cn_import_workflow_order_map
------------------------------------
 			 
CREATE TABLE cn_import_workflow_order_map (			  
       map_id		integer
       				CONSTRAINT cn_import_wo_map_id_pk PRIMARY KEY,       
       workflow_id		integer
				CONSTRAINT cn_import_wo_map_workflow_id_fk
				REFERENCES cn_import_workflows (workflow_id),
       order_id			integer
       				CONSTRAINT cn_import_wo_map_order_id_fk
       				REFERENCES cn_orders (order_id),
       assigner_id		integer
				CONSTRAINT cn_import_wo_map_assigner_id_fk
				REFERENCES acs_objects (object_id),
       assignee_id		integer
				CONSTRAINT cn_import_wo_map_assignee_id_fk
				REFERENCES acs_objects (object_id),
       department_id		integer
				CONSTRAINT cn_import_wo_map_department_id_fk
				REFERENCES cn_import_departments (department_id),     
       estimated_days		integer,
       estimated_date		timestamptz,
       executed_date		timestamptz
);



CREATE OR REPLACE FUNCTION cn_import_wo_map__new (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer, 	   -- order_id
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       integer,		   -- estimated_days
       timestamptz,	   -- estimated_date
       timestamptz	   -- executed_date
) RETURNS integer AS '
  DECLARE
	
  BEGIN
	INSERT INTO cn_import_workflow_order_map (
	       map_id,
	       workflow_id,
	       order_id,
	       assigner_id,
	       assignee_id,
	       department_id,
	       estimated_days,
	       estimated_date,
	       executed_date
	) VALUES (
	       p_map_id,
	       p_workflow_id,
	       p_order_id,
	       p_assigner_id,
	       p_assignee_id,
	       p_department_id,
	       p_estimated_days,
	       p_estimated_date,
	       p_executed_date
        );  
	
	RETURN 0;
  END;' language 'plpgsql';


CREATE OR REPLACE FUNCTION cn_import_wo_map__delete (
       integer		   -- map_id
) RETURNS integer AS '
  DECLARE
	p_map_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_import_workflow_order_map WHERE map_id = p_map_id;
	
	RETURN 0;
  END;' language 'plpgsql';



