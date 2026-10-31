
-- C42 - Projet 1
-- DML : habiletes obtenues (responsable : Francois)

-- obtenir_habilete : attribue une habilete a un avatar.
-- Parametres :
-- p_avatar_id : ID de l'avatar
-- p_habilete_id : ID de l'habilete
-- p_date_obtention : date et heure de l'obtention
-- p_niveau : niveau de l'habilete (1 a 100)
-- Retour : aucune valeur.
-- Exemple : CALL obtenir_habilete(1, 1, '2025-03-03 10:00:00', 5);


DROP PROCEDURE IF EXISTS obtenir_habilete(INTEGER, INTEGER, TIMESTAMP, INTEGER);

CREATE PROCEDURE obtenir_habilete(
    p_avatar_id INTEGER,
    p_habilete_id INTEGER,
    p_date_obtention TIMESTAMP,
    p_niveau INTEGER
)
LANGUAGE SQL
AS $$
    INSERT INTO habilete_obtenu (
        avatar_id,
        habilete_id,
        date_obtention,
        niveau
    )
    VALUES (
        p_avatar_id,
        p_habilete_id,
        p_date_obtention,
        p_niveau
    );
$$;


-- AVATAR PRINCIPAL : JohnMMO* (ID 1)
-- Une habilete provenant de chaque monde.

CALL obtenir_habilete(1, 1, '2025-03-03 10:00:00', 5);
CALL obtenir_habilete(1, 3, '2025-06-12 13:30:00', 3);
CALL obtenir_habilete(1, 5, '2025-10-05 17:00:00', 7);


-- DEUXIEME AVATAR : NotASmurf (ID 2)
-- Trois habiletes, provenant de seulement deux mondes.

CALL obtenir_habilete(2, 1, '2025-04-18 09:00:00', 2);
CALL obtenir_habilete(2, 2, '2025-04-22 11:30:00', 4);
CALL obtenir_habilete(2, 4, '2025-05-03 15:00:00', 3);


-- AUTRES AVATARS

-- GuyMan (ID 3)
CALL obtenir_habilete(3, 6, '2025-10-01 14:20:00', 1);

-- Jolteon* (ID 4)
CALL obtenir_habilete(4, 2, '2024-12-01 18:00:00', 2);
CALL obtenir_habilete(4, 3, '2025-04-01 10:00:00', 3);

-- Cheko (ID 5)
CALL obtenir_habilete(5, 4, '2025-07-08 20:00:00', 1);

-- SephirotX2010* (ID 6) : aucune habilete.
