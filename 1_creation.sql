CREATE SCHEMA agence_voyage;
use agence_voyage;

CREATE TABLE client_(
   id_client VARCHAR(10),
   type_client VARCHAR(15),
   nom_client VARCHAR(50) NOT NULL,
   prenom_client VARCHAR(50),
   email_client VARCHAR(100) NOT NULL,
   tel_client VARCHAR(20),
   PRIMARY KEY(id_client),
   UNIQUE(email_client)
);

CREATE TABLE Reservation_De_Vol(
   id_vol VARCHAR(10),
   PRIMARY KEY(id_vol)
);

CREATE TABLE Fournisseur(
   id_fournisseur VARCHAR(10),
   nom_fournisseur VARCHAR(100) NOT NULL,
   type_fournisseur VARCHAR(25),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE prestation(
   id_prestation VARCHAR(10),
   type_prestation VARCHAR(20),
   date_debut_prestation DATE,
   date_fin_prestation DATE,
   prix_unitaire DECIMAL(12,2),
   quantite INT,
   condition_tarif VARCHAR(20),
   id_fournisseur VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_prestation),
   FOREIGN KEY(id_fournisseur) REFERENCES Fournisseur(id_fournisseur)
);

CREATE TABLE voyageur_(
   id_voyageur VARCHAR(10),
   nom_voyageur VARCHAR(50),
   prenom_voyageur VARCHAR(50),
   date_naissance_voyageur DATE,
   nationalite VARCHAR(30),
   num_passeport VARCHAR(20),
   date_exp_passeport DATE,
   PRIMARY KEY(id_voyageur),
   UNIQUE(num_passeport)
);

CREATE TABLE Trajet_(
   id_tajet VARCHAR(10),
   code_vol VARCHAR(15),
   airport_depart VARCHAR(3),
   aeroport_arrive VARCHAR(3),
   depart_datetime DATETIME,
   arrive_datetime DATETIME,
   num_escale INT,
   PRIMARY KEY(id_tajet)
);

CREATE TABLE Paiement(
   id_paiement VARCHAR(10),
   date_paiement DATE,
   montant_paiement DECIMAL(12,2),
   devise_paiment VARCHAR(3),
   moyen_paiement VARCHAR(15),
   reference_paiement VARCHAR(50),
   PRIMARY KEY(id_paiement)
);

CREATE TABLE Carte_De_Fidelite(
   id_carte VARCHAR(10),
   programme VARCHAR(50) NOT NULL,
   point_cumules DECIMAL(12,2),
   id_client VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_carte),
   UNIQUE(id_client),
   FOREIGN KEY(id_client) REFERENCES client_(id_client)
);

CREATE TABLE Document_Voyageur(
   id_document VARCHAR(10),
   type_document VARCHAR(15),
   pays VARCHAR(50),
   date_emission DATE,
   date_expiration DATE,
   num_document VARCHAR(30),
   PRIMARY KEY(id_document)
);

CREATE TABLE Reclamation(
   id_reclamation VARCHAR(10),
   date_reclamation DATE,
   canal VARCHAR(10),
   objet VARCHAR(200),
   staut VARCHAR(20),
   PRIMARY KEY(id_reclamation)
);

CREATE TABLE Code_De_Promo(
   id_code_promo VARCHAR(10),
   code_promo VARCHAR(20),
   libelle VARCHAR(100),
   date_debut DATE,
   date_fin DATE,
   type_remise VARCHAR(10),
   valeur_remise DECIMAL(12,2),
   PRIMARY KEY(id_code_promo),
   UNIQUE(code_promo)
);

CREATE TABLE Remboursement(
   id_remboursement VARCHAR(50),
   date_remboursement DATE,
   montant_remboursement DECIMAL(15,2),
   motif VARCHAR(50),
   PRIMARY KEY(id_remboursement)
);

CREATE TABLE Dossier_De_Reservation(
   id_dossier VARCHAR(10),
   status_dossier VARCHAR(20),
   date_ouverture_dossier DATE,
   canal_vente VARCHAR(10),
   devise VARCHAR(3),
   total_attendu DECIMAL(12,2),
   id_prestation VARCHAR(10) NOT NULL,
   id_voyageur VARCHAR(10) NOT NULL,
   id_prestation_1 VARCHAR(10) NOT NULL,
   id_client VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_dossier),
   FOREIGN KEY(id_prestation) REFERENCES prestation(id_prestation),
   FOREIGN KEY(id_voyageur) REFERENCES voyageur_(id_voyageur),
   FOREIGN KEY(id_prestation_1) REFERENCES prestation(id_prestation),
   FOREIGN KEY(id_client) REFERENCES client_(id_client)
);

CREATE TABLE Facture_(
   id_facture VARCHAR(10),
   date_facture DATE,
   devise_facture VARCHAR(3),
   montant_facture DECIMAL(12,2),
   id_paiement VARCHAR(10) NOT NULL,
   id_dossier VARCHAR(10) NOT NULL,
   PRIMARY KEY(id_facture),
   FOREIGN KEY(id_paiement) REFERENCES Paiement(id_paiement),
   FOREIGN KEY(id_dossier) REFERENCES Dossier_De_Reservation(id_dossier)
);

CREATE TABLE Avoir(
   id_vol VARCHAR(10),
   id_tajet VARCHAR(10),
   PRIMARY KEY(id_vol, id_tajet),
   FOREIGN KEY(id_vol) REFERENCES Reservation_De_Vol(id_vol),
   FOREIGN KEY(id_tajet) REFERENCES Trajet_(id_tajet)
);

CREATE TABLE Reserver(
   id_vol VARCHAR(10),
   id_voyageur VARCHAR(10),
   PRIMARY KEY(id_vol, id_voyageur),
   FOREIGN KEY(id_vol) REFERENCES Reservation_De_Vol(id_vol),
   FOREIGN KEY(id_voyageur) REFERENCES voyageur_(id_voyageur)
);

CREATE TABLE Concerner(
   id_dossier VARCHAR(10),
   id_voyageur VARCHAR(10),
   role_voyageur VARCHAR(15),
   PRIMARY KEY(id_dossier, id_voyageur),
   FOREIGN KEY(id_dossier) REFERENCES Dossier_De_Reservation(id_dossier),
   FOREIGN KEY(id_voyageur) REFERENCES voyageur_(id_voyageur)
);

CREATE TABLE Obtenir(
   id_voyageur VARCHAR(10),
   id_tajet VARCHAR(10),
   num_ticket VARCHAR(30),
   classe_tarif VARCHAR(5),
   PRIMARY KEY(id_voyageur, id_tajet),
   UNIQUE(num_ticket),
   FOREIGN KEY(id_voyageur) REFERENCES voyageur_(id_voyageur),
   FOREIGN KEY(id_tajet) REFERENCES Trajet_(id_tajet)
);

CREATE TABLE Correspondre(
   id_client VARCHAR(10),
   id_voyageur VARCHAR(10),
   PRIMARY KEY(id_client, id_voyageur),
   FOREIGN KEY(id_client) REFERENCES client_(id_client),
   FOREIGN KEY(id_voyageur) REFERENCES voyageur_(id_voyageur)
);

CREATE TABLE Associer(
   id_dossier VARCHAR(10),
   id_document VARCHAR(10),
   PRIMARY KEY(id_dossier, id_document),
   FOREIGN KEY(id_dossier) REFERENCES Dossier_De_Reservation(id_dossier),
   FOREIGN KEY(id_document) REFERENCES Document_Voyageur(id_document)
);

CREATE TABLE Accorder(
   id_dossier VARCHAR(10),
   id_reclamation VARCHAR(10),
   PRIMARY KEY(id_dossier, id_reclamation),
   FOREIGN KEY(id_dossier) REFERENCES Dossier_De_Reservation(id_dossier),
   FOREIGN KEY(id_reclamation) REFERENCES Reclamation(id_reclamation)
);

CREATE TABLE Beneficier(
   id_dossier VARCHAR(10),
   id_code_promo VARCHAR(10),
   PRIMARY KEY(id_dossier, id_code_promo),
   FOREIGN KEY(id_dossier) REFERENCES Dossier_De_Reservation(id_dossier),
   FOREIGN KEY(id_code_promo) REFERENCES Code_De_Promo(id_code_promo)
);

CREATE TABLE Donner_lieu(
   id_facture VARCHAR(10),
   id_remboursement VARCHAR(50),
   PRIMARY KEY(id_facture, id_remboursement),
   FOREIGN KEY(id_facture) REFERENCES Facture_(id_facture),
   FOREIGN KEY(id_remboursement) REFERENCES Remboursement(id_remboursement)
);



CREATE TABLE Preceder(
   id_tajet     VARCHAR(10),
   id_tajet_1   VARCHAR(10),
   ecart_minute VARCHAR(50),
   PRIMARY KEY (id_tajet, id_tajet_1),
   FOREIGN KEY (id_tajet)   REFERENCES Trajet_(id_tajet),
   FOREIGN KEY (id_tajet_1) REFERENCES Trajet_(id_tajet)
);

