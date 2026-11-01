-- items contenus dans les echanges

INSERT INTO echange_item (id, echange_id, item_id, quantite)
VALUES
    -- echange #2 : item seulement
    (1, 2, 2, 1),

    -- echange #4 : retour de la transaction
    (2, 4, 3, 1);