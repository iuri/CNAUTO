-- /packages/cnauto-resources/sql/postgresql/upgrade-0.1d-0.2d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade-0.1d-0.2d.sql','');



ALTER TABLE cn_persons RENAME COLUMN state_abbrev TO state_code;
ALTER TABLE cn_persons DROP CONSTRAINT cn_assurances_state_abbrev_fk;
ALTER TABLE cn_persons ADD CONSTRAINT cn_persons_state_code_fk FOREIGN KEY (state_code) REFERENCES br_states (abbrev);

ALTER TABLE cn_persons DROP CONSTRAINT cn_assurances_country_code_fk;
ALTER TABLE cn_persons ADD CONSTRAINT cn_persons_country_code_fk FOREIGN KEY (country_code) REFERENCES countries (iso),

ALTER TABLE cn_persons RENAME COLUMN municipality TO city_code;

ALTER TABLE cn_persons DROP COLUMN city_code RESTRICT;
ALTER TABLE cn_persons ADD COLUMN city_code integer;

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
       varchar,	  	   -- first_names
       varchar,		   -- last_name
       varchar,		   -- email
       varchar,		   -- type
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
	p_first_names		ALIAS FOR $2;
	p_last_name		ALIAS FOR $3;
	p_email			ALIAS FOR $4;
	p_type			ALIAS FOR $5;
       	p_phone		   	ALIAS FOR $6;
       	p_postal_address    	ALIAS FOR $7;
       	p_postal_address2   	ALIAS FOR $8;
       	p_postal_code 	   	ALIAS FOR $9;
       	p_state_code 	   	ALIAS FOR $10;    		    	 
       	p_city_code 	   	ALIAS FOR $11;
       	p_country_code 	   	ALIAS FOR $12;
	p_creation_ip		ALIAS FOR $13;
       	p_creation_user		ALIAS FOR $14;
       	p_context_id		ALIAS FOR $15;

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
	      first_names,
	      last_name,
	      email,
	      type,
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
	  p_first_names,
	  p_last_name,
	  p_email,
	  p_type,
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
