--1
--a ajouter l attribut emprunte
ALTER TABLE livres
ADD COLUMN emprunte BOOLEAN;

-- b 
UPDATE livres l
SET emprunte = Exists(SELECT * FROM  emprunter WHERE NL=L.NL AND dateret is NULL);

-- c 
-- creons un trigger qui verifie si le livre n est pas emprunte, et actualise l attribut
CREATE OR REPLACE FUNCTION avant_emprunt() 
RETURNS TRIGGER AS $$
    DECLARE 
        borrowed BOOLEAN;
    BEGIN
        IF EXISTS(SELECT * FROM emprunter WHERE NL=NEW.NL AND dateret is NULL) THEN
            RAISE EXCEPTION 'Ce livre est deja emprunte';
        END IF;
        
        IF NEW.dateRet IS NULL THEN
            UPDATE Livres 
            SET emprunte = TRUE
            WHERE NL = NEW.NL;
        END IF;

        RETURN NEW;
    END;
$$ language plpgsql;

DROP TRIGGER if exists tr_avant_emprunt ON emprunter;
CREATE TRIGGER tr_avant_emprunt
BEFORE INSERT ON emprunter
FOR EACH ROW EXECUTE PROCEDURE avant_emprunt();

-- creons un trigger qui verifie si le livre est emprunte, et actualise l attribut
CREATE OR REPLACE FUNCTION apres_emprunt()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Livres
        SET emprunte = EXISTS(SELECT * FROM emprunter WHERE NL=OLD.NL AND dateret is NULL)
        WHERE NL=OLD.NL;
        RETURN NULL;
    END;
$$ language plpgsql;

DROP TRIGGER if exists tr_apres_emprunt ON emprunter;
CREATE TRIGGER tr_apres_emprunt
AFTER DELETE OR UPDATE ON emprunter
FOR EACH ROW EXECUTE PROCEDURE apres_emprunt();

--d 
ALTER TABLE emprunter
ADD COLUMN dureeEmprunt INTEGER;

--e
UPDATE emprunter
SET dureeEmprunt = dateRet - datemp
WHERE dateRet IS NOT NULL;

--f
CREATE OR REPLACE FUNCTION set_duree()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.dateret IS NOT NULL THEN
            NEW.dureeEmprunt = NEW.dateret - OLD.datemp;
        END IF;
        RETURN NEW;
    END;
$$ language plpgsql;

DROP TRIGGER IF EXISTS tr_set_duree ON emprunter;
CREATE TRIGGER tr_set_duree
BEFORE UPDATE ON emprunter
FOR EACH ROW EXECUTE PROCEDURE set_duree();

--g
ALTER TABLE emprunter
ALTER COLUMN datemp SET DEFAULT current_date;

--h
CREATE OR REPLACE FUNCTION noms_format()
RETURNS TRIGGER AS $$
    BEGIN
        NEW.prenom = initcap(NEW.prenom);
        NEW.nom = LOWER(NEW.nom);
        RETURN NEW;
    END;
$$ language plpgsql;

DROP TRIGGER IF EXISTS tr_noms_format ON adherents;
CREATE TRIGGER tr_noms_format
BEFORE INSERT OR UPDATE ON adherents
FOR EACH ROW EXECUTE PROCEDURE noms_format();

-- i deja fait

-- j 
CREATE OR REPLACE FUNCTION Emprunt_3_fois()
RETURNS TRIGGER AS $$
    DECLARE
        nb INT;
    BEGIN
        SELECT COUNT(*) INTO nb 
        FROM emprunter
        WHERE NA = NEW.NA;

        IF nb > 2 THEN
            RAISE EXCEPTION 'Borrowing more than 3 times is forbidden';
        END IF;

        RETURN NEW;
    END;
$$ language plpgsql;


CREATE TRIGGER tr_Emprunt_3_fois
BEFORE INSERT ON emprunter
FOR EACH ROW EXECUTE PROCEDURE Emprunt_3_fois();

-- k
CREATE OR REPLACE FUNCTION date_retour()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.dateret <= NEW.datemp THEN
            RAISE EXCEPTION 'Date incorrecte';
        END IF;
        NEW.dateret = current_date;
        RETURN NEW;
    END;
$$ language plpgsql;

CREATE TRIGGER tr_date_retour
BEFORE UPDATE ON emprunter
FOR EACH ROW EXECUTE PROCEDURE date_retour();

-- 2 a
CREATE OR REPLACE FUNCTION retard(NA_IN INT)
RETURNS INT AS $$
    DECLARE 
        nb_emprunts INT;
        ret INT;
    BEGIN
        SELECT COUNT(*) INTO nb_emprunts
        FROM emprunter 
        WHERE NA = NA_IN
        AND dateret IS NULL;

        IF nb_emprunts = 0 THEN
            RETURN NULL;
        END IF;

        IF EXISTS(SELECT * FROM emprunter WHERE NA = NA_IN AND dateret-datemp < 0) THEN
            SELECT MIN(dateret-datemp) INTO ret FROM emprunter WHERE NA = NA_IN ;
        ELSE
            SELECT MAX(dureeMax-(current_date-datemp)) INTO ret FROM emprunter WHERE NA = NA_IN ;
        END IF;

        RETURN RET;
    END;
$$ language plpgsql;

--b
-- SELECT NA, PRENOM, NOM, retard(A.NA)
-- FROM adherents A;

--c
CREATE OR REPLACE FUNCTION emprunts_adh(NA_IN INT)
RETURNS SETOF emprunter AS $$
    DECLARE 
        emp emprunter%ROWTYPE;
    BEGIN
        FOR emp IN SELECT * FROM emprunter WHERE NA=NA_IN LOOP
            RETURN NEXT emp;
        END LOOP;
        RETURN;
    END;
$$ language plpgsql;

--D
CREATE OR REPLACE FUNCTION exemplaires_dispo(titre_IN Oeuvres.titre%TYPE)
RETURNS SETOF Livres AS $$
    DECLARE
        curlivre Livres%ROWTYPE;
    BEGIN
        FOR curlivre IN 
            SELECT * FROM LIVRES l
            LEFT JOIN Oeuvres o ON l.no = o.no
            WHERE emprunte = false
            AND titre = titre_IN
        LOOP
            RETURN NEXT curlivre;
        END LOOP;
        RETURN;
    END;
$$ language plpgsql;

--E
CREATE TYPE tNuplet AS (texte VARCHAR, nombre INT);

CREATE OR REPLACE FUNCTION titres_auteur(auteur_in Oeuvres.auteur%TYPE)
RETURNS SETOF tNuplet AS $$
    DECLARE
        ligne tNuplet;
        nom VARCHAR;
    BEGIN
        FOR nom IN SELECT titre FROM Oeuvres WHERE auteur = auteur_in LOOP
            ligne.texte := nom;
            SELECT COUNT(*) INTO ligne.nombre FROM exemplaires_dispo(nom);
            RETURN NEXT ligne; 
        END LOOP;
        RETURN;
    END;
$$ language plpgsql;

--f
CREATE OR REPLACE FUNCTION enregistrer_emprunt(IN INT, IN DATE, IN INT, IN DATE, IN INT)
RETURNS VOID AS $$
    BEGIN
        INSERT INTO emprunter VALUES ($1, $2, $3, $4, $5);
        RAISE NOTICE 'Insertion reussie';
    END;
$$ language plpgsql;

--g
ALTER TABLE emprunter
ALTER COLUMN dureemax SET DEFAULT 14;