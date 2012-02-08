-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.9d-0.10d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.9d-0.10d.sql','');

ALTER TABLE cn_persons DROP CONSTRAINT cn_persons_cpf_cnpj_un;