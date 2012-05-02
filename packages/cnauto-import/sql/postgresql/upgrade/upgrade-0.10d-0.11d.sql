-- /packages/cnauto-import/sql/postgtresql/upgrade/upgrade-0.10d-0.11d.sql

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
