-- /packages/cnauto-orders/sql/postgresql/cnauto-orders-create.sql

--
-- The CN Auto Import Package
--
-- @author Iuri Sampaio (iuri.sampaio@iurix.com)
-- @creation-date 2012-01-21
--



DROP FUNCTION cn_order__new (
       varchar,	  	   -- code
       integer,		   -- provider_id
       integer,		   -- workflow_id
       integer,		   -- incoterm_id
       varchar,		   -- incoterm_value
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
);

DROP FUNCTION cn_order__delete (
       integer		   -- order_id
);




------------------------------------
-- Object Type: cn_order
------------------------------------

SELECT acs_object_type__drop_type (
    'cn_order',      -- object_type
    't'
);

------------------------------------
-- Table: cn_orders
------------------------------------

DROP TABLE cn_orders CASCADE;

