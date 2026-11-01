-- 1
WITH abonnement AS (SELECT j.id, j.alias, j.courriel, j.date_inscription, l.date_debut, l.date_fin FROM joueur j LEFT JOIN liste_abonnement l ON j.id = l.id_joueur)
SELECT DISTINCT a.alias, a.courriel, a.date_inscription, 
    (CASE   WHEN EXISTS(SELECT x.date_fin FROM abonnement x WHERE a.id = x.id AND date_debut IS NULL) THEN 'invité'
            WHEN EXISTS(SELECT x.date_fin FROM abonnement x WHERE a.id = x.id AND date_fin IS NULL)  THEN 'payant'
            ELSE 'ancien joueur payant'
     END) 
    AS "statut" 
    FROM abonnement a
    ORDER BY a.date_inscription ASC;



-- 2
WITH a AS (SELECT * FROM avatar WHERE id_joueur = (SELECT id FROM joueur j WHERE j.alias ~* '.+\*$'))
SELECT  a.nom, 
		(SELECT
	        COALESCE(couleur_to_hexa(a.couleur1) || ', ' , '') ||
	        COALESCE(couleur_to_hexa(a.couleur2) || ', ' , '') ||
	        COALESCE(couleur_to_hexa(a.couleur3), '')
			FROM a x WHERE x.nom = a.nom
		) AS "couleurs préférées",
        (to_date(a.date_creation::TEXT, 'YYYY | MM | DD')) AS "date de création", 
        a.mox  
        FROM a;



-- 3
SELECT
h.sigle || ' [' || h.nom || ']' AS habilete,
ho.date_obtention,
ho.niveau,

ROUND((
    h.coef1 * POWER(ho.niveau, 2)
    + h.coef2 * ho.niveau
    + h.coef3
)::NUMERIC, 2) AS cout_actuel,

CASE
    WHEN ho.niveau = 100 THEN NULL
    ELSE ROUND((
        h.coef1 * POWER(ho.niveau + 1, 2)
        + h.coef2 * (ho.niveau + 1)
        + h.coef3
    )::NUMERIC, 2)
END AS cout_prochain
FROM avatar a
JOIN habilete_obtenu ho ON ho.avatar_id = a.id
JOIN habilete h ON h.id = ho.habilete_id
WHERE a.nom = 'JohnMMO*'
ORDER BY h.sigle;



-- 4
SELECT
    g.nom AS "monde",

    (
        CASE
            WHEN SUM(c.duree) / 3600 < 10
                THEN '0' || (SUM(c.duree) / 3600)::TEXT
            ELSE (SUM(c.duree) / 3600)::TEXT
        END
        || ':' ||
        LPAD(((SUM(c.duree) % 3600) / 60)::TEXT, 2, '0')
        || ':' ||
        LPAD((SUM(c.duree) % 60)::TEXT, 2, '0')
    ) AS "temps total"

FROM joueur j

JOIN activite a
    ON a.joueur_id = j.id

JOIN capsule_activite c
    ON c.activite_id = a.id

JOIN jeu g
    ON g.id = c.monde_id

WHERE j.alias ~* '.+\*$'

GROUP BY g.nom

ORDER BY SUM(c.duree) DESC;



-- 5
SELECT
    j.alias AS "alias",

    COUNT(*) AS "nombre de périodes",

    SUM(
        l.date_fin - l.date_debut + 1
    ) AS "nombre total de jours payants",

    MAX(l.date_fin) AS "date de fin de la dernière période"

FROM joueur j

JOIN liste_abonnement l
    ON l.id_joueur = j.id

GROUP BY
    j.id,
    j.alias

HAVING
    COUNT(*) = COUNT(l.date_fin)

ORDER BY
    j.alias ASC;



-- 6
SELECT
j.alias,
a.nom AS avatar,
COUNT(ho.habilete_id) AS nb_habiletes

FROM avatar a
JOIN joueur j ON j.id = a.id_joueur
JOIN habilete_obtenu ho ON ho.avatar_id = a.id
JOIN habilete h ON h.id = ho.habilete_id

GROUP BY j.alias, a.id, a.nom
-- check si le count de monde id sous habilete de l'avatar = le nombre de jeux 
HAVING COUNT(DISTINCT h.monde_id) = (SELECT COUNT(*) FROM jeu)
ORDER BY a.nom;



-- 7
SELECT p.nom AS portail, j1.nom AS monde_source, j2.nom AS monde_destination, p.cout,
    COALESCE((SELECT x.nom FROM portail x WHERE x.source = p.destination AND x.destination = p.source), 'aucun') AS portail_retour,
    COALESCE((p.cout + (SELECT x.cout FROM portail x WHERE x.source = p.destination AND x.destination = p.source))::VARCHAR(5), '') AS cout_aller_retour
FROM portail p
JOIN jeu j1 ON j1.id = p.source
JOIN jeu j2 ON j2.id = p.destination
ORDER BY j1.nom, j2.nom;