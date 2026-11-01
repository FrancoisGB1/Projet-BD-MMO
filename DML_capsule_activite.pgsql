-- C42 - Projet 1 : DML capsule_activite
-- Chaque capsule = temps d'un avatar dans un monde lors d'une activite.
-- ajouter_capsule : enregistre la duree d'une capsule d'activite.
-- Parametres : p_activite_id = ID de la session; p_avatar_id = ID de l'avatar;
--              p_monde_id = ID du jeu; p_duree = secondes passees dans ce monde.

DROP PROCEDURE IF EXISTS ajouter_capsule(INTEGER, INTEGER, INTEGER, INTEGER);
CREATE PROCEDURE ajouter_capsule(p_activite_id INTEGER, p_avatar_id INTEGER, p_monde_id INTEGER, p_duree INTEGER)
LANGUAGE SQL
AS $$
    INSERT INTO capsule_activite (activite_id, avatar_id, monde_id, duree)
    VALUES (p_activite_id, p_avatar_id, p_monde_id, p_duree);
$$;

-- Joueur 1 : 8 capsules reparties sur 3 activites.
-- Cinq capsules pour l'avatar principal JohnMMO* (ID 1).
-- Activite 1 : 4500 secondes en monde sur 5400 secondes de session.
CALL ajouter_capsule(1, 1, 1, 2400); -- JohnMMO* / SpaceX
CALL ajouter_capsule(1, 1, 2, 1200); -- JohnMMO* / DeepHorizonX
CALL ajouter_capsule(1, 2, 1, 900);  -- NotASmurf / SpaceX

-- Activite 2 : 5400 secondes en monde sur 7200 secondes de session.
CALL ajouter_capsule(2, 1, 3, 2400); -- JohnMMO* / FreeZoneX
CALL ajouter_capsule(2, 3, 1, 1200); -- GuyMan / SpaceX
CALL ajouter_capsule(2, 1, 1, 1800); -- JohnMMO* / SpaceX

-- Activite 3 : 4400 secondes en monde sur 6300 secondes de session.
CALL ajouter_capsule(3, 1, 2, 2000); -- JohnMMO* / DeepHorizonX
CALL ajouter_capsule(3, 2, 3, 2400); -- NotASmurf / FreeZoneX

-- Joueur 2 : 3 capsules pendant une periode d'abonnement en vigueur.
-- Deux avatars (4 et 5) et au moins deux mondes (1, 2 et 3).
CALL ajouter_capsule(4, 4, 1, 1800); -- Jolteon* / SpaceX
CALL ajouter_capsule(4, 5, 2, 1500); -- Cheko / DeepHorizonX
CALL ajouter_capsule(5, 5, 3, 2000); -- Cheko / FreeZoneX

-- Joueur 3 : 3 capsules, avatar initial 6 et monde g0 (jeu 1) uniquement.
CALL ajouter_capsule(6, 6, 1, 1800);
CALL ajouter_capsule(7, 6, 1, 2700);
CALL ajouter_capsule(8, 6, 1, 1200);

-- Verification : 14 capsules (8/3/3), aucune duree de capsules
-- ne doit depasser la duree totale de l'activite associee.
SELECT a.joueur_id, COUNT(*) AS nb_capsules FROM capsule_activite c
JOIN activite a ON a.id = c.activite_id GROUP BY a.joueur_id ORDER BY a.joueur_id;

SELECT a.id, a.joueur_id, a.duree AS duree_activite, SUM(c.duree) AS duree_capsules,
       a.duree - SUM(c.duree) AS temps_hors_monde
FROM activite a JOIN capsule_activite c ON c.activite_id = a.id
GROUP BY a.id, a.joueur_id, a.duree ORDER BY a.id;
