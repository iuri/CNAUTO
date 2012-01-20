-- /packages/cnauto-assurance/sql/postgresql/cnauto-import-create.sql

--
-- The CN Auto Assurance Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2011-11-24
--




------------------------------------
-- Table: cn_import_orders
------------------------------------

CREATE TABLE cn_import_orders (
       order_id		      integer
       			      CONSTRAINT cn_import_orders_order_id_pk PRIMARY KEY
			      CONSTRAINT cn_import_orders_order_id_fk
			      REFERENCES acs_objects (object_id),                
       code		      varchar(100)
       			      CONSTRAINT cn_import_orders_code_un UNIQUE,
       provider_id	      integer
       			      CONSTRAINT cn_import_orders_provider_id_fk
			      REFERENCES cn_persons (person_id),
       workflow_id	      integer
       			      CONSTRAINT cn_import_orders_workflow_id
			      REFERENCES cn_import_workflow (workflow_id),
       incoterm_id	      integer,
       incoterm_value	      varchar(255)
);

------------------------------------
-- Object Type: cn_import_order
------------------------------------

SELECT acs_object_type__create_type (
    'cn_import_order',      -- object_type
    'CN Import Order',      -- pretty_name
    'CN Import Orders',     -- pretty_plural
    'acs_object',     	    -- supertype
    'cn_import_orders',     -- table_name
    'order_id',   	    -- id_column
    null,		    -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_import_order__new (
       varchar,	  	   -- code
       integer,		   -- provider_id
       integer,		   -- workflow_id
       integer,		   -- incoterm_id
       varchar,		   -- incoterm_value
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
	p_code			ALIAS FOR $1;
	p_provider_id		ALIAS FOR $2;
	p_workflow_id		ALIAS FOR $3;
	p_incoterm_id		ALIAS FOR $4;
	p_incoterm_value	ALIAS FOR $5;
	p_creation_ip		ALIAS FOR $6;
	p_creation_user		ALIAS FOR $7;
	p_context_id		ALIAS FOR $8;

       	v_id			integer;

  BEGIN
	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_import_order'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
        );
	
	INSERTO INTO cn_import_orders (
		order_id,
		code,
		provider,
		workflow_id,
		incoterm_id,
		incoterm_value	
	) VALUES (
		v_id,
		p_code,
		p_provider,
		p_workflow_id,
		p_incoterm_id,

		p_incoterm_value	
	);

	RETURN v_id;

END;' language 'plpgsql';

CREATE OR REPLACE FUNCTION cn_import_order__delete (
       integer		   -- order_id
) RETURNS integer AS '
  DECLARE
	p_order_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_import_orders WHERE order_id = p_order_id;
	
	PERFORM acs_object__delete(p_order_id);

	RETURN 0;
  END;' language 'plpgsql';




------------------------------------
-- Table: cn_import_incoterms
------------------------------------

CREATE TABLE cn_import_incoterms (
       incoterm_id		 CONSTRAINT cn_import_inconterms_inconterm_id_pk PRIMARY KEY,
       name			 varchar(255)
       				 CONSTRAINT cn_import_incoterms_name_un UNIQUE,
       pretty_name		 varchar(255)
);






CREATE TABLE cn_import_workflow (
       workflow_id		integer
       				CONSTRAINT cn_import_workflow_workflow_id_pk PRIMARY KEY,   
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
				REFERENCES cn_import_workflow (workflow_id),
       order_id			integer
       				CONSTRAINT cn_import_wo_map_order_id_fk
       				REFERENCES cn_import_orders (order_id),
       assigner_id		integer
				CONSTRAINT cn_import_wo_map_assigner_id_fk
				REFERENCES acs_objects (user_id),
       assignee_id		integer
				CONSTRAINT cn_import_wo_map_assignee_id_fk
				REFERENCES acs_objects (user_id),
       department_id		integer
				CONSTRAINT cn_import_wo_map_department_id_fk
				REFERENCES cn_import_departments (department_id),     
       estimated_days		integer,
       estimated_date		timestamptz,
       executed_date		timestamptz, 
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



