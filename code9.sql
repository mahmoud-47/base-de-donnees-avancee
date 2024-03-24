-- type tResultat

CREATE TYPE tResultat AS (
    libelle VARCHAR,
    valeur int
);

-- 2 ecrire une fonction gainsFH qui renvoie la moyenne des gains hommes et femmes
CREATE OR REPLACE FUNCTION gainsHF()
RETURNS SETOF REAL AS $$
    DECLARE 
        moyH REAL;
        moyF REAL;
    BEGIN
        SELECT AVG(gain) INTO moyH
        FROM Participation P
        JOIN JOUEUR J ON P.joueur = J.NumJoueur
        AND sexe = 'H';

        return next moyH;
        
        SELECT AVG(gain) INTO moyF
        FROM Participation P
        JOIN JOUEUR J ON P.joueur = J.NumJoueur
        AND sexe = 'F';

        return next moyF;

        return;
    END;
$$ language plpgsql;


CREATE TYPE tListeParticipation AS (
    NomTournoi VARCHAR(255),
    Annee INTEGER,
    Points INTEGER
);

-- 3. Écrire une fonction de nom listeParticipation() avec un type composite
CREATE OR REPLACE FUNCTION listeParticipation(surnom_param VARCHAR(255))
RETURNS SETOF tListeParticipation AS $$
DECLARE
    joueur_sexe CHAR(1);
    result tListeParticipation;
BEGIN
    SELECT Sexe INTO joueur_sexe
    FROM Joueur
    WHERE Surnom = surnom_param;

    IF joueur_sexe IS NULL THEN
        RAISE EXCEPTION 'Le surnom fourni ne correspond à aucun joueur.';
    ELSIF joueur_sexe != 'F' THEN
        RAISE EXCEPTION 'Le joueur associé au surnom n''est pas une femme.';
    END IF;

    FOR result IN
        SELECT T.NomTournoi, P.Annee, P.Points
        FROM Participation P
        JOIN Joueur J ON P.Joueur# = J.NumJoueur
        JOIN Tournoi T ON P.Tournoi# = T.CodeTournoi
        WHERE J.Surnom = surnom_param
    LOOP
        RETURN NEXT result;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;


-- 4. Écrire un déclencheur de nom trig_Tableau
CREATE OR REPLACE FUNCTION trig_Tableau()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.Points IS NULL THEN
        RAISE EXCEPTION 'La valeur de Points ne peut pas être nulle.';
    END IF;

    DELETE FROM TABLEAU WHERE NumJoueur = NEW.Joueur# AND Annee = NEW.Annee;
    
    INSERT INTO TABLEAU (Annee, NumJoueur, Surnom, totalPoints)
    SELECT Annee, J.NumJoueur, J.Surnom, SUM(Points)
    FROM Participation P
    JOIN Joueur J ON P.Joueur# = J.NumJoueur
    WHERE P.Annee = NEW.Annee
    GROUP BY J.NumJoueur, J.Surnom, P.Annee
    ORDER BY P.Annee ASC, SUM(Points) DESC;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_Tableau
AFTER INSERT OR UPDATE ON Participation
FOR EACH ROW
EXECUTE FUNCTION trig_Tableau();


CREATE OR REPLACE FUNCTION test1()
RETURNS VOID AS $$
    DECLARE Iter VARCHAR(1);
    BEGIN
        

        FOR Iter IN values('H', 'F') LOOP
        END FOR;
    END;
$$ LANGUAGE plpgsql;

-- 10 5 8