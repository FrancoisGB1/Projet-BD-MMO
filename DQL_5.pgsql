-- yers -  Pour chaque ancien joueur payant :
-- alias, nombre de périodes d'abonnement,
-- nombre total de jours payants
-- et date de fin de la dernière période.
-- blublublublu repush dql5 

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