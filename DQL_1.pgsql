--Donnez la liste de tous les joueurs : alias, courriel, date d’inscription et statut courant (« payant »
--ou « invité »). Le statut doit être déduit des périodes d’abonnement. Le tout trié par date
--d’inscription (croissant).
WITH abonnement AS (SELECT j.id, j.alias, j.courriel, j.date_inscription, l.date_debut, l.date_fin FROM joueur j LEFT JOIN liste_abonnement l ON j.id = l.id_joueur)
SELECT DISTINCT a.alias, a.courriel, a.date_inscription, 
    (CASE   WHEN EXISTS(SELECT x.date_fin FROM abonnement x WHERE a.id = x.id AND date_debut IS NULL) THEN 'invité'
            WHEN EXISTS(SELECT x.date_fin FROM abonnement x WHERE a.id = x.id AND date_fin IS NULL)  THEN 'payant'
            ELSE 'ancien joueur payant'
     END) 
    AS "statut" 
    FROM abonnement a
    ORDER BY a.date_inscription ASC;