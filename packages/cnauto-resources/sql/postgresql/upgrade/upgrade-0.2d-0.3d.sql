-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.2d-0.3d.sql','');


ALTER TABLE cn_persons DROP CONSTRAINT cn_persons_person_id_fk;

ALTER TABLE cn_persons DROP COLUMN first_names;
ALTER TABLE cn_persons DROP COLUMN last_name;

ALTER TABLE cn_persons ADD COLUMN legal_name varchar(100);
ALTER TABLE cn_persons ADD COLUMN pretty_name varchar(100);
ALTER TABLE cn_persons ADD COLUMN code varchar(10);

ALTER TABLE cn_persons ADD COLUMN contact_id integer;
ALTER TABLE cn_persons ADD CONSTRAINT cn_persons_contact_id_fk FOREIGN KEY (contact_id) REFERENCES acs_objects (object_id);





DROP FUNCTION cn_person__new (
       varchar,	  	   -- cpf_cnpj
       varchar,	  	   -- first_names
       varchar,		   -- last_name
       varchar,		   -- email
       varchar,		   -- type
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_code
       varchar,		   -- city_code
       varchar,		   -- country_code
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
);



CREATE OR REPLACE FUNCTION cn_person__new (
       varchar,	  	   -- cpf_cnpj
       varchar,	  	   -- legal_name
       varchar,		   -- pretty_name
       varchar,		   -- code
       varchar,		   -- type
       integer,		   -- contact_id
       varchar,		   -- email
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_code
       integer,		   -- city_code
       varchar,		   -- country_code
       varchar,		   -- creation_ip
       integer,		   -- creation_user
       integer		   -- context_id
) RETURNS integer AS '
  DECLARE
	p_cpf_cnpj		ALIAS FOR $1;
	p_legal_name		ALIAS FOR $2;
	p_corporate_name	ALIAS FOR $3;
	p_code			ALIAS FOR $4;
	p_type			ALIAS FOR $5;
	p_email			ALIAS FOR $6;
	p_contact_id		ALIAS FOR $7;
       	p_phone		   	ALIAS FOR $8;
       	p_postal_address    	ALIAS FOR $9;
       	p_postal_address2   	ALIAS FOR $10;
       	p_postal_code 	   	ALIAS FOR $11;
       	p_state_code 	   	ALIAS FOR $12;    		    	 
       	p_city_code 	   	ALIAS FOR $13;
       	p_country_code 	   	ALIAS FOR $14;
	p_creation_ip		ALIAS FOR $15;
       	p_creation_user		ALIAS FOR $16;
       	p_context_id		ALIAS FOR $17;

       	v_id	integer;		
       	v_type	varchar;

  BEGIN

       v_id := acs_object__new (
       		  null,			-- object_id
		  ''cn_person'',	-- object_type
		  now(),		-- creation_date
		  p_creation_user,	-- creation_user
		  p_creation_ip,	-- cretion_ip
		  p_context_id,		-- context_id
		  true			-- 
       );


       INSERT INTO cn_persons (
       	      person_id,
	      cpf_cnpj,
	      legal_name,
	      corporate_name,
	      code,
	      type,
	      contact_id,
	      email,
	      phone,
	      postal_address,
	      postal_address2,
	      postal_code,
	      state_code,
	      city_code,
	      country_code
	) VALUES (
	  v_id,
	  p_cpf_cnpj,
	  p_legal_name,
	  p_corporate_name,
	  p_code,
	  p_type,
	  p_contact_id,
	  p_email,
       	  p_phone,
       	  p_postal_address,
       	  p_postal_address2,
       	  p_postal_code,
       	  p_state_code,    		    	 
       	  p_city_code,
       	  p_country_code
	);

	RETURN v_id;

END;' language 'plpgsql';

