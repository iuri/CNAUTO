-- /packages/cnauto-assurance/sql/postgresql/cnauto-import-create.sql

--
-- The CN Auto Import Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--


------------------------------------
-- Table: cn_import_orders
------------------------------------


CREATE TABLE cn_import_orders (
       order_id		      integer
       			      CONSTRAINT cn_import_orders_order_id_pk PRIMARY KEY
			      CONSTRAINT cn_import_orders_order_id_fk
			      REFERENCES acs_objects (object_id),
       cnimp_number	      varchar,
       parent_id	      integer
       			      CONSTRAINT cn_import_orders_parent_id_fk
			      REFERENCES cn_import_orders (order_id),
       provider_id	      integer
       			      CONSTRAINT cn_import_orders_provider_id_fk
			      REFERENCES cn_persons (person_id),
       fabricant_id	      integer
       			      CONSTRAINT cn_import_orders_fabricant_id_fk
			      REFERENCES cn_persons (person_id),			      
       cnimp_date	      timestamptz,
       approval_date	      timestamptz,
       li_need_p	      boolean,
       payment_date	      timestamptz,
       manufactured_date      timestamptz,
       departure_date	      timestamptz,
       arrival_date	      timestamptz,
       order_quantity	      integer,
       awb_bl_number	      varchar,
       numerary_date	      timestamptz,
       di_date 		      timestamptz,
       di_status	      varchar,
       di_number	      varchar
       nf_date		      timestamptz,
       delivery_date	      timestamptz,
       incoterm_id 	      integer,
       transport_type	      varchar,
       order_cost	      varchar, 
       exchange_rate_type     varchar,
       lc_number	      varchar,
       start_date	      timestamptz, 	      
       notes		      text
);

------------------------------------
-- Object Type: cn_import_order
------------------------------------

SELECT acs_object_type__create_type (
    'cn_import_order',      -- object_type
    'CN Import Order',      -- pretty_name
    'CN Import Orders',     -- pretty_plural
    'acs_object',    	    -- supertype
    'cn_import_orders',     -- table_name
    'order_id',      	    -- id_column
    null,	     	    -- name_method
    'f',
    null,
    null
);




CREATE OR REPLACE FUNCTION cn_import_order__delete (
       integer		   -- order_id
) RETURNS integer AS '
  DECLARE
	p_order_id			ALIAS FOR $1;

  BEGIN 

	
	PERFORM acs_object__delete(p_order_id);

	DELETE FROM cn_import_orders WHERE order_id = p_order_id;

	RETURN 0;
  END;' language 'plpgsql';




CREATE OR REPLACE FUNCTION cn_import_order__new (
       varchar,	  	   -- cnimp_number
       integer,   	   -- parent_id
       integer,	  	   -- provider_id
       integer,	  	   -- fabricant_id
       timestamptz, 	   -- cnimp_date
       timestamptz,        -- approval_date 
       boolean,		   -- li_need_p
       timestamptz,	   -- payment_date
       timestamptz,	   -- manufactured_date
       timestamptz,	   -- departure_date
       timestamptz,	   -- arrival_date
       varchar,	   	   -- awb_bl_number
       integer,  	   -- order_quantity
       timestamptz,   	   -- numerary_date
       timestamptz,    	   -- di_date 
       varchar,    	   -- di_status
       varchar,		   -- di_number
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
) RETURNS integer AS '
  DECLARE
  
	p_cnimp_number		ALIAS FOR $1;
	p_parent_id		ALIAS FOR $2;
	p_provider_id		ALIAS FOR $3;
	p_fabricant_id		ALIAS FOR $4;
       	p_cnimp_date		ALIAS FOR $5;
	p_approval_date		ALIAS FOR $6; 
	p_li_need_p		ALIAS FOR $7;
	p_payment_date		ALIAS FOR $8;
	p_manufactured_date	ALIAS FOR $9;
	p_departure_date	ALIAS FOR $10;
	p_arrival_date		ALIAS FOR $11;
	p_awb_bl_number		ALIAS FOR $12;
	p_order_quantity	ALIAS FOR $13;
	p_numerary_date		ALIAS FOR $14;
	p_di_date 		ALIAS FOR $15;
	p_di_status		ALIAS FOR $16;
	p_di_number		ALIAS FOR $17;
	p_nf_date		ALIAS FOR $18;
	p_delivery_date		ALIAS FOR $19;
	p_incoterm_id 		ALIAS FOR $20;
	p_transport_type	ALIAS FOR $21;
	p_order_cost 		ALIAS FOR $22;
	p_exchange_rate_type 	ALIAS FOR $23;
	p_lc_number		ALIAS FOR $24;
	p_start_date 		ALIAS FOR $25;
	p_notes			ALIAS FOR $26;
	p_creation_ip		ALIAS FOR $27;
	p_creation_user		ALIAS FOR $28;
	p_context_id		ALIAS FOR $29;

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
	


	INSERT INTO cn_import_orders (
	       order_id,	
	       cnimp_number,
	       parent_id,
	       provider_id,
	       fabricant_id,
	       cnimp_date,
	       approval_date, 
	       li_need_p,
	       payment_date,
	       manufactured_date,
	       departure_date,
	       arrival_date,
	       awb_bl_number,
	       order_quantity,
	       numerary_date,
	       di_date,
	       di_status,
	       di_number,
	       nf_date,
	       delivery_date,
	       incoterm_id,
	       transport_type,
	       order_cost,
	       exchange_rate_type, 
	       lc_number,
	       start_date, 
	       notes
	) VALUES (
	  v_id,	
	  p_cnimp_number,
	  p_parent_id,
	  p_provider_id,
	  p_fabricant_id,
	  p_cnimp_date,
	  p_approval_date, 
	  p_li_need_p,
	  p_payment_date,
	  p_manufactured_date,
	  p_departure_date,
	  p_arrival_date,
	  p_awb_bl_number,
	  p_order_quantity,
	  p_numerary_date,
	  p_di_date,
	  p_di_status,
	  p_di_number,
	  p_nf_date,
	  p_delivery_date,
	  p_incoterm_id,
	  p_transport_type,
	  p_order_cost, 
	  p_exchange_rate_type, 
	  p_lc_number,
	  p_start_date, 
	  p_notes
	);

	RETURN v_id;

  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_import_order__edit (
       integer,	  	   -- order_id
       varchar,	  	   -- cnimp_number
       integer,   	   -- parent_id
       integer,	  	   -- provider_id
       integer,		   -- fabricant_id
       timestamptz, 	   -- cnimp_date
       timestamptz,        -- approval_date 
       boolean,		   -- li_need_p
       timestamptz,	   -- payment_date
       timestamptz,	   -- manufactured_date
       timestamptz,	   -- departure_date
       timestamptz,	   -- arrival_date
       varchar,	   	   -- awb_bl_number
       timestamptz,	   -- numerary_date
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
) RETURNS integer AS '
  DECLARE
	p_order_id		ALIAS FOR $1;
	p_cnimp_number		ALIAS FOR $2;
	p_parent_id		ALIAS FOR $3;
	p_provider_id		ALIAS FOR $4;
	p_fabricant_id		ALIAS FOR $5;
       	p_cnimp_date		ALIAS FOR $6;
	p_approval_date		ALIAS FOR $7; 
	p_li_need_p		ALIAS FOR $8;
	p_payment_date		ALIAS FOR $9;
	p_manufactured_date	ALIAS FOR $10;
	p_departure_date	ALIAS FOR $11;
	p_arrival_date		ALIAS FOR $12;
	p_awb_bl_number		ALIAS FOR $13;
	p_numerary_date		ALIAS FOR $14;
	p_di_date 		ALIAS FOR $15;
	p_di_status		ALIAS FOR $16;
	p_nf_date		ALIAS FOR $17;
	p_delivery_date		ALIAS FOR $18;
	p_incoterm_id 		ALIAS FOR $19;
	p_transport_type	ALIAS FOR $20;
	p_order_cost 		ALIAS FOR $21;
	p_exchange_rate_type 	ALIAS FOR $22;
	p_lc_number		ALIAS FOR $23;
	p_start_date 		ALIAS FOR $24;
	p_notes			ALIAS FOR $25;


BEGIN


	UPDATE cn_import_orders SET
	       cnimp_number = p_cnimp_number,
	       parent_id = p_parent_id,
	       provider_id = p_provider_id,
	       fabricant_id = p_fabricant_id,
	       cnimp_date = p_cnimp_date,
	       approval_date =p_approval_date, 
	       li_need_p = p_li_need_p,
	       payment_date = p_payment_date,
	       manufactured_date = p_manufactured_date,
	       departure_date = p_departure_date,
	       arrival_date = p_arrival_date,
	       awb_bl_number = p_awb_bl_number,
	       numerary_date = p_numerary_date,
	       di_date = p_di_date,
	       di_status = p_di_status,
	       nf_date = p_nf_date,
	       delivery_date = p_delivery_date,
	       incoterm_id = p_incoterm_id,
	       transport_type = p_transport_type,
	       order_cost = p_order_cost,
	       exchange_rate_type = p_exchange_rate_type, 
	       lc_number = p_lc_number,
	       start_date = p_start_date, 
	       notes = p_notes
	WHERE order_id = p_order_id;

	RETURN 0;

  END;' LANGUAGE 'plpgsql';
















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
       				REFERENCES cn_import_orders (order_id),
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
       			REFERENCES cn_import_orders (order_id)
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



