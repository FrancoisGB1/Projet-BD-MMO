--Pour le joueur principal, donnez la liste de ses avatars : nom, couleurs préférées en format
--hexadécimal dans une seule colonne (par exemple : « #FFFFFF, #7F00FF »; les couleurs absentes
--ne sont pas affichées), date de création selon le format 2026 | 12 | 25, quantité de moX.
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