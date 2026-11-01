SELECT p.nom AS portail, j1.nom AS monde_source, j2.nom AS monde_destination, p.cout,
    COALESCE((SELECT x.nom FROM portail x WHERE x.source = p.destination AND x.destination = p.source), 'aucun') AS portail_retour,
    p.cout + (SELECT x.cout FROM portail x WHERE x.source = p.destination AND x.destination = p.source) AS cout_aller_retour
FROM portail p
JOIN jeu j1 ON j1.id = p.source
JOIN jeu j2 ON j2.id = p.destination
ORDER BY j1.nom, j2.nom;