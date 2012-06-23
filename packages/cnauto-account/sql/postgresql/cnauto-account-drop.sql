-- /packages/cnauto-account/sql/postgresql/cnauto-account-drop.sql

--
-- DROP CN AUTO Account Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-06-21
--




DROP FUNCTION cn_acoount_nfe__delete (integer);

DROP FUNCTION cn_account_nfe__new (
       varchar,	  	   -- nfe_key
       varchar,	   	   -- nfe_prot
       timestamptz, 	   -- nfe_date
       integer,		   -- creation_user
       varchar, 	   -- creation_ip
       integer		   -- context_id
);



------------------------------------
-- Object Type: cn_nfe
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_nfe',         -- object_type
    't'
);


------------------------------------
-- Table: cn_nfes
------------------------------------
DROP TABLE cn_nfes;



