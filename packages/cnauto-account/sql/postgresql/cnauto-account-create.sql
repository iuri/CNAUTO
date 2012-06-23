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
    nfe_id   	integer
    		CONSTRAINT cn_nfes_nfe_id_pk PRIMARY KEY,
    nfe_key 	varchar(255) NOT NULL,
    nfe_prot 	varchar(255),
    nfe_date	timestamptz
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



CREATE OR REPLACE FUNCTION cn_acoount_nfe__delete (integer) 
RETURNS integer AS '
  DECLARE
	p_nfe_id	ALIAS FOR $1;
  BEGIN

	DELETE FROM cn_nfes WHERE nfe_id = p_nfe_id;

	RETURN 0;
  END;' LANGUAGE 'plpgsql';





CREATE OR REPLACE FUNCTION cn_account_nfe__new (
       varchar,	  	   -- nfe_key
       varchar,	   	   -- nfe_prot
       timestamptz, 	   -- nfe_date
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
		  $4,			-- creation_user
		  $5,			-- cretion_ip
		  $6,			-- context_id
		  true			-- 
       );

	INSERT INTO cn_nfes (
	       nfe_id, 
	       nfe_key,
	       nfe_prot,
	       nfe_date
	) VALUES (
	  	 v_id,
		 $1,
		 $2,
		 $3
	);

	RETURN 0;
	
  END;' LANGUAGE 'plpgsql';
