-- Etudiant(numetu, nom, prenom, datenaiss, rue, cp, ville)
-- Matiere(codemat, libelle, coef)
-- Epreuve(numepreuve, dateepreuve, lieu, #codemat)
-- Notation(#numetu, #numepreuve, note)

-- 2 a Une fonction qui nretourne le nombre d etudiants nes une annee
CREATE OR REPLACE FUNCTION nb_nes_annee(annee numeric)
RETURNS integer AS $$
    DECLARE 
        nb int;
    BEGIN
        SELECT count(*) into nb
        FROM Etudiant
        WHERE extract(YEAR FROM datenaiss) = annee;
        RETURN nb;
    END;
$$ language plpgsql;

-- b 
SELECT extract(YEAR FROM e.datenaiss), count(*)
FROM generate_series('1982-01-01'::DATE, '1986-01-01'::DATE, '1 Year') as an
LEFT JOIN Etudiant e
ON  extract(YEAR FROM e.datenaiss) = extract(YEAR FROM an) 
GROUP BY extract(YEAR FROM e.datenaiss);

--

SELECT EXTRACT(YEAR FROM an) as annee, nb_nes_annee(EXTRACT(YEAR FROM an))
FROM generate_series('1982-01-01'::DATE, '1986-01-01'::DATE, '1 Year') as an;
-- c
CREATE OR REPLACE FUNCTION count_births_by_year()
RETURNS TABLE (annee_naissance INT, nombre_naissances INT) AS $$
DECLARE
    an INT;
BEGIN
    FOR an IN SELECT generate_series(EXTRACT(YEAR FROM '1982-01-01'::DATE), EXTRACT(YEAR FROM '1986-01-01'::DATE)) LOOP
        RETURN QUERY SELECT an, COUNT(*) FROM Etudiant WHERE EXTRACT(YEAR FROM datenaiss) = an GROUP BY an;
    END LOOP;
END;
$$ LANGUAGE plpgsql;


-- 3 Integrite 
--a limiter les notes a 0-20
ALTER TABLE NOTATION 
ADD CONSTRAINT check_note_0_20 CHECK (note BETWEEN 0 AND 20);

--b verifier que le code postal est inexistant si la ville n est pas saisie
ALTER TABLE Etudiant
ADD CONSTRAINT check_cp_ville CHECK(cp is null OR ville is not null);

--c garantir que la rue est inexistante si ni la ville ni le cp sont saisi
ALTER TABLE Etudiant
ADD CONSTRAINT check_cp_ville CHECK((rue is null) OR (ville is not null AND cp is not null));

--d
CREATE OR REPLACE FUNCTION mineur(note REAL, numetu INT)
RETURNS BOOLEAN AS $$
DECLARE
    annee_naissance INT;
BEGIN
    SELECT extract(YEAR FROM datenaiss) INTO annee_naissance FROM Etudiant WHERE numetu = numetu;
    
    RETURN note IS NULL OR annee_naissance >= 2003;
END;
$$ LANGUAGE plpgsql;

-- 4 a
CREATE OR REPLACE FUNCTION supp_notes_par_epreuve()
RETURNS TRIGGER AS $$
    DECLARE 
        idepreuve int;
    BEGIN
        idepreuve := OLD.numepreuve;
        DELETE FROM Notation
        WHERE numepreuve = idepreuve;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_supp_notes_par_epreuve
AFTER UPDATE ON epreuve
FOR EACH ROW EXECUTE PROCEDURE supp_notes_par_epreuve();

-- b 
CREATE OR REPLACE FUNCTION revaloriser_notes()
RETURNS TRIGGER AS $$
DECLARE
    moyenne FLOAT;
BEGIN
    -- Calculer la moyenne des notes pour la matière concernée
    SELECT AVG(note) INTO moyenne
    FROM Notation
    JOIN Epreuve ON Notation.numepreuve = Epreuve.numepreuve
    WHERE Epreuve.codemat = NEW.codemat;

    -- Si la moyenne est inférieure à 5, revaloriser chaque note à 20%
    IF moyenne < 5 THEN
        UPDATE Notation
        SET note = note * 1.2
        WHERE numepreuve IN (SELECT numepreuve
                             FROM Epreuve
                             WHERE codemat = NEW.codemat);
    END IF;

    RETURN NULL; -- Retourner NULL car c'est un déclencheur AFTER
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_revaloriser_notes
AFTER INSERT OR UPDATE ON Notation
FOR EACH ROW
EXECUTE FUNCTION revaloriser_notes();
