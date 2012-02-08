-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.15d-0.16d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.15d-0.16d.sql','');


ALTER TABLE cn_persons ADD CONSTRAINT cn_persons_person_id_fk FOREIGN KEY (type_id) REFERENCES cn_categories (category_id);
