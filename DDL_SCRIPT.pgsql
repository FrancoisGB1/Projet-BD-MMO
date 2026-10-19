CREATE TYPE type_genre AS ENUM (
    'femme_cisgenre',
    'homme_cisgenre',
    'femme_transgenre',
    'homme_transgenre',
    'non_binaire',
    'genre_fluide',
    'autre'
);

CREATE TABLE joueur (
    id INTEGER PRIMARY KEY,
    alias VARCHAR(32) NOT NULL UNIQUE,
    courriel VARCHAR(128) NOT NULL UNIQUE,
    mdp VARCHAR(32) NOT NULL,
    genre type_genre DEFAULT NULL,
    date_inscription DATE DEFAULT CURRENT_DATE,
    date_de_naissance DATE NOT NULL,
    avatar_initial INTEGER NOT NULL UNIQUE,

    CONSTRAINT check_naissance_valide
        CHECK (date_de_naissance > DATE '1900-01-01'),

    CONSTRAINT check_inscription_valide
        CHECK (date_inscription > DATE '2024-10-01')
);

CREATE TABLE avatar (
    id INTEGER PRIMARY KEY,
    id_joueur INTEGER NOT NULL,
    nom VARCHAR(32) NOT NULL UNIQUE,
    couleurs INTEGER NOT NULL,
    date_creation DATE NOT NULL,
    mox NUMERIC(4, 2) NOT NULL,

    CONSTRAINT fk_avatar_joueur
        FOREIGN KEY (id_joueur)
        REFERENCES joueur(id)
);

CREATE TABLE leitmotiv (
    id INTEGER PRIMARY KEY,
    phrase VARCHAR(64) NOT NULL,
    avatar_id INTEGER NOT NULL,

    CONSTRAINT fk_leitmotiv_avatar
        FOREIGN KEY (avatar_id)
        REFERENCES avatar(id)
);

CREATE TABLE liste_abonnement (
    id_joueur INTEGER NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE,

    CONSTRAINT fk_abonnement_joueur
        FOREIGN KEY (id_joueur)
        REFERENCES joueur(id),

    CONSTRAINT check_date_valide
        CHECK (date_fin > date_debut)
);

ALTER TABLE joueur
    ADD CONSTRAINT fk_joueur_avatar_initial
    FOREIGN KEY (avatar_initial)
    REFERENCES avatar(id)
    DEFERRABLE INITIALLY DEFERRED;