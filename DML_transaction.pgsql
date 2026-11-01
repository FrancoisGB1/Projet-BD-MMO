-- DML : transaction reliant deux echanges directes

INSERT INTO "transaction" (id, echange1_id, echange2_id)
VALUES
    (1, 3, 4);