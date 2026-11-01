-- DQL 3 : Habiletes de l'avatar principal

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