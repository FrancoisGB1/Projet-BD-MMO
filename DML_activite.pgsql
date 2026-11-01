-- C42 - Projet 1 : DML activite
-- Une activite est une session de jeu d'un joueur; duree en secondes.
-- ajouter_activite : enregistre une session de jeu.
-- Parametres : p_joueur_id = ID du joueur; p_debut = debut de la session;
--              p_duree = duree totale en secondes (inclut menus/chargements).
-- Retour : aucune valeur.

DROP PROCEDURE IF EXISTS ajouter_activite(INTEGER, TIMESTAMP, INTEGER);
CREATE PROCEDURE ajouter_activite(p_joueur_id INTEGER, p_debut TIMESTAMP, p_duree INTEGER)
LANGUAGE SQL
AS $$
    INSERT INTO activite (joueur_id, debut, duree) VALUES (p_joueur_id, p_debut, p_duree);
$$;

-- Joueur 1 (principal payant) : trois activites, IDs 1, 2 et 3.
CALL ajouter_activite(1, '2025-04-25 10:00:00', 5400); -- activite 1
CALL ajouter_activite(1, '2025-10-16 18:00:00', 7200); -- activite 2
CALL ajouter_activite(1, '2026-03-09 20:30:00', 6300); -- activite 3

-- Joueur 2 (ancien payant) : uniquement pendant sa 2e periode
-- d'abonnement, du 2025-02-10 au 2025-09-11.
CALL ajouter_activite(2, '2025-07-12 14:00:00', 4800); -- activite 4
CALL ajouter_activite(2, '2025-08-20 19:00:00', 3600); -- activite 5

-- Joueur 3 (invite) : trois activites, le jour de son inscription.
-- Il ne peut utiliser que son avatar initial (6) dans le monde g0 (1).
CALL ajouter_activite(3, CURRENT_DATE + TIME '08:00:00', 2400); -- activite 6
CALL ajouter_activite(3, CURRENT_DATE + TIME '11:00:00', 3600); -- activite 7
CALL ajouter_activite(3, CURRENT_DATE + TIME '14:00:00', 1800); -- activite 8

-- Verification : huit activites au total, dont 3/2/3 par joueur.
SELECT joueur_id, COUNT(*) AS nb_activites FROM activite GROUP BY joueur_id ORDER BY joueur_id;
