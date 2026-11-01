INSERT INTO echange (id, donneur, receveur, date, mox)
VALUES
    (1, 1, 2, '2026-09-15 14:30:00', 250.00),

    -- echange d'item seulement
    (2, 2, 3, '2026-09-20 16:00:00', NULL),

    -- echange entre avatars de joueurs differents
    (3, 2, 4, '2026-10-01 18:45:00', 500.00),

    -- retour de l'echange #3
    (4, 4, 2, '2026-10-01 18:45:00', NULL);