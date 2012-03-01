-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.11d-0.12d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.11d-0.12d.sql','');

CREATE OR REPLACE FUNCTION cn_person__edit (
       integer,	  	   -- person_id
       varchar,	  	   -- cpf_cnpj
       varchar,	  	   -- legal_name
       varchar,		   -- pretty_name
       varchar,		   -- code
       integer,		   -- type_id
       integer,		   -- contact_id
       varchar,		   -- email
       varchar,		   -- phone
       varchar,		   -- postal_address
       varchar,		   -- postal_address2
       varchar,		   -- postal_code
       varchar,		   -- state_code
       integer,		   -- city_code
       varchar		   -- country_code
) RETURNS integer AS '
  DECLARE
	p_person_id		ALIAS FOR $1;
	p_cpf_cnpj		ALIAS FOR $2;
	p_legal_name		ALIAS FOR $3;
	p_pretty_name		ALIAS FOR $4;
	p_code			ALIAS FOR $5;
	p_type_id		ALIAS FOR $6;
	p_contact_id		ALIAS FOR $7;
	p_email			ALIAS FOR $8;
       	p_phone		   	ALIAS FOR $9;
       	p_postal_address    	ALIAS FOR $10;
       	p_postal_address2   	ALIAS FOR $11;
       	p_postal_code 	   	ALIAS FOR $12;
       	p_state_code 	   	ALIAS FOR $13;    		    	 
       	p_city_code 	   	ALIAS FOR $14;
       	p_country_code 	   	ALIAS FOR $15;

  BEGIN

       UPDATE cn_persons SET 
	      cpf_cnpj = p_cpf_cnpj,
	      legal_name = p_legal_name,
	      pretty_name = p_pretty_name,
	      code = p_code,
	      type_id = p_type_id,
	      contact_id = p_contact_id,
	      email = p_email,
	      phone = p_phone,
	      postal_address = p_postal_address,
	      postal_address2 = p_postal_address2,
	      postal_code = p_postal_code,
	      state_code = p_state_code,
	      city_code = p_city_code,
	      country_code = p_country_code
	WHERE person_id = p_person_id;

	RETURN 0;
END;' language 'plpgsql';

