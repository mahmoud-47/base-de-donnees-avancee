-- examens(nex, matiere, professeur, session, annee, niveau, typeex, duree)
-- groupe(ngr, promo, annee, groupe)
-- epreuves(nep, salle, dateheure, #NEX, #NGR)
-- etudiants(net, nom, prenom, email)
-- evaluer(net, nep, note)
-- participer(ngr, net)

-- 2 fonction qui affiche le nom du meilleur etudiant et du moins bon pour un exam donne avec leur note
CREATE TYPE nom_note AS (nom varchar(50), note int);
CREATE OR REPLACE FUNCTION meilleur_moins_bon(nexam int)
RETURNS SETOF nom_note AS $$
    DECLARE r nom_note;
    BEGIN
        SELECT et.nom, ev.note INTO r.nom, r.note
        FROM evaluer ev, epreuves ep, etudiants et
        WHERE ev.nep = ep.nep
        AND ep.nex = nexam
        AND et.net = ev.net
        ORDER BY ev.note DESC
        LIMIT 1;

        RETURN NEXT r;

        SELECT et.nom, ev.note INTO r.nom, r.note
        FROM evaluer ev, epreuves ep, etudiants et
        WHERE ev.nep = ep.nep
        AND ep.nex = nexam
        AND et.net = ev.net
        ORDER BY ev.note ASC
        LIMIT 1;

        RETURN NEXT r;
        RETURN;
    END;
$$ language plpgsql;

-- 3 Ecrire un trigger qui verifie quand on donne une note a un etudiant, que l evaluation concerne le groupe auquel il appartient
CREATE OR REPLACE FUNCTION note_ev_groupe()
RETURNS TRIGGER AS $$
    DECLARE
        numgrp_ev int;
        numgrp_et int;
    BEGIN
        SELECT ngr into numgrp_ev
        FROM epreuves
        WHERE nep = NEW.nep;

        SELECT ngr INTO numgrp_et
        FROM participer
        WHERE net = NEW.net;

        IF numgrp_ev = numgrp_et THEN
            RETURN NEW;
        ELSE
            RETURN NULL;
        END IF;
    END;
$$ language plpgsql; 

CREATE TRIGGER tr_note_ev_groupe 
BEFORE INSERT OR UPDATE ON evaluer
FOR EACH ROW 
EXECUTE PROCEDURE note_ev_groupe();

-- 4 on doit mettre la colonne groupe dans la table etudiant