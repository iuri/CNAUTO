-- /packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql

SELECT acs_log__debug ('/packages/cnauto-orders/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql','');


DROP FUNCTION cn_order__new (
       varchar,	  	   -- code
       integer,		   -- provider_id
       integer,		   -- incoterm_id
       varchar,		   -- incoterm_value
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
);





CREATE OR REPLACE FUNCTION cn_order__new (
       varchar,	  	   -- code
       integer,		   -- type_id
       integer,		   -- provider_id
       integer,		   -- incoterm_id
       varchar,		   -- incoterm_value
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
	p_creation_ip		ALIAS FOR $6;
	p_creation_user		ALIAS FOR $7;
	p_context_id		ALIAS FOR $8;

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
		incoterm_value	
	) VALUES (
		v_id,
		p_code,
		p_type_id,
		p_provider_id,
		p_incoterm_id,
		p_incoterm_value	
	);

	RETURN v_id;

END;' language 'plpgsql';