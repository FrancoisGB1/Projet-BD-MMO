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
