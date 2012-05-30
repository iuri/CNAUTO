-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.14d-0.15d.sql

SELECT acs_log__debug (' /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.14d-0.15d.sql','');


ALTER TABLE cn_import_orders ADD COLUMN fabricant_id integer;
ALTER TABLE cn_import_orders ADD CONSTRAINT cn_import_orders_fabricant_id_fk FOREIGN KEY (fabricant_id) REFERENCES cn_persons (person_id);


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
);


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
);


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
       integer,		   -- order_quantity
       timestamptz,	   -- numerary_date
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
	p_order_quantity	ALIAS FOR $14;
	p_numerary_date		ALIAS FOR $15;
	p_di_date 		ALIAS FOR $16;
	p_di_status		ALIAS FOR $17;
	p_di_number		ALIAS FOR $18;
	p_nf_date		ALIAS FOR $19;
	p_delivery_date		ALIAS FOR $20;
	p_incoterm_id 		ALIAS FOR $21;
	p_transport_type	ALIAS FOR $22;
	p_order_cost 		ALIAS FOR $23;
	p_exchange_rate_type 	ALIAS FOR $24;
	p_lc_number		ALIAS FOR $25;
	p_start_date 		ALIAS FOR $26;
	p_notes			ALIAS FOR $27;


BEGIN


	UPDATE cn_import_orders SET
	       cnimp_number = p_cnimp_number,
	       parent_id = p_parent_id,
	       provider_id = p_provider_id,
	       fabricant_id = p_fabricant_id,
	       cnimp_date = p_cnimp_date,
	       approval_date = p_approval_date, 
	       li_need_p = p_li_need_p,
	       payment_date = p_payment_date,
	       manufactured_date = p_manufactured_date,
	       departure_date = p_departure_date,
	       arrival_date = p_arrival_date,
	       awb_bl_number = p_awb_bl_number,
	       order_quantity = p_order_quantity,
	       numerary_date = p_numerary_date,
	       di_date = p_di_date,
	       di_status = p_di_status,
	       di_number = p_di_number,
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
