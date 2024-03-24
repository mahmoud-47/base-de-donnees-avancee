-- Créer un enregistrement de nom tAthlete
CREATE TYPE tAthlete AS (
    nom VARCHAR,
    genre VARCHAR,
    sport VARCHAR,
    nation VARCHAR
);

-- Créer un enregistrement de nom tNoms
CREATE TYPE tNoms AS (
    nom VARCHAR,
    prenom VARCHAR
);

-- Créer la fonction profilAthlete()
CREATE OR REPLACE FUNCTION profilAthlete(id_athlete INT)
RETURNS tAthlete AS $$
DECLARE
    athlete_info tAthlete;
BEGIN
    -- Vérifier si l'athlète existe
    SELECT INTO athlete_info nom, genre, sport, nation
    FROM Athletes a
    JOIN Participations p ON a.idA = p.idAthlete
    JOIN Sports s ON p.idSport = s.ids
    JOIN Nations n ON p.idNation = n.idN
    WHERE a.idA = id_athlete;

    IF NOT FOUND THEN
        -- Si l'athlète n'existe pas, lever une exception
        RAISE EXCEPTION 'Identifiant d''athlète incorrect : %', id_athlete;
    END IF;

    RETURN athlete_info;
END;
$$ LANGUAGE plpgsql;

-- Créer la fonction nomsAthletes()
CREATE OR REPLACE FUNCTION nomsAthletes()
RETURNS SETOF tNoms AS $$
DECLARE
    athlete_name tNoms;
BEGIN
    FOR athlete_name IN
        SELECT nom, prenom
        FROM Athletes
    LOOP
        -- Séparer le nom et le prénom par une virgule
        RETURN NEXT athlete_name;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Créer le déclencheur VerifAthletes
CREATE OR REPLACE FUNCTION VerifAthletes()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier si le nom d'athlète contient une virgule
    IF NEW.nom !~ ',' THEN
        -- Si non, interrompre l'exécution avec un message d'erreur
        RAISE EXCEPTION 'Nom d''athlète mal formé';
    END IF;

    -- Convertir le genre en minuscules
    NEW.genre := LOWER(NEW.genre);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Associer le déclencheur à la table Athletes
CREATE TRIGGER tr_VerifAthletes
BEFORE INSERT OR UPDATE ON Athletes
FOR EACH ROW EXECUTE FUNCTION VerifAthletes();
