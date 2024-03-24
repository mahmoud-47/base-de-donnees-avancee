-- Personne(NP, Nom, Adresse, CP, ville, pays, mail, phone)
-- Courrier(NC, libelle, texte, DateEnvoie)
-- Dons(ND, montant, DateDon, DateRecu, #NP, #NC)
-- Recevoir(#NP, #NC)

--1 Vu pour Nombre de dons et montant total des dons pour l annnee en cours pour chaque donnateur
CREATE VIEW BilanAnneeEnCoursParDonnateur AS
SELECT NP, COUNT(*) AS nb_dons, sum(montant) AS sum_mtn
FROM Dons
WHERE EXTRACT('YEAR' FROM DateDon) = EXTRACT('YEAR' FROM current_date)
GROUP BY NP;

--2 Vu pour moyenne du nombre de dons effectues par an, moyenne des montants par an par donnateur
CREATE VIEW TempdetailsAnnees AS
SELECT NP, COUNT(*) AS nb_fois_annee, SUM(montant) AS montant_annee, EXTRACT('YEAR' FROM DateDon) AS annee_don
FROM Dons
GROUP BY NP, annee_don;

CREATE VIEW BilanAnnuelParDonnateur AS
SELECT NP, AVG(nb_fois_annee) AS moy_annee, AVG(montant_annee)
FROM TempdetailsAnnees
GROUP BY NP;

--3 Resume
CREATE VIEW PremiereAnneeDon AS
SELECT NP, MIN(EXTRACT('YEAR' FROM DateDon)) as prems
FROM Dons
GROUP BY NP;

SELECT Nom, COUNT(*) AS TotalDons, moyAnnee, moy_montant, nb_dons, sum_mtn, prems
FROM Dons d, Personne p, BilanAnneeEnCoursParDonnateur b1, BilanAnnuelParDonnateur b2, PremiereAnneeDon pa
WHERE d.NP=p.NP AND d.NP=b1.NP AND d.NP=b2.NP AND d.NP=pa.NP;