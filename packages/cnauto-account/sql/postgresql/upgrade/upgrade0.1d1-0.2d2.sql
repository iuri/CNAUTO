-- /packages/cnauto-account/sql/postgresql/upgrade/upgrade-0.1d1-0.1d2..sql

--
-- The CN Auto Account Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-06-23
--
SELECT acs_log__debug ('/packages/cnauto-account/sql/postgresql/upgrade/upgrade-0.1d1-0.2d2.sql','');

ALTER TABLE cn_nfes RENAME COLUMN nfe_key TO key;
ALTER TABLE cn_nfes RENAME COLUMN nfe_prot TO prot;
ALTER TABLE cn_nfes RENAME COLUMN nfe_date TO date;
ALTER TABLE cn_nfes ADD COLUMN number varchar(255);
ALTER TABLE cn_nfes ADD COLUMN serie varchar(255);
ALTER TABLE cn_nfes ADD COLUMN status varchar(255);
ALTER TABLE cn_nfes ADD COLUMN motive varchar(255);
ALTER TABLE cn_nfes ADD COLUMN total varchar(255);
ALTER TABLE cn_nfes ADD COLUMN nat_op varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remitter_cnpj varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remitter_name varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remitter_state_reg varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remittee_cnpj varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remittee_name varchar(255);
ALTER TABLE cn_nfes ADD COLUMN remittee_state_reg varchar(255);



DROP FUNCTION cn_acoount_nfe__delete (integer) ;

CREATE OR REPLACE FUNCTION cn_account_nfe__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_nfe_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_nfes WHERE nfe_id = p_nfe_id;

	PERFORM acs_object__delete (p_nfe_id);

	RETURN 0;
  END;' LANGUAGE 'plpgsql';


DROP FUNCTION cn_account_nfe__new (
       varchar,	  	   -- nfe_key
       varchar,	   	   -- nfe_prot
       timestamptz, 	   -- nfe_date
       integer,		   -- creation_user
       varchar, 	   -- creation_ip
       integer		   -- context_id
);




CREATE OR REPLACE FUNCTION cn_account_nfe__new (
       varchar,	  	   -- key
       varchar,	   	   -- prot
       timestamptz, 	   -- date
       varchar, 	   -- number
       varchar,		   -- serie
       varchar,		   -- status
       varchar,		   -- motive
       varchar,		   -- total
       varchar,		   -- nat_op
       varchar,		   -- remitter_cnpj
       varchar,		   -- remitter_name
       varchar,		   -- remitter_state_reg
       varchar,		   -- remittee_cnpj
       varchar,		   -- remittee_name
       varchar,		   -- remittee_state_reg
       integer,		   -- creation_user
       varchar, 	   -- creation_ip
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
  	v_id		integer;
  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_nfe'',		-- object_type
		  now(),		-- creation_date
		  $16,			-- creation_user
		  $17,			-- cretion_ip
		  $18,			-- context_id
		  true			-- 
       );

	INSERT INTO cn_nfes (
	       nfe_id, 
	       key,
	       prot,
	       date,
	       number,
	       serie,
	       status,
	       motive,
	       nat_op,
	       total,
	       remitter_cnpj,
	       remitter_name,
	       remitter_state_reg,
	       remittee_cnpj,
	       remittee_name,
	       remittee_state_reg
	) VALUES (
	  	 v_id,
		 $1,
		 $2,
		 $3,
		 $4,
		 $5,
		 $6,
		 $7,
		 $8,
		 $9,
		 $10,
		 $11,
		 $12,
		 $13,
		 $14,
		 $15		 
	);

	RETURN v_id;
	
  END;' LANGUAGE 'plpgsql';



-------------------
-- Canceled NFes
-------------------

CREATE OR REPLACE FUNCTION cn_account_nfe__new (
       varchar,	  	   -- key
       varchar,	   	   -- prot
       timestamptz, 	   -- date
       varchar,		   -- status
       varchar,		   -- motive
       integer,		   -- creation_user
       varchar, 	   -- creation_ip
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
  	v_id		integer;
  BEGIN

	v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_nfe'',		-- object_type
		  now(),		-- creation_date
		  $16,			-- creation_user
		  $17,			-- cretion_ip
		  $18,			-- context_id
		  true			-- 
       );

	INSERT INTO cn_nfes (
	       nfe_id, 
	       key,
	       prot,
	       date,
	       status,
	       motive
	) VALUES (
	  	 v_id,
		 $1,
		 $2,
		 $3,
		 $4,
		 $5,
		 $6
	);

	RETURN v_id;
	
  END;' LANGUAGE 'plpgsql';



CREATE OR REPLACE FUNCTION cn_account_nfe__cancel_nfe (
       varchar,	  	   -- key
       varchar,	   	   -- prot
       timestamptz, 	   -- date
       varchar,		   -- status
       varchar,		   -- motive
       integer,		   -- creation_user
       varchar, 	   -- creation_ip
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
  	v_id		integer;
  BEGIN

	UPDATE cn_nfes SET 
	       prot = $2,
	       date = $3,
	       status = $4,
	       motive = $5
	WHERE key = $1;

	RETURN 0;
	
  END;' LANGUAGE 'plpgsql';
