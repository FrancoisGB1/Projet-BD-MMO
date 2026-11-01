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
	WHERE joueur.id = link_avatar_initial.id_joueur



INSERT INTO leitmotiv (id, phrase, avatar_id)
VALUES
    (1, 'Just do it.', 1),
    (2, 'NEVER GIVE UP.', 1),
    (3, 'Easy peasy lemon squeezy.', 1);



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


