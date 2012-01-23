-- /packages/cnauto-import/sql/postgresql/cnauto-import-drop.sql


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


DROP TABLE cn_import_incoterms;

DROP TABLE cn_import_workflows;

DROP TABLE cn_import_departments;


------------------------------------
-- Table: cn_import_workflow_order_map
------------------------------------
 			 
DROP TABLE cn_import_workflow_order_map;
