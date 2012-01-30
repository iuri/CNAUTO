-- /packages/cnauto-orders/sql/postgresql/cnauto-orders-create.sql

--
-- The CN Auto Import Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--



------------------------------------
-- Table: cn_orders
------------------------------------

CREATE TABLE cn_orders (
       order_id		      integer
       			      CONSTRAINT cn_orders_order_id_pk PRIMARY KEY
			      CONSTRAINT cn_orders_order_id_fk
			      REFERENCES acs_objects (object_id),
       code		      varchar(100)
       			      CONSTRAINT cn_orders_code_un UNIQUE,
       type_id		      integer
       			      CONSTRAINT cn_orders_type_id_fk
			      REFERENCES cn_categories (category_id),
       parent_id	      integer
       			      CONSTRAINT cn_orders_parent_id_fk
			      REFERENCES cn_orders (order_id),
       provider_id	      integer
       			      CONSTRAINT cn_orders_provider_id_fk
			      REFERENCES cn_persons (person_id),
       incoterm_id	      integer,
       incoterm_value	      varchar(255),
       estimated_days	      integer,
       enabled_p	      boolean default 't'
);

------------------------------------
-- Object Type: cn_import_order
------------------------------------

SELECT acs_object_type__create_type (
    'cn_order',      -- object_type
    'CN Order',      -- pretty_name
    'CN Orders',     -- pretty_plural
    'acs_object',    -- supertype
    'cn_orders',     -- table_name
    'order_id',      -- id_column
    null,	     -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_order__new (
       varchar,	  	   -- code
       integer,		   -- type_id
       integer,		   -- provider_id
       integer,		   -- incoterm_id
       varchar,		   -- incoterm_value
       integer,		   -- estimated_days
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
	p_code			ALIAS FOR $1;
	p_type_id		ALIAS FOR $2;
	p_provider_id		ALIAS FOR $3;
	p_incoterm_id		ALIAS FOR $4;
	p_incoterm_value	ALIAS FOR $5;
	p_estimated_days	ALIAS FOR $6;
	p_creation_ip		ALIAS FOR $7;
	p_creation_user		ALIAS FOR $8;
	p_context_id		ALIAS FOR $9;

       	v_id			integer;

  BEGIN
	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_order'',		-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
        );
	
	INSERT INTO cn_orders (
		order_id,
		code,
		type_id,
		provider_id,
		incoterm_id,
		incoterm_value,
		estimated_days
	) VALUES (
		v_id,
		p_code,
		p_type_id,
		p_provider_id,
		p_incoterm_id,
		p_incoterm_value,
		p_estimated_days	
	);

	RETURN v_id;

END;' language 'plpgsql';



CREATE OR REPLACE FUNCTION cn_order__delete (
       integer		   -- order_id
) RETURNS integer AS '
  DECLARE
	p_order_id			ALIAS FOR $1;

  BEGIN

	DELETE FROM cn_orders WHERE order_id = p_order_id;
	
	PERFORM acs_object__delete(p_order_id);

	RETURN 0;
  END;' language 'plpgsql';
