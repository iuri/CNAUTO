-- /packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.16d-0.17d.sql

SELECT acs_log__debug ('/packages/cnauto-resources/sql/postgresql/upgrade/upgrade-0.16d-0.17d.sql','');

ALTER TABLE cn_resources DROP COLUMN class; 

ALTER TABLE cn_resources ADD COLUMN class_id integer;

ALTER TABLE cn_resources ADD CONSTRAINT cn_resources_class_id_fk FOREIGN KEY (class_id) REFERENCES cn_categories (category_id);
