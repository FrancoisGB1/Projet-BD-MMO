-- Encoder couleur RGB en INTEGER 32 bit
-- p_r, p_g, p_b: Champ couleurs r, g et b de 0 à 255
-- exemple: SELECT encoder_couleur(255, 255, 255) -> Retourne un INTEGER 1677725
CREATE OR REPLACE FUNCTION encoder_couleur (p_r INTEGER, p_g INTEGER, p_b INTEGER)
    RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT ((0::BIT(8) || p_r::BIT(8) || p_g::BIT(8) || p_b::BIT(8))::BIT(32))::INTEGER
$$;



-- Encoder couleur INTEGER 32 bit en représentation hexadécimale
-- p_couleur: Couleur encodé en INTEGER par la fonction "encoder_couleur"
-- exemple: SELECT couleur_to_hexa(16777215) -> Retourne #ffffff
CREATE OR REPLACE FUNCTION couleur_to_hexa (p_couleur INTEGER)
    RETURNS CHAR(7)
LANGUAGE SQL
AS $$
    SELECT '#' || UPPER(LPAD(to_hex(p_couleur)::TEXT, 6, '0'))
$$;



INSERT INTO joueur 
    VALUES  (DEFAULT, 
            'Emmanuel*', 
            'emmanuel@courriel.com', 
            '489c70c41623728bcf9ad199029d833', 
            'homme_cisgenre', 
            '2025-02-14', 
            '1993-12-25', 
            NULL),
            (DEFAULT,
            'Yerson',
            'yers@hotmail.com',
            'aaf5ba7b35dbb8abf209e7451dad2da',
            'homme_cisgenre',
            '2024-11-20',
            '2000-06-05',
            NULL),
            (DEFAULT,
            'Timmy',
            'tim@proton.me',
            '49a3d9fed7f734911dfe509e7a508e2',
            'non_binaire',
            NOW(),
            '2010-01-01',
            NULL);



INSERT INTO avatar 
    VALUES  (1,
            1,
            'JohnMMO*',
            encoder_couleur(255, 160, 28),
            DEFAULT,
            DEFAULT,
            '2025-02-14',
            2000.00),
            (2,
            1,
            'NotASmurf',
            encoder_couleur(108, 240, 198),
            encoder_couleur(0, 0, 0),
            encoder_couleur(60, 125, 166),
            '2025-04-15',
            9912.50),
            (3,
            1,
            'GuyMan',
            DEFAULT,
            DEFAULT,
            DEFAULT,
            '2025-09-11',
            513.14),
            (4,
            2,
            'Jolteon*',
            encoder_couleur(231, 217, 77),
            encoder_couleur(249, 248, 229),
            encoder_couleur(38, 29, 45),
            '2024-11-20',
            8411.00),
            (5,
            2,
            'Cheko',
            encoder_couleur(111, 186, 58),
            encoder_couleur(201, 101, 138),
            DEFAULT,
            '2025-06-06',
            100.00),
            (6,
            3,
            'SephirotX2010*',
            encoder_couleur(0, 0, 0),
            encoder_couleur(0, 0, 0),
            encoder_couleur(0, 0, 0),
            NOW(),
            0.0);

WITH link_avatar_initial AS (
	SELECT avatar.id AS "avatar_id", id_joueur FROM avatar WHERE avatar.nom ~* '.+\*$'
)
UPDATE joueur
	SET avatar_initial = avatar_id
	FROM link_avatar_initial
	WHERE joueur.id = link_avatar_initial.id_joueur;



INSERT INTO leitmotiv (id, phrase, avatar_id)
VALUES
    (1, 'Just do it.', 1),
    (2, 'NEVER GIVE UP.', 1),
    (3, 'Easy peasy lemon squeezy.', 1);



INSERT INTO liste_abonnement
    VALUES  (1,
            '2025-02-14',
            NULL),
            (2,
            '2024-11-20',
            '2024-12-19'),
            (2,
            '2025-02-10',
            '2025-09-11');



-- C42 - Projet 1
-- DML : insertion des jeux (responsable : Francois)
-- creer_jeu : ajoute un jeu (monde) a la base de donnees.
-- Parametres : p_nom = nom du jeu; p_sigle = sigle de 6 caracteres;
--              p_description = description facultative du jeu.
-- Retour : aucune valeur.
-- Exemple : CALL creer_jeu('SpaceX', 'SPACEX', 'Monde spatial.');

DROP PROCEDURE IF EXISTS creer_jeu(VARCHAR, CHAR(6), VARCHAR);

CREATE PROCEDURE creer_jeu(
    p_nom VARCHAR,
    p_sigle CHAR(6),
    p_description VARCHAR
)
LANGUAGE SQL
AS $$
    INSERT INTO jeu (nom, sigle, "description")
    VALUES (p_nom, p_sigle, p_description);
$$;




-- Trois mondes; SpaceX est le monde initial (g0).
-- Sur une base neuve, leurs identifiants sont respectivement 1, 2 et 3.
CALL creer_jeu(
    'SpaceX', 'SPACEX',
    'Monde spatial avec des pouvoirs lies au temps et a la protection.'
);

CALL creer_jeu(
    'DeepHorizonX', 'DEEPHX',
    'Monde futuriste ou les avatars developpent des implants et des soins.'
);

CALL creer_jeu(
    'FreeZoneX', 'FREEZX',
    'Monde d affrontements ou les avatars ameliorent leur visee et leur mobilite.'
);



INSERT INTO portail
    VALUES ('FreeZoneX to SpaceX',
            3,
            1,
            10.00),
            ('SpaceX to FreeZoneX',
            1,
            3,
            0.00),

            ('FreeZoneX to DeepHorizonX',
            3,
            2,
            25.00),
            ('DeepHorizonX to FreeZoneX',
            2,
            3,
            0.00),

            ('DeepHorizonX to SpaceX',
            2,
            1,
            5.00);



INSERT INTO habilete
    (nom, sigle, coef1, coef2, coef3, "description", monde_id)
VALUES
    (
        'Ralentir le temps',
        'RTP',
        1.0,
        2.0,
        10.0,
        'Permet de ralentir le temps pendant une certaine duree.',
        1
    ),
    (
        'Bouclier de proximite',
        'BPP',
        1.5,
        2.0,
        15.0,
        'Cree un bouclier de protection autour de l avatar.',
        1
    ),
    (
        'Auto guerison',
        'AGP',
        2.0,
        3.0,
        20.0,
        'Permet a l avatar de recuperer de la vie automatiquement.',
        2
    ),
    (
        'Zoom oculaire',
        'ZOP',
        1.0,
        1.5,
        10.0,
        'Permet d augmenter le niveau de zoom.',
        2
    ),
    (
        'Visee automatique',
        'VAP',
        2.0,
        2.5,
        15.0,
        'Aide l avatar a viser automatiquement ses cibles.',
        3
    ),
    (
        'Ubiquite',
        'UBP',
        3.0,
        2.0,
        25.0,
        'Permet a l avatar d etre present a plusieurs endroits.',
        3
    );



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



INSERT INTO item
    VALUES (1,
            2,
            'Potion de lévitation',
            'IPL1',
            'rare',
            0.150,
            'Induit le statut de lévitation pour une durée de 4 minutes.',
            220.00),
            (2,
            1,
            'Chaussures de Course 1',
            'IBV1',
            'commun',
            0.600,
            'Permet de courir 1.1x plus vite',
            100.00),
            (3,
            3,
            'Trident Royal',
            'ITR1',
            'epique',
            0.010,
            'Pillé des ruines d Atlantis, ce trident appartenais autrefois à un garde du palais royal. Brandir cet arme empêche le désarmement.',
            5700.00),
            (4,
            2, 
            'Teinture noire',
            'ITN1',
            'legendaire',
            0.002,
            'Change la couleur de pièces d équipement en noir. Utilisable 1 fois.',
            9999.99);



-- C42 - Projet 1
-- DML : insertion des items obtenus (responsable : Francois)
-- obtenir_item : ajoute un item deja defini a l'inventaire d'un avatar.
-- Parametres :
--   p_avatar_id       : identifiant numerique de l'avatar
--   p_item_id         : identifiant numerique de l'item
--   p_date_obtention  : date et heure d'obtention
--   p_quantite        : nombre d'exemplaires (entre 1 et 1000)
-- Retour : aucune valeur.



DROP PROCEDURE IF EXISTS obtenir_item(INTEGER, INTEGER, TIMESTAMP, INTEGER);

CREATE PROCEDURE obtenir_item(
    p_avatar_id INTEGER,
    p_item_id INTEGER,
    p_date_obtention TIMESTAMP,
    p_quantite INTEGER
)
LANGUAGE SQL
AS $$
    INSERT INTO item_obtenus (
        avatar_id,
        item_id,
        date_obtention,
        quantite
    )
    VALUES (
        p_avatar_id,
        p_item_id,
        p_date_obtention,
        p_quantite
    );
$$;


-- JohnMMO* : inventaire varie (4 items differents).
CALL obtenir_item(1, 2, '2025-03-01 10:00:00', 12); -- Chaussures
CALL obtenir_item(1, 1, '2025-05-10 12:00:00',  4); -- Potions
CALL obtenir_item(1, 3, '2026-02-11 17:30:00',  2); -- Tridents
CALL obtenir_item(1, 4, '2026-03-14 09:15:00',  1); -- Teinture

-- NotASmurf : peut donner des items a d'autres avatars lors des echanges.
CALL obtenir_item(2, 2, '2025-04-30 11:30:00',  8); -- Chaussures
CALL obtenir_item(2, 1, '2025-07-15 15:00:00',  3); -- Potions
CALL obtenir_item(2, 3, '2026-01-24 18:45:00',  1); -- Trident

-- GuyMan.
CALL obtenir_item(3, 2, '2025-09-20 13:20:00',  5); -- Chaussures

-- Jolteon*.
CALL obtenir_item(4, 2, '2025-01-05 14:00:00',  6); -- Chaussures
CALL obtenir_item(4, 3, '2025-08-20 19:00:00',  1); -- Trident

-- Cheko.
CALL obtenir_item(5, 2, '2025-07-01 16:00:00',  3); -- Chaussures
CALL obtenir_item(5, 4, '2026-02-11 11:30:00',  1); -- Teinture


CALL obtenir_item(6, 2, NOW()::TIMESTAMP, 2);



INSERT INTO echange (id, donneur, receveur, date, mox)
VALUES
    (1, 1, 2, '2026-09-15 14:30:00', 250.00),

    -- echange d'item seulement
    (2, 2, 3, '2026-09-20 16:00:00', NULL),

    -- echange entre avatars de joueurs differents
    (3, 2, 4, '2026-10-01 18:45:00', 500.00),

    -- retour de l'echange #3
    (4, 4, 2, '2026-10-01 18:45:00', NULL);



-- items contenus dans les echanges

INSERT INTO echange_item (id, echange_id, item_id, quantite)
VALUES
    -- echange #2 : item seulement
    (1, 2, 2, 1),

    -- echange #4 : retour de la transaction
    (2, 4, 3, 1);



-- DML : transaction reliant deux echanges

INSERT INTO "transaction" (id, echange1_id, echange2_id)
VALUES
    (1, 3, 4);



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