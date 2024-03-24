-- 1. Fonction profilClient
CREATE OR REPLACE FUNCTION profilClient(num_client VARCHAR)
RETURNS TABLE (nom_client VARCHAR, telephone VARCHAR) AS $$
BEGIN
    -- Vérifier si le client existe
    PERFORM true FROM Client WHERE numCli = num_client;
    IF NOT FOUND THEN
        -- Si le client n'existe pas, lever une exception
        RAISE EXCEPTION 'Client non trouvé';
    END IF;
    -- Retourner le nom et le téléphone du client
    RETURN QUERY SELECT nomCli, phone FROM Client WHERE numCli = num_client;
END;
$$ LANGUAGE plpgsql;

-- 2. Ajout d'un traitement d'exception pour un client non trouvé
CREATE OR REPLACE FUNCTION profilClient(num_client VARCHAR)
RETURNS TABLE (nom_client VARCHAR, telephone VARCHAR) AS $$
BEGIN
    -- Vérifier si le client existe
    PERFORM true FROM Client WHERE numCli = num_client;
    IF NOT FOUND THEN
        -- Si le client n'existe pas, lever une exception
        RAISE EXCEPTION 'Client non trouvé';
    END IF;
    -- Retourner le nom et le téléphone du client
    RETURN QUERY SELECT nomCli, phone FROM Client WHERE numCli = num_client;
EXCEPTION
    -- Gérer les erreurs en affichant un message
    WHEN OTHERS THEN
        RAISE NOTICE 'Une erreur s''est produite : %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- 4. Déclencheur verifEven et sa fonction associée
CREATE OR REPLACE FUNCTION verifEven()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier si la date d'autorisation est renseignée
    IF NEW.dateAutorisation IS NULL THEN
        -- Si non, interrompre l'exécution avec un message d'erreur
        RAISE EXCEPTION 'Erreur d''autorisation';
    END IF;
    -- Vérifier les dates
    IF NEW.dateAutorisation < NEW.dateDemande OR NEW.dateTenue < NEW.dateAutorisation THEN
        -- Si les dates ne sont pas cohérentes, interrompre l'exécution avec un message d'erreur
        RAISE EXCEPTION 'Erreur de date';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_verifEven
BEFORE INSERT OR UPDATE ON demandeEvenement
FOR EACH ROW EXECUTE FUNCTION verifEven();

-- 5. Fonction vueEtablissement pour créer une vue pour chaque établissement
CREATE OR REPLACE FUNCTION vueEtablissement()
RETURNS VOID AS $$
DECLARE
    etab RECORD;
BEGIN
    -- Récupérer tous les établissements
    FOR etab IN SELECT DISTINCT nomEtab FROM Etablissement LOOP
        -- Créer une vue pour chaque établissement avec les informations spécifiées
        EXECUTE 'CREATE OR REPLACE VIEW vue_' || REPLACE(etab.nomEtab, ' ', '_') || ' AS SELECT noEven, statut, coutEst, audienceEst FROM demandeEvenement WHERE numEtab = (SELECT numEtab FROM Etablissement WHERE nomEtab = ' || quote_literal(etab.nomEtab) || ')';
    END LOOP;
END;
$$ LANGUAGE plpgsql;
