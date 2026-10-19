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

-- Emmanuel

CREATE TABLE activite (
    id              INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    joueur_id       INTEGER     NOT NULL,
    debut           DATETIME    NOT NULL DEFAULT NOW(),
    duree           INTEGER     NOT NULL,

    CONSTRAINT cc_activite_duree
        CHECK (duree > 0),
    CONSTRAINT fk_activite_joueur_id
        FOREIGN KEY (joueur_id)
        REFERENCES joueur(id)
);

CREATE TABLE capsule_activite (
    activite_id     INTEGER     NOT NULL,
    avatar_id       INTEGER     NOT NULL,
    monde_id        INTEGER     NOT NULL,
    duree           INTEGER     NOT NULL,

    CONSTRAINT cc_capsule_activite_duree
        CHECK (duree > 0),
    CONSTRAINT fk_capsule_activite_id
        FOREIGN KEY (activite_id)
        REFERENCES activite(id),
    CONSTRAINT fk_capsule_activite_avatar
        FOREIGN KEY (avatar_id)
        REFERENCES avatar(id),
    CONSTRAINT fk_capsule_activite_monde
        FOREIGN KEY (monde_id)
        REFERENCES jeu(id)
);

CREATE TABLE habilete (
    id              INTEGER             GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom             VARCHAR(32)         NOT NULL UNIQUE,
    sigle           CHAR(3)             NOT NULL UNIQUE,
    coef1           DOUBLE PRECISION    NOT NULL DEFAULT 0,
    coef2           DOUBLE PRECISION    NOT NULL DEFAULT 0,
    coef3           DOUBLE PRECISION    NOT NULL DEFAULT 1,
    "description"   VARCHAR(1024)       NOT NULL,
    monde_id        INTEGER             NOT NULL,

    CONSTRAINT cc_habilete_sigle
        CHECK (sigle ~* '^P'),
    CONSTRAINT fk_habilete_monde
        FOREIGN KEY (monde_id)
        REFERENCES jeu(id)
);

CREATE TABLE habilete_obtenu (
    avatar_id       INTEGER         NOT NULL,
    habilete_id     INTEGER         NOT NULL,
    date_obtention  DATETIME        NOT NULL DEFAULT NOW(),
    niveau          NUMERIC(3,0)    NOT NULL DEFAULT 1,

    CONSTRAINT cc_habilete_obtenu_niveau
        CHECK (niveau > 0 AND niveau < 101),
    CONSTRAINT pk_habilete_obtenu
        PRIMARY KEY (avatar_id, habilete_id),
    CONSTRAINT fk_habilete_obtenu_avatar
        FOREIGN KEY (avatar_id)
        REFERENCES avatar(id),
    CONSTRAINT fk_habilete_obtenu
        FOREIGN KEY (habilete_id)
        REFERENCES habilete(id)
);

CREATE TABLE jeu (
    id              INTEGER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom             VARCHAR(16)     NOT NULL UNIQUE,
    sigle           CHAR(6)         NOT NULL UNIQUE,
    "description"   VARCHAR(2048),

    CONSTRAINT cc_jeu_nom
        CHECK (nom ~* '^[a-zA-Z].{3,}'),
    CONSTRAINT cc_jeu_sigle
        CHECK (sigle ~* '^[a-zA-Z]')
);

CREATE TABLE portail (
    nom             VARCHAR(32)     NOT NULL UNIQUE,
    source          INTEGER         NOT NULL,
    destination     INTEGER         NOT NULL,
    cout            NUMERIC(4,2)    NOT NULL DEFAULT 0,

    CONSTRAINT cc_portail_source_destination
        CHECK (source <> destination),
    CONSTRAINT fk_portail_source
        FOREIGN KEY (source)
        REFERENCES jeu(id),
    CONSTRAINT fk_portail_destination
        FOREIGN KEY (destination)
        REFERENCES jeu(id)
);

ALTER TABLE joueur
    ADD CONSTRAINT fk_joueur_avatar_initial
    FOREIGN KEY (avatar_initial)
    REFERENCES avatar(id)
    DEFERRABLE INITIALLY DEFERRED;