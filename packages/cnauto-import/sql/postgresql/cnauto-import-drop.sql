-- /packages/cnauto-import/sql/postgresql/cnauto-import-create.sql

--
-- The CN Auto Import Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--






  
------------------------------------
-- Table: cn_workflow_step_order_map
------------------------------------

DROP FUNCTION cn_wsom__new (
       integer,   	   -- map_id	  
       integer,		   -- workflow_id
       integer,	  	   -- step_id
       integer,		   -- order_id
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       timestamptz,	   -- estimated_date
       timestamptz	   -- executed_date
);




DROP FUNCTION cn_wsom__edit (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer,	  	   -- step_id
       integer,		   -- order_id
       integer,		   -- assigner_id
       integer,		   -- assignee_id
       integer,		   -- department_id
       timestamptz,	   -- estimated_date
       timestamptz	   -- executed_date
);


DROP FUNCTION cn_wsom__delete (
       integer		   -- map_id
);


DROP TABLE cn_workflow_step_order_map;




------------------------------------
-- Table: cn_workflow_steps
------------------------------------
DROP TABLE cn_workflow_steps;


DROP FUNCTION cn_workflow_step__new (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar		   -- pretty_name
);


DROP FUNCTION cn_workflow_step__edit (
       integer,	  	   -- step_id
       integer,		   -- workflow_id
       varchar, 	   -- name
       varchar,		   -- pretty_name
       integer		   -- sort_order
);


DROP FUNCTION cn_workflow_step__delete (
       integer		   -- step_id
);







  
------------------------------------
-- Table: cn_workflow_order_map
------------------------------------
DROP TABLE cn_workflow_order_map;

DROP FUNCTION cn_workflow_order_map__new (
       integer,	  	   -- map_id
       integer,		   -- workflow_id
       integer		   -- order_id
);

 			 
DROP FUNCTION cn_workflow_order_map__delete (
       integer		   -- map_id
);





------------------------------------
-- Table: cn_import_incoterms
------------------------------------

DROP TABLE cn_import_incoterms;



 
------------------------------------
-- Table: cn_workflows
------------------------------------
DROP TABLE cn_workflows CASCADE;



DROP FUNCTION cn_workflow__new (
       integer,	  	   -- workflow_id
       integer,		   -- package_id
       varchar, 	   -- name
       varchar		   -- pretty_name
);


DROP FUNCTION cn_workflow__edit (
       integer,	  	   -- workflow_id
       integer,		   -- package_id
       varchar, 	   -- name
       varchar		   -- pretty_name
);

  
 			 
DROP FUNCTION cn_workflow__delete (
       integer		   -- workflow_id
);




SELECT acs_object_type__drop_type (
    'cn_import_order',      -- object_type
    't'
);


DROP TABLE cn_import_orders;

DROP FUNCTION cn_import_order__delete (
       integer		   -- order_id
);


DROP FUNCTION cn_import_order__new (
       varchar,	  	   -- cnimp_number
       integer,   	   -- parent_id
       integer,	  	   -- provider_id
       timestamptz, 	   -- cnimp_date
       timestamptz,        -- approval_date 
       boolean,		   -- li_need_p
       timestamptz,	   -- payment_date
       timestamptz,	   -- manufactured_date
       timestamptz,	   -- departure_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- awb_bl_number
       varchar,	   	   -- numerary_date
       timestamptz,    	   -- di_date 
       varchar,    	   -- di_status
       timestamptz,	   -- nf_date
       timestamptz,	   -- delivery_date
       integer,	   	   -- incoterm_id 
       varchar,	   	   -- transport_type
       varchar,		   -- order_cost 
       varchar,		   -- exchange_rate_type 
       varchar,		   -- lc_number
       timestamptz,	   -- start_date 
       text,		   -- notes
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
);


DROP FUNCTION cn_import_order__edit (
       integer,	  	   -- order_id
       varchar,	  	   -- cnimp_number
       integer,   	   -- parent_id
       integer,	  	   -- provider_id
       timestamptz, 	   -- cnimp_date
       timestamptz,        -- approval_date 
       boolean,		   -- li_need_p
       timestamptz,	   -- payment_date
       timestamptz,	   -- manufactured_date
       timestamptz,	   -- departure_date
       timestamptz,	   -- arrival_date
       timestamptz,	   -- awb_bl_number
       varchar,	   	   -- numerary_date
       timestamptz,    	   -- di_date 
       varchar,    	   -- di_status
       timestamptz,	   -- nf_date
       timestamptz,	   -- delivery_date
       integer,	   	   -- incoterm_id 
       varchar,	   	   -- transport_type
       varchar,		   -- order_cost 
       varchar,		   -- exchange_rate_type 
       varchar,		   -- lc_number
       timestamptz,	   -- start_date 
       text		   -- notes
);
