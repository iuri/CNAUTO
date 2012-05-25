-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.26d-0.27d.sql


SELECT acs_log__debug('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.26d-0.27d.sql', '');


alter table cn_persons alter column cpf_cnpj TYPE varchar(30);