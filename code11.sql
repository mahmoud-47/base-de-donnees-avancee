CREATE TYPE tNuplet AS (texte VARCHAR, nombre INT);

CREATE OR REPLACE FUNCTION LES_PRODUITS()
RETURNS SETOF tNuplet AS $$
    DECLARE
        curprod REFCURSOR;
        ligne tNuplet;
    BEGIN
        OPEN curprod FOR EXECUTE 'SELECT nomproduit, prix FROM produit';
        FETCH curprod INTO ligne;
        WHILE FOUND LOOP
            RETURN NEXT ligne;
            FETCH curprod INTO ligne;
        END LOOP;
        CLOSE curprod;
        RETURN;
    END;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION LES_PRODUITS_V1()
RETURNS SETOF tNuplet AS $$
    DECLARE
        curprod REFCURSOR;
        ligne tNuplet;
    BEGIN
        OPEN curprod FOR EXECUTE 'SELECT nomproduit, prix FROM produit ORDER BY prix DESC LIMIT 5';
        FETCH curprod INTO ligne;
        WHILE FOUND LOOP
            RETURN NEXT ligne;
            FETCH curprod INTO ligne;
        END LOOP;
        CLOSE curprod;
        RETURN;
    END;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION LES_PRODUITS_V2()
RETURNS SETOF tNuplet AS $$
    DECLARE
        curprod REFCURSOR;
        ligne tNuplet;
        compt INT := 0;
    BEGIN
        OPEN curprod FOR EXECUTE 'SELECT nomproduit, prix FROM produit ORDER BY prix DESC';
        FETCH curprod INTO ligne;
        WHILE FOUND AND compt <5 LOOP
            RETURN NEXT ligne;
            FETCH curprod INTO ligne;
            compt := compt+1;
        END LOOP;
        CLOSE curprod;
        RETURN;
    END;
$$ language plpgsql;