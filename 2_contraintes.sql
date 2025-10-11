
ALTER TABLE client_
ADD CONSTRAINT chk_client_email_at
CHECK (INSTR(email_client, '@') > 1);

-- PRESTATION : prix >= 0, quantite > 0, dates valides
ALTER TABLE prestation
ADD CONSTRAINT chk_prestation_prix_nonneg
CHECK (prix_unitaire >= 0),
ADD CONSTRAINT chk_prestation_quantite_positive
CHECK (quantite > 0),
ADD CONSTRAINT chk_prestation_dates
CHECK (date_debut_prestation IS NULL OR date_fin_prestation IS NULL
       OR date_debut_prestation <= date_fin_prestation);

-- VOYAGEUR : (facultatif mais logique) date de naissance avant expiration passeport
ALTER TABLE voyageur_
ADD CONSTRAINT chk_voyageur_dates
CHECK (date_naissance_voyageur IS NULL OR date_exp_passeport IS NULL
       OR date_naissance_voyageur < date_exp_passeport);

-- TRAJET : départ < arrivée ; codes aéroports sur 3 caractères
ALTER TABLE Trajet_
ADD CONSTRAINT chk_trajet_chronologie
CHECK (depart_datetime IS NULL OR arrive_datetime IS NULL
       OR depart_datetime < arrive_datetime),
ADD CONSTRAINT chk_trajet_airports_len
CHECK (airport_depart IS NULL OR aeroport_arrive IS NULL
       OR (CHAR_LENGTH(airport_depart) = 3 AND CHAR_LENGTH(aeroport_arrive) = 3));

-- PAIEMENT : montant >= 0
ALTER TABLE Paiement
ADD CONSTRAINT chk_paiement_montant_nonneg
CHECK (montant_paiement >= 0);

-- CARTE FIDELITE : points >= 0
ALTER TABLE Carte_De_Fidelite
ADD CONSTRAINT chk_carte_points_nonneg
CHECK (point_cumules >= 0);

-- DOCUMENT VOYAGEUR : émission ≤ expiration
ALTER TABLE Document_Voyageur
ADD CONSTRAINT chk_document_dates
CHECK (date_emission IS NULL OR date_expiration IS NULL
       OR date_emission <= date_expiration);

-- CODE PROMO : début ≤ fin ; valeur remise >= 0
ALTER TABLE Code_De_Promo
ADD CONSTRAINT chk_codepromo_dates
CHECK (date_debut IS NULL OR date_fin IS NULL
       OR date_debut <= date_fin),
ADD CONSTRAINT chk_codepromo_valeur_nonneg
CHECK (valeur_remise >= 0);

-- REMBOURSEMENT : montant >= 0
ALTER TABLE Remboursement
ADD CONSTRAINT chk_remboursement_montant_nonneg
CHECK (montant_remboursement >= 0);

-- DOSSIER : total attendu >= 0
ALTER TABLE Dossier_De_Reservation
ADD CONSTRAINT chk_dossier_total_nonneg
CHECK (total_attendu >= 0);

-- PRECEDER : un trajet ne peut pas précéder lui-même
ALTER TABLE Preceder
ADD CONSTRAINT chk_preceder_no_self
CHECK (id_tajet IS NULL OR id_tajet_1 IS NULL OR id_tajet <> id_tajet_1);

