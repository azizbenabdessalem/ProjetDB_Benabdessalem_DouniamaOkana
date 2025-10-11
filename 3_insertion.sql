USE agence_voyage;

-- =============================
-- Dimensions & référentiels
-- =============================

-- Fournisseur (référencé par prestation)
INSERT INTO Fournisseur (id_fournisseur, nom_fournisseur, type_fournisseur) VALUES
('F001','Air France','Compagnie aérienne'),
('F002','Booking.com','Hôtel'),
('F003','Europcar','Location'),
('F004','Allianz Travel','Assurance'),
('F005','TUI Tours','Tour-opérateur'),
('F006','Transavia','Compagnie aérienne'),
('F007','Accor Hotels','Hôtel'),
('F008','Hertz','Location');

-- Prestations (MAIN: 10–15) – contraintes type/condition/prix/quantité/dates
INSERT INTO prestation (id_prestation, type_prestation, date_debut_prestation, date_fin_prestation, prix_unitaire, quantite, condition_tarif, id_fournisseur) VALUES
('P001','Vol',NULL,NULL,450.00,1,'Standard','F001'),
('P002','Hôtel','2025-06-10','2025-06-15',120.00,5,'Flexible','F007'),
('P003','Assurance','2025-06-01','2025-06-30',30.00,1,'Standard','F004'),
('P004','Location voiture','2025-06-11','2025-06-15',45.00,4,'Promo','F003'),
('P005','Circuit','2025-07-06','2025-07-10',300.00,1,'Standard','F005'),
('P006','Vol',NULL,NULL,90.00,1,'Last minute','F006'),
('P007','Hôtel','2025-07-05','2025-07-09',80.00,4,'Promo','F002'),
('P008','Vol',NULL,NULL,150.00,1,'Standard','F006'),
('P009','Hôtel','2025-09-10','2025-09-14',95.00,4,'Flexible','F002'),
('P010','Assurance','2025-09-01','2025-09-30',25.00,1,'Standard','F004'),
('P011','Vol',NULL,NULL,600.00,1,'Standard','F001'),
('P012','Hôtel','2025-10-11','2025-10-17',140.00,6,'Flexible','F007');

-- Dossiers (MAIN: 10–15) – nécessite clients, voyageurs, prestations
-- =============================
INSERT INTO Dossier_De_Reservation (id_dossier, status_dossier, date_ouverture_dossier, canal_vente, devise, total_attendu, id_prestation, id_voyageur, id_prestation_1, id_client) VALUES
('D001','Confirmé','2025-05-01','En ligne','EUR',450.00,'P001','V001','P003','C001'),
('D002','Confirmé','2025-06-01','Agence','EUR',900.00,'P002','V002','P003','C002'),
('D003','En cours','2025-07-01','Téléphone','EUR',390.00,'P006','V003','P007','C005'),
('D004','Confirmé','2025-07-12','Agence','EUR',225.00,'P004','V004','P007','C006'),
('D005','Confirmé','2025-08-01','En ligne','EUR',900.00,'P005','V005','P001','C008'),
('D006','Annulé','2025-09-01','En ligne','EUR',520.00,'P008','V006','P009','C009'),
('D007','Confirmé','2025-10-01','En ligne','EUR',1220.00,'P011','V007','P012','C010'),
('D008','En cours','2025-05-16','Agence','EUR',380.00,'P011','V008','P007','C003'),
('D009','Confirmé','2025-06-15','Téléphone','EUR',560.00,'P007','V009','P010','C004'),
('D010','Confirmé','2025-09-14','En ligne','EUR',275.00,'P006','V010','P010','C007'),
('D011','Confirmé','2025-10-11','En ligne','EUR',1420.00,'P011','V011','P012','C011'),
('D012','En cours','2025-07-09','Agence','EUR',245.00,'P010','V012','P007','C012');

-- Code_De_Promo (MAIN: 10–15)
INSERT INTO Code_De_Promo (id_code_promo, code_promo, libelle, date_debut, date_fin, type_remise, valeur_remise) VALUES
('CP01','WELCOME10','Bienvenue -10%', '2025-01-01','2025-12-31','Pourcentage',10.00),
('CP02','SPRING15','Printemps -15%', '2025-03-01','2025-05-31','Pourcentage',15.00),
('CP03','SUMMER50','Eté -50 EUR', '2025-06-01','2025-08-31','Montant',50.00),
('CP04','WEEKEND5','Week-end -5%', '2025-02-01','2025-12-31','Pourcentage',5.00),
('CP05','BUSI100','Pro -100 EUR', '2025-01-15','2025-12-15','Montant',100.00),
('CP06','LAST20','Last minute -20%', '2025-01-01','2025-12-31','Pourcentage',20.00),
('CP07','FAMILY80','Famille -80 EUR', '2025-04-01','2025-10-31','Montant',80.00),
('CP08','LOYAL5','Fidélité -5 EUR', '2025-01-01','2025-12-31','Montant',5.00),
('CP09','CITY10','City break -10%', '2025-01-10','2025-12-10','Pourcentage',10.00),
('CP10','WINTER40','Hiver -40 EUR', '2025-11-01','2026-02-28','Montant',40.00);

-- Client (MAIN: 10–15)
INSERT INTO client_ (id_client, type_client, nom_client, prenom_client, email_client, tel_client) VALUES
('C001','Particulier','Martin','Alice','alice.martin@example.com','0611223344'),
('C002','Particulier','Dubois','Hugo','hugo.dubois@example.com','0622334455'),
('C003','Entreprise','TechNova','SARL','contact@technova.fr','0144556677'),
('C004','Agence','TravelPlus','-','sales@travelplus.fr','0155667788'),
('C005','Particulier','Nguyen','Linh','linh.nguyen@example.com','0633445566'),
('C006','Particulier','Garcia','Marco','marco.garcia@example.com',NULL),
('C007','Entreprise','BlueCorp','SA','info@bluecorp.com','0177889900'),
('C008','Particulier','Bernard','Zoé','zoe.bernard@example.com','0699001122'),
('C009','Particulier','Rossi','Luca','luca.rossi@example.com','0610101010'),
('C010','Particulier','Diallo','Aminata','aminata.diallo@example.com','0620202020'),
('C011','Particulier','Schmidt','Jonas','jonas.schmidt@example.com','0630303030'),
('C012','Particulier','Moreau','Chloé','chloe.moreau@example.com','0640404040');

-- Carte_De_Fidelite (référence client, contraintes points/programme)
INSERT INTO Carte_De_Fidelite (id_carte, programme, point_cumules, id_client) VALUES
('CF01','Silver',120.0,'C001'),
('CF02','Gold',850.0,'C002'),
('CF03','Platinum',1500.0,'C005'),
('CF04','Silver',60.0,'C008'),
('CF05','Gold',420.0,'C010'),
('CF06','Silver',10.0,'C012');

-- Reclamation (MAIN: 10–15)
INSERT INTO Reclamation (id_reclamation, date_reclamation, canal, objet, staut) VALUES
('RC01','2025-06-16','Email','Retard de vol AF1234','Ouverte'),
('RC02','2025-07-10','Téléphone','Chambre non conforme','En cours'),
('RC03','2025-07-13','Agence','Facturation erronée','Traitée'),
('RC04','2025-08-02','Formulaire','Bagage perdu','En cours'),
('RC05','2025-09-02','Email','Modification de réservation','Fermée'),
('RC06','2025-10-12','Téléphone','Remboursement partiel demandé','Ouverte'),
('RC07','2025-05-22','Agence','Siège non attribué','Traitée'),
('RC08','2025-06-21','Email','Annulation tardive','En cours'),
('RC09','2025-09-16','Téléphone','Problème de billet','Fermée'),
('RC10','2025-10-19','Agence','Taxe aéroport en double','Ouverte');


-- Voyageur (MAIN: 10–15)
INSERT INTO voyageur_ (id_voyageur, nom_voyageur, prenom_voyageur, date_naissance_voyageur, nationalite, num_passeport, date_exp_passeport) VALUES
('V001','Martin','Alice','1995-04-12','FR','PA1234567','2030-05-01'),
('V002','Dubois','Hugo','1992-08-20','FR','PD7654321','2029-12-31'),
('V003','Nguyen','Linh','1998-02-05','VN','PV9988776','2031-07-15'),
('V004','Garcia','Marco','1990-11-11','ES','PE1122334','2028-11-30'),
('V005','Bernard','Zoé','2000-01-22','FR','PF5566778','2032-03-01'),
('V006','Rossi','Luca','1988-06-30','IT','PI3344556','2029-09-15'),
('V007','Diallo','Aminata','1997-09-10','SN','PS4455667','2031-01-20'),
('V008','Schmidt','Jonas','1993-12-01','DE','PG6677889','2030-10-10'),
('V009','Moreau','Chloé','2001-03-19','FR','PH7788990','2032-12-12'),
('V010','Khan','Ayesha','1996-07-07','PK','PK1239876','2030-07-07'),
('V011','Lee','Jin','1994-05-14','KR','PK7788123','2031-05-14'),
('V012','Brown','Emily','1999-10-25','GB','PG3456123','2032-10-25');

-- Trajet_ (MAIN: 10–15)
INSERT INTO Trajet_ (id_tajet, code_vol, airport_depart, aeroport_arrive, depart_datetime, arrive_datetime, num_escale) VALUES
('T001','AF1234','CDG','JFK','2025-06-10 10:00:00','2025-06-10 12:45:00',0),
('T002','AF1235','JFK','CDG','2025-06-20 16:00:00','2025-06-21 05:30:00',0),
('T003','TO3456','ORY','BCN','2025-07-05 08:30:00','2025-07-05 10:15:00',0),
('T004','HV7890','AMS','NCE','2025-07-12 14:00:00','2025-07-12 15:45:00',0),
('T005','AF5678','CDG','FCO','2025-08-01 09:00:00','2025-08-01 11:00:00',0),
('T006','AF5679','FCO','CDG','2025-08-07 18:00:00','2025-08-07 20:00:00',0),
('T007','U24100','ORY','MAD','2025-09-10 07:15:00','2025-09-10 09:30:00',0),
('T008','U24101','MAD','ORY','2025-09-15 19:00:00','2025-09-15 21:15:00',0),
('T009','AF9001','CDG','DXB','2025-10-10 22:00:00','2025-10-11 06:00:00',1),
('T010','AF9002','DXB','CDG','2025-10-18 02:00:00','2025-10-18 08:00:00',1),
('T011','HV2200','AMS','BCN','2025-05-15 13:00:00','2025-05-15 15:30:00',0),
('T012','HV2201','BCN','AMS','2025-05-22 17:00:00','2025-05-22 19:30:00',0);


-- Document_Voyageur (MAIN: 10–15)
INSERT INTO Document_Voyageur (id_document, type_document, pays, date_emission, date_expiration, num_document) VALUES
('D001','Passeport','France','2020-05-01','2030-05-01','PA1234567'),
('D002','Passeport','France','2019-12-31','2029-12-31','PD7654321'),
('D003','Passeport','Vietnam','2021-07-15','2031-07-15','PV9988776'),
('D004','Passeport','Espagne','2018-11-30','2028-11-30','PE1122334'),
('D005','Passeport','France','2022-03-01','2032-03-01','PF5566778'),
('D006','Passeport','Italie','2019-09-15','2029-09-15','PI3344556'),
('D007','Passeport','Sénégal','2021-01-20','2031-01-20','PS4455667'),
('D008','Passeport','Allemagne','2020-10-10','2030-10-10','PG6677889'),
('D009','Passeport','France','2022-12-12','2032-12-12','PH7788990'),
('D010','Visa','États-Unis','2025-04-01','2026-04-01','USVISA001'),
('D011','Carte ID','France','2023-01-01','2033-01-01','CNI778899'),
('D012','Permis','France','2024-02-01','2034-02-01','PERM55667');

-- Reservation_De_Vol (MAIN: 10–15)
INSERT INTO Reservation_De_Vol (id_vol) VALUES
('R001'),('R002'),('R003'),('R004'),('R005'),('R006'),
('R007'),('R008'),('R009'),('R010'),('R011'),('R012');




-- Paiement (MAIN: 10–15)
INSERT INTO Paiement (id_paiement, date_paiement, montant_paiement, devise_paiment, moyen_paiement, reference_paiement) VALUES
('PM01','2025-05-01',450.00,'EUR','Carte','AF1234-ALICE-01'),
('PM02','2025-06-01',780.00,'EUR','Virement','BK-2025-0601-02'),
('PM03','2025-07-01',410.00,'EUR','Carte','TO3456-LINH-03'),
('PM04','2025-07-12',180.00,'EUR','Espèces','NICE-COUNTER-04'),
('PM05','2025-08-01',1200.00,'EUR','Carte','FCO-TRIP-05'),
('PM06','2025-09-01',420.00,'EUR','Virement','MAD-RET-06'),
('PM07','2025-10-01',950.00,'EUR','Carte','DXB-RET-07'),
('PM08','2025-05-16',300.00,'EUR','Chèque','AMS-BCN-08'),
('PM09','2025-06-15',560.00,'EUR','Carte','HOTEL-P007-09'),
('PM10','2025-09-14',380.00,'EUR','Carte','MAD-ORY-10'),
('PM11','2025-10-11',1280.00,'EUR','Carte','DXB-PACK-11'),
('PM12','2025-07-09',220.00,'EUR','Virement','ASSUR-P010-12');



-- Remboursement (référencé par Donner_lieu)
INSERT INTO Remboursement (id_remboursement, date_remboursement, montant_remboursement, motif) VALUES
('RB001','2025-06-20',50.00,'Geste commercial'),
('RB002','2025-07-15',30.00,'Prest. non fournie'),
('RB003','2025-08-05',120.00,'Annulation'),
('RB004','2025-09-20',40.00,'Surfacturation'),
('RB005','2025-10-20',80.00,'Retard prolongé');

-- =============================


-- Facture_ (MAIN: 10–15) – nécessite Paiement & Dossier
INSERT INTO Facture_ (id_facture, date_facture, devise_facture, montant_facture, id_paiement, id_dossier) VALUES
('F001','2025-05-01','EUR',450.00,'PM01','D001'),
('F002','2025-06-01','EUR',780.00,'PM02','D002'),
('F003','2025-07-01','EUR',410.00,'PM03','D003'),
('F004','2025-07-12','EUR',180.00,'PM04','D004'),
('F005','2025-08-01','EUR',1200.00,'PM05','D005'),
('F006','2025-09-01','EUR',420.00,'PM06','D006'),
('F007','2025-10-01','EUR',950.00,'PM07','D007'),
('F008','2025-05-16','EUR',300.00,'PM08','D008'),
('F009','2025-06-15','EUR',560.00,'PM09','D009'),
('F010','2025-09-14','EUR',380.00,'PM10','D010'),
('F011','2025-10-11','EUR',1280.00,'PM11','D011'),
('F012','2025-07-09','EUR',220.00,'PM12','D012');

-- =============================
-- Tables d’association (5–10 lignes chacune)
-- =============================

-- Avoir (vol-trajet)
INSERT INTO Avoir (id_vol, id_tajet) VALUES
('R001','T001'),
('R002','T002'),
('R003','T003'),
('R004','T004'),
('R005','T005'),
('R006','T006'),
('R007','T007'),
('R008','T008');

-- Reserver (vol-voyageur)
INSERT INTO Reserver (id_vol, id_voyageur) VALUES
('R001','V001'),
('R002','V002'),
('R003','V003'),
('R004','V004'),
('R005','V005'),
('R006','V006'),
('R009','V007'),
('R010','V011');

-- Concerner (dossier-voyageur)
INSERT INTO Concerner (id_dossier, id_voyageur, role_voyageur) VALUES
('D001','V001','Principal'),
('D002','V002','Principal'),
('D003','V003','Principal'),
('D004','V004','Principal'),
('D005','V005','Principal'),
('D006','V006','Principal'),
('D007','V007','Principal'),
('D011','V011','Principal');

-- Obtenir (voyageur-trajet) – num_ticket UNIQUE, classe_tarif <= 5 chars
INSERT INTO Obtenir (id_voyageur, id_tajet, num_ticket, classe_tarif) VALUES
('V001','T001','TK-AF-0001','Y'),
('V002','T002','TK-AF-0002','Y'),
('V003','T003','TK-TO-0003','M'),
('V004','T004','TK-HV-0004','V'),
('V005','T005','TK-AF-0005','Y'),
('V006','T006','TK-AF-0006','Y'),
('V007','T009','TK-AF-0007','W'),
('V011','T010','TK-AF-0008','W');

-- Correspondre (client-voyageur)
INSERT INTO Correspondre (id_client, id_voyageur) VALUES
('C001','V001'),
('C002','V002'),
('C005','V003'),
('C006','V004'),
('C008','V005'),
('C009','V006'),
('C010','V007'),
('C011','V011');

-- Associer (dossier-document)
INSERT INTO Associer (id_dossier, id_document) VALUES
('D001','D001'),
('D002','D002'),
('D003','D003'),
('D004','D004'),
('D005','D005'),
('D006','D006'),
('D007','D007'),
('D011','D011');

-- Accorder (dossier-reclamation)
INSERT INTO Accorder (id_dossier, id_reclamation) VALUES
('D001','RC01'),
('D002','RC02'),
('D003','RC03'),
('D004','RC04'),
('D006','RC05'),
('D011','RC06'),
('D008','RC07'),
('D009','RC08');

-- Beneficier (dossier-code promo)
INSERT INTO Beneficier (id_dossier, id_code_promo) VALUES
('D001','CP01'),
('D002','CP02'),
('D003','CP06'),
('D004','CP04'),
('D005','CP03'),
('D009','CP09'),
('D010','CP05'),
('D011','CP10');

-- Donner_lieu (facture-remboursement)
INSERT INTO Donner_lieu (id_facture, id_remboursement) VALUES
('F001','RB001'),
('F003','RB002'),
('F005','RB003'),
('F009','RB004'),
('F011','RB005');

-- Preceder (trajet-trajet) – id_tajet <> id_tajet_1
INSERT INTO Preceder (id_tajet, id_tajet_1, ecart_minute) VALUES
('T001','T002','60'),
('T003','T004','90'),
('T005','T006','120'),
('T007','T008','45'),
('T009','T010','180'),
('T011','T012','60'),
('T003','T012','30'),
('T005','T011','40');
