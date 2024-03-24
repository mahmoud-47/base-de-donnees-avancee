--1 
CREATE OR REPLACE FUNCTION cat()
RETURNS SETOF VARCHAR AS $$
    DECLARE
        nom VARCHAR;
    BEGIN
        FOR nom IN SELECT tablename FROM pg_tables WHERE tableowner = 'postgres' LOOP
            RETURN next nom;
        END LOOP;
        RETURN;
    END;
$$ language plpgsql;

--2
CREATE TYPE tNuplet AS (texte VARCHAR, nombre INT);

CREATE OR REPLACE FUNCTION catPlus()
RETURNS SETOF tNuplet AS $$
    DECLARE
        ligne tNuplet;
        nom VARCHAR;
    BEGIN
        FOR nom IN SELECT tablename FROM pg_tables WHERE tableowner = 'postgres' AND tablename not like 'pg_%' AND tablename not like 'sql_%' LOOP
            ligne.texte := nom;
            EXECUTE 'SELECT count(*) FROM ' || nom INTO ligne.nombre;
            RETURN next ligne;
        END LOOP;
        RETURN;
    END;
$$ language plpgsql;
