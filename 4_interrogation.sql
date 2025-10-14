

-- 1.1 À quoi ça sert : voir la liste concrète des vols (trajets) vers nos 4 villes.
-- -> Utile pour planifier la période de diffusion et caler la campagne sur les départs.
SELECT id_tajet, code_vol, airport_depart, aeroport_arrive, depart_datetime
FROM Trajet_
WHERE aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE')
ORDER BY depart_datetime;

-- 1.2 À quoi ça sert : lister les voyageurs qui sont déjà allés dans ces villes.
-- -> Base de ciblage CRM (emails/relances) pour la nouvelle campagne.
SELECT DISTINCT v.id_voyageur, v.nom_voyageur, v.prenom_voyageur
FROM voyageur_ v
JOIN Obtenir o ON v.id_voyageur = o.id_voyageur
JOIN Trajet_ t ON t.id_tajet = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE');

-- 1.3 À quoi ça sert : récupérer les dossiers associés à ces voyages.
-- -> Sert à voir le statut (confirmé/en cours) et l’ordre de priorité commerciale.
SELECT DISTINCT d.id_dossier, d.status_dossier, d.canal_vente, d.total_attendu
FROM Dossier_De_Reservation d
JOIN voyageur_ v ON v.id_voyageur = d.id_voyageur
JOIN Obtenir o ON o.id_voyageur = v.id_voyageur
JOIN Trajet_ t ON t.id_tajet = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE')
ORDER BY d.total_attendu DESC;

-- 1.4 À quoi ça sert : voir les prestations Hôtel achetées pour ces dossiers.
-- -> Permet d’identifier les hôtels à mettre en avant (prix, quantités).
SELECT p.id_prestation, p.type_prestation, p.prix_unitaire, p.quantite
FROM prestation p
JOIN Dossier_De_Reservation d ON p.id_prestation = d.id_prestation OR p.id_prestation = d.id_prestation_1
JOIN voyageur_ v ON v.id_voyageur = d.id_voyageur
JOIN Obtenir o ON o.id_voyageur = v.id_voyageur
JOIN Trajet_ t ON t.id_tajet = o.id_tajet
WHERE p.type_prestation = 'Hôtel' AND t.aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE');

-- 1.5 À quoi ça sert : contrôler le CA facturé sur les villes ciblées
-- (factures datées entre juin et octobre, montant entre 200 et 1500, id de facture "F0%").
SELECT f.id_facture, f.montant_facture, f.date_facture
FROM Facture_ f
JOIN Dossier_De_Reservation d ON d.id_dossier = f.id_dossier
JOIN voyageur_ v ON v.id_voyageur = d.id_voyageur
JOIN Obtenir  o ON o.id_voyageur = v.id_voyageur
JOIN Trajet_   t ON t.id_tajet    = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD','BCN','FCO','NCE')
  AND f.date_facture BETWEEN '2025-06-01' AND '2025-10-31'
  AND f.montant_facture BETWEEN 200 AND 1500
  AND f.id_facture LIKE 'F0%'
ORDER BY f.date_facture;

/* ============================================
   2) AGRÉGATIONS / STATISTIQUES
   ============================================ */

-- 2.1 À quoi ça sert : compter les voyageurs par ville.
-- -> Mesure d’attrait : plus il y a de voyageurs, plus la ville mérite une campagne.
SELECT t.aeroport_arrive, COUNT(DISTINCT o.id_voyageur) AS nb_voyageurs
FROM Trajet_ t
JOIN Obtenir o ON t.id_tajet = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE')
GROUP BY t.aeroport_arrive
ORDER BY nb_voyageurs DESC;

-- 2.2 À quoi ça sert : calculer le panier moyen par ville.
-- -> Mesure de valeur : prioriser la ville avec le panier moyen le plus élevé.
SELECT t.aeroport_arrive, ROUND(AVG(d.total_attendu),2) AS panier_moyen
FROM Dossier_De_Reservation d
JOIN voyageur_ v ON v.id_voyageur = d.id_voyageur
JOIN Obtenir o ON o.id_voyageur = v.id_voyageur
JOIN Trajet_ t ON t.id_tajet = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD', 'BCN', 'FCO', 'NCE')
GROUP BY t.aeroport_arrive
ORDER BY panier_moyen DESC;

-- 2.3 À quoi ça sert : estimer combien on dépense en HÔTEL par ville.
-- -> Choisir les partenaires hôteliers clés et négocier les meilleures offres.
SELECT t.aeroport_arrive, SUM(p.prix_unitaire * p.quantite) AS total_hotels
FROM prestation p
JOIN Dossier_De_Reservation d ON p.id_prestation = d.id_prestation OR p.id_prestation = d.id_prestation_1
JOIN voyageur_ v ON v.id_voyageur = d.id_voyageur
JOIN Obtenir o ON o.id_voyageur = v.id_voyageur
JOIN Trajet_ t ON t.id_tajet = o.id_tajet
WHERE p.type_prestation = 'Hôtel'
GROUP BY t.aeroport_arrive;

-- 2.4 À quoi ça sert : connaître les canaux qui génèrent le plus de dossiers.
-- -> Allouer le budget pub aux canaux qui performent le mieux (ex : “En ligne”).
SELECT canal_vente, COUNT(*) AS nb_dossiers
FROM Dossier_De_Reservation
GROUP BY canal_vente;

-- 2.5 À quoi ça sert : calculer les nuits d’hôtel (par prestation).
-- -> Estimer la durée de séjour moyenne pour adapter l’offre (2, 3 ou 4 nuits).
SELECT p.id_prestation, DATEDIFF(p.date_fin_prestation, p.date_debut_prestation) AS nb_nuits
FROM prestation p
WHERE p.type_prestation = 'Hôtel';


/* ============================================
   3) JOINTURES
   ============================================ */

-- 3.1 À quoi ça sert : relier voyageurs, billets (num_ticket) et trajets.
-- -> Manif claire (qui part, sur quel vol, avec quelle classe).
SELECT v.id_voyageur, v.nom_voyageur, v.prenom_voyageur,
       t.code_vol, t.airport_depart, t.aeroport_arrive, t.depart_datetime,
       o.num_ticket, o.classe_tarif
FROM voyageur_ v
JOIN Obtenir o ON v.id_voyageur = o.id_voyageur
JOIN Trajet_  t ON t.id_tajet    = o.id_tajet
WHERE t.aeroport_arrive IN ('MAD','BCN','FCO','NCE')
ORDER BY t.depart_datetime, v.nom_voyageur;

-- 3.2 À quoi ça sert : relier dossiers, factures et paiements.
-- -> Vérifier que ce qui est vendu est bien facturé et encaissé (sanity check).
SELECT d.id_dossier, d.status_dossier, f.id_facture, f.montant_facture,
       p.id_paiement, p.montant_paiement, p.moyen_paiement
FROM Dossier_De_Reservation d
JOIN Facture_ f ON f.id_dossier = d.id_dossier
JOIN Paiement p ON p.id_paiement = f.id_paiement
ORDER BY f.date_facture DESC;

-- 3.3 À quoi ça sert : taille des groupes/familles dans chaque dossier (nb voyageurs).
-- -> Savoir si les clients partent plutôt en solo, duo, famille.
SELECT d.id_dossier, COUNT(c.id_voyageur) AS nb_personnes
FROM Dossier_De_Reservation d
LEFT JOIN Concerner c ON c.id_dossier = d.id_dossier
GROUP BY d.id_dossier
ORDER BY nb_personnes DESC, d.id_dossier;

-- 3.4 À quoi ça sert : lier dossier ↔ prestations ↔ fournisseurs
-- (et ne garder que l'Hôtel) pour voir quels hôteliers sont vendus dans chaque dossier.
SELECT d.id_dossier, f.nom_fournisseur AS hotelier, p.prix_unitaire, p.quantite
FROM Dossier_De_Reservation d
JOIN prestation p ON p.id_prestation IN (d.id_prestation, d.id_prestation_1)
JOIN Fournisseur f ON f.id_fournisseur = p.id_fournisseur
WHERE p.type_prestation = 'Hôtel'
ORDER BY d.id_dossier;

-- 3.5 À quoi ça sert : relier réclamations ↔ dossiers ↔ fournisseurs concernés.
-- -> Identifier rapidement "pourquoi" (objet) et "chez qui" (fournisseur).
SELECT r.id_reclamation, r.date_reclamation, r.objet, r.staut,
       d.id_dossier,
       GROUP_CONCAT(DISTINCT f.nom_fournisseur ORDER BY f.nom_fournisseur) AS fournisseurs_dossier
FROM Reclamation r
JOIN Accorder a ON a.id_reclamation = r.id_reclamation
JOIN Dossier_De_Reservation d ON d.id_dossier = a.id_dossier
LEFT JOIN prestation p ON p.id_prestation IN (d.id_prestation, d.id_prestation_1)
LEFT JOIN Fournisseur f ON f.id_fournisseur = p.id_fournisseur
GROUP BY r.id_reclamation, r.date_reclamation, r.objet, r.staut, d.id_dossier
ORDER BY r.date_reclamation DESC;

-- 3.6 À quoi ça sert : mapping Réservation de vol ↔ Trajet ↔ Voyageurs
-- via Avoir (vol→trajet) et Reserver (vol→voyageur).
-- -> Vérifier la cohérence réservations/segments.
SELECT rv.id_vol, t.code_vol, t.airport_depart, t.aeroport_arrive, t.depart_datetime,
       COUNT(DISTINCT res.id_voyageur) AS nb_voyageurs_reserves
FROM Reservation_De_Vol rv
JOIN Avoir   av  ON av.id_vol   = rv.id_vol
JOIN Trajet_ t   ON t.id_tajet  = av.id_tajet
LEFT JOIN Reserver res ON res.id_vol = rv.id_vol
WHERE t.aeroport_arrive IN ('MAD','BCN','FCO','NCE')
GROUP BY rv.id_vol, t.code_vol, t.airport_depart, t.aeroport_arrive, t.depart_datetime
ORDER BY t.depart_datetime;

-- 3.7 À quoi ça sert : rattacher les codes promo aux dossiers (si utilisés).
-- -> Voir rapidement quelle remise a déclenché la vente.
SELECT d.id_dossier, c.code_promo, c.type_remise, c.valeur_remise
FROM Dossier_De_Reservation d
LEFT JOIN Beneficier b ON b.id_dossier = d.id_dossier
LEFT JOIN Code_De_Promo c ON c.id_code_promo = b.id_code_promo
ORDER BY d.id_dossier;

-- 3.8 À quoi ça sert : voir tous les fournisseurs, même sans prestations vendues (vue “opportunités”).
-- -> Détecter les partenaires dormants à activer/négocier.
SELECT f.nom_fournisseur, p.id_prestation
FROM Fournisseur f
LEFT JOIN prestation p ON p.id_fournisseur = f.id_fournisseur
ORDER BY f.nom_fournisseur;


/* ============================================
   4) REQUÊTES IMBRIQUÉES
   ============================================ */

-- 4.1 À quoi ça sert : lister les clients qui ont une carte de fidélité.
-- -> Cible privilégiée : plus réceptive aux offres et au cross-sell.
SELECT id_client, nom_client, prenom_client
FROM client_
WHERE id_client IN (
    SELECT id_client FROM Carte_De_Fidelite
);

-- 4.2 À quoi ça sert : lister les clients SANS carte de fidélité.
-- -> Cible “acquisition fidélité” (proposer d’adhérer via la campagne).
SELECT id_client, nom_client, prenom_client
FROM client_
WHERE id_client NOT IN (
    SELECT id_client FROM Carte_De_Fidelite
);

-- 4.3 À quoi ça sert : repérer les dossiers qui ont utilisé un code promo.
-- -> Mesurer l’appétence aux promos et réutiliser le bon niveau de remise.
SELECT d.id_dossier, d.total_attendu
FROM Dossier_De_Reservation d
WHERE EXISTS (
    SELECT 1 FROM Beneficier b WHERE b.id_dossier = d.id_dossier
);

-- 4.4 À quoi ça sert : comparer les montants aux dossiers “Agence”.
-- -> Savoir si nos montants dépassent souvent ceux vendus en agence (positionnement).
SELECT id_dossier, total_attendu
FROM Dossier_De_Reservation
WHERE total_attendu > ANY (
    SELECT total_attendu
    FROM Dossier_De_Reservation
    WHERE canal_vente = 'Agence'
);

-- 4.5 À quoi ça sert : trouver les dossiers au-dessus de tous les “En ligne”.
-- -> Isoler nos plus gros paniers pour analyser ce qui a fonctionné.
SELECT id_dossier, total_attendu
FROM Dossier_De_Reservation
WHERE total_attendu > ALL (
    SELECT total_attendu
    FROM Dossier_De_Reservation
    WHERE canal_vente = 'En ligne'
);

-- ==========================================================
-- FIN DU FICHIER
-- ==========================================================
