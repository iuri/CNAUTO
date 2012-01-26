-- /packages/cnauto-assurance/sql/postgresql/upgrade/upgrade-0.3d-0.4d.sql

 
ALTER TABLE cn_workflows ADD COLUMN package_id integer;

ALTER TABLE cn_workflows ADD CONSTRAINT cn_workflows_package_id_fk FOREIGN KEY (package_id) REFERENCES apm_packages (package_id);