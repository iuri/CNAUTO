-- /packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql

SELECT acs_log__debug ('/packages/cnauto-import/sql/postgresql/upgrade/upgrade-0.4d-0.5d.sql','');

DROP FUNCTION cn_workflow__new (
       integer,	  	   -- workflow_id
       varchar, 	   -- name
       varchar		   -- pretty_name
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
