-- CLIENT
ALTER TABLE client_
ADD CONSTRAINT chk_client_email_at
CHECK (INSTR(email_client, '@') > 1),
ADD CONSTRAINT chk_client_tel_length
CHECK (tel_client IS NULL OR CHAR_LENGTH(tel_client) >= 8),
ADD CONSTRAINT chk_client_type_in
CHECK (type_client IN ('Particulier', 'Entreprise', 'Agence'));

-- PRESTATION
ALTER TABLE prestation
ADD CONSTRAINT chk_prestation_prix_nonneg
CHECK (prix_unitaire >= 0),
ADD CONSTRAINT chk_prestation_quantite_positive
CHECK (quantite > 0),
ADD CONSTRAINT chk_prestation_dates
CHECK (
  date_debut_prestation IS NULL
  OR date_fin_prestation IS NULL
  OR date_debut_prestation <= date_fin_prestation
),
ADD CONSTRAINT chk_prestation_type_in
CHECK (type_prestation IN ('Vol', 'Hôtel', 'Circuit', 'Assurance', 'Location voiture')),
ADD CONSTRAINT chk_prestation_condition_in
CHECK (condition_tarif IN ('Standard', 'Promo', 'Last minute', 'Flexible'));

-- VOYAGEUR
ALTER TABLE voyageur_
ADD CONSTRAINT chk_voyageur_dates
CHECK (
  date_naissance_voyageur IS NULL
  OR date_exp_passeport IS NULL
  OR date_naissance_voyageur < date_exp_passeport
);

-- TRAJET
ALTER TABLE Trajet_
ADD CONSTRAINT chk_trajet_chronologie
CHECK (
  depart_datetime IS NULL
  OR arrive_datetime IS NULL
  OR depart_datetime < arrive_datetime
),
ADD CONSTRAINT chk_trajet_airports_len
CHECK (
  (airport_depart IS NULL OR CHAR_LENGTH(airport_depart)=3)
  AND
  (aeroport_arrive IS NULL OR CHAR_LENGTH(aeroport_arrive)=3)
),
ADD CONSTRAINT chk_trajet_codevol_not_empty
CHECK (code_vol IS NOT NULL AND code_vol <> ''),
ADD CONSTRAINT chk_trajet_escales_in
CHECK (num_escale IN (0, 1, 2));

-- PAIEMENT
ALTER TABLE Paiement
ADD CONSTRAINT chk_paiement_devise_length
CHECK (devise_paiment IS NULL OR CHAR_LENGTH(devise_paiment) = 3),
ADD CONSTRAINT chk_paiement_moyen_in
CHECK (moyen_paiement IN ('Carte', 'Virement', 'Espèces', 'Chèque')),
ADD CONSTRAINT chk_paiement_montant_pos
CHECK (montant_paiement > 0),


-- CARTE DE FIDELITE
ALTER TABLE Carte_De_Fidelite
ADD CONSTRAINT chk_carte_points_nonneg
CHECK (point_cumules >= 0),
ADD CONSTRAINT chk_carte_programme_in
CHECK (programme IN ('Silver', 'Gold', 'Platinum'));

-- DOCUMENT VOYAGEUR
ALTER TABLE Document_Voyageur
ADD CONSTRAINT chk_document_dates
CHECK (
  date_emission IS NULL
  OR date_expiration IS NULL
  OR date_emission <= date_expiration
),
ADD CONSTRAINT chk_document_num_len
CHECK (num_document IS NULL OR CHAR_LENGTH(num_document) >= 5),
ADD CONSTRAINT chk_document_type_in
CHECK (type_document IN ('Passeport', 'Visa', 'Carte ID', 'Permis'));

-- CODE PROMO
ALTER TABLE Code_De_Promo
ADD CONSTRAINT chk_codepromo_dates
CHECK (
  date_debut IS NULL
  OR date_fin IS NULL
  OR date_debut <= date_fin
),
ADD CONSTRAINT chk_codepromo_valeur_nonneg
CHECK (valeur_remise >= 0),
ADD CONSTRAINT chk_codepromo_type_in
CHECK (type_remise IN ('Pourcentage', 'Montant'));

-- REMBOURSEMENT
ALTER TABLE Remboursement
ADD CONSTRAINT chk_remboursement_montant_nonneg
CHECK (montant_remboursement >= 0);

-- DOSSIER
ALTER TABLE Dossier_De_Reservation
ADD CONSTRAINT chk_dossier_total_nonneg
CHECK (total_attendu >= 0),
ADD CONSTRAINT chk_dossier_canal_in
CHECK (canal_vente IN ('En ligne', 'Agence', 'Téléphone')),
ADD CONSTRAINT chk_dossier_status_in
CHECK (status_dossier IN ('En cours', 'Confirmé', 'Annulé'));

-- RECLAMATION
ALTER TABLE Reclamation
ADD CONSTRAINT chk_reclamation_canal_in
CHECK (canal IN ('Email', 'Téléphone', 'Agence', 'Formulaire')),
ADD CONSTRAINT chk_reclamation_status_in
CHECK (staut IN ('Ouverte', 'En cours', 'Traitée', 'Fermée'));

-- PRECEDER
ALTER TABLE Preceder
ADD CONSTRAINT chk_preceder_no_self
CHECK (id_tajet <> id_tajet_1);
