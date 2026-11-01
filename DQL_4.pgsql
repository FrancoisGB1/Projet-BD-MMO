-- yers - Pour le joueur principal, donnez le temps total passé dans chaque monde joué,
- blablalblalbla
-- au format HH:MM:SS. Le tout trié par temps décroissant.

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