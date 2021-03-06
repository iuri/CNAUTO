-- /packages/cnauto-account/sql/postgresql/cnauto-account-create.sql

--
-- The CN Auto Account Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-06-21
--

------------------------------------
-- Table: cn_nfes
------------------------------------
CREATE TABLE cn_nfes (
    nfe_id		integer
    		     	CONSTRAINT cn_nfes_nfe_id_pk PRIMARY KEY,
    key 	     	varchar(255) NOT NULL,
    prot 	     	varchar(255),
    date	     	timestamptz
    number	     	varchar(255),
    serie	     	varchar(255),
    status	     	varchar(255),
    motive		varchar(255),
    total	     	varchar(255),
    nat_op 		varchar(255),
    remitter_cnpj    	varchar(255),
    remitter_name	varchar(255),
    remitter_state_reg 	varchar(255),
    remittee_cnpj	varchar(255),
    remittee_name	varchar(255),
    remittee_state_reg  varchar(255)        
);


------------------------------------
-- Object Type: cn_nfe
------------------------------------

SELECT acs_object_type__create_type (
    'cn_nfe',         -- object_type
    'CN NFE',         -- pretty_name
    'CN NFEs', 	      -- pretty_plural
    'acs_object',     -- supertype
    'cn_nfes',        -- table_name
    'nfe_id',         -- id_column
    null,	      -- name_method
    'f',
    null,
    null
);



CREATE OR REPLACE FUNCTION cn_account_nfe__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_nfe_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_nfes WHERE nfe_id = p_nfe_id;

	PERFORM acs_object__delete (p_nfe_id);

	RETURN 0;
  END;' LANGUAGE 'plpgsql';




-------------------
-- Authorized NFes
-------------------
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
