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