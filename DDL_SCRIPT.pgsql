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
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,  -- yers : jai fix cause sinon ID vont pas etre 1,2,3
    alias VARCHAR(32) NOT NULL UNIQUE,
    courriel VARCHAR(128) NOT NULL UNIQUE,
    mdp VARCHAR(32) NOT NULL,
    genre type_genre DEFAULT NULL,
    date_inscription DATE DEFAULT CURRENT_DATE,
    date_de_naissance DATE NOT NULL,
    avatar_initial INTEGER NULL UNIQUE,

    CONSTRAINT check_naissance_valide
        CHECK (date_de_naissance > DATE '1900-01-01'),

    CONSTRAINT check_inscription_valide
        CHECK (date_inscription > DATE '2024-10-01')
);

CREATE TABLE avatar (
    id INTEGER PRIMARY KEY,
    id_joueur INTEGER NULL,
    nom VARCHAR(32) NOT NULL UNIQUE,
    couleur1 INTEGER NOT NULL DEFAULT 16777215,
    couleur2 INTEGER DEFAULT 16777215,
    couleur3 INTEGER DEFAULT 16777215,
    date_creation DATE NOT NULL,
    mox NUMERIC(8, 2) NOT NULL,     -- yers : jai change a 8 cause trop petit pour mox 

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
    -- Yerson --  

CREATE TYPE type_rarete AS ENUM (
    'commun',
    'rare',
    'epique',
    'legendaire'
);

-- les items
CREATE TABLE item (
    id INTEGER PRIMARY KEY,
    jeu_id INTEGER NOT NULL,
    nom VARCHAR(32) NOT NULL UNIQUE,
    sigle CHAR(4) NOT NULL UNIQUE,
    rarete type_rarete NOT NULL,
    probabilite NUMERIC(4,3) NOT NULL,
    description VARCHAR(1024) NOT NULL,
    valeur NUMERIC(9,2) DEFAULT 100.00,

    CONSTRAINT check_sigle_valide
        CHECK (LEFT(sigle,1) = 'I'),

    CONSTRAINT check_rarete_probabilite
        CHECK(
            (rarete = 'commun'
                AND probabilite >= 0.200
                AND probabilite < 1.000)
            
            OR 
            (rarete = 'rare'
                AND probabilite >= 0.050
                AND probabilite < 0.200)
            OR 
            (rarete = 'epique'
                AND probabilite >= 0.010
                AND probabilite < 0.050)
            
            OR
            (rarete = 'legendaire'
                AND probabilite > 0.000
                AND probabilite < 0.010)
        )
);

    -- item obtenu

CREATE TABLE item_obtenus (

    avatar_id INTEGER  NOT NULL,
    item_id INTEGER NOT NULL,
    date_obtention TIMESTAMP DEFAULT NOW(),
    quantite INTEGER DEFAULT 1,

    CONSTRAINT pk_item_obtenus 
        PRIMARY KEY(avatar_id, item_id),

    CONSTRAINT fk_item_obtenus_avatar
        FOREIGN KEY (avatar_id)
        REFERENCES avatar(id),

    CONSTRAINT fk_item_obtenus_item
        FOREIGN KEY (item_id)
        REFERENCES item(id),

    CONSTRAINT check_quantite_valide
        CHECK ( quantite BETWEEN 1 and 1000)
);

-- table echange --

CREATE TABLE echange (
    id INTEGER PRIMARY KEY,
    donneur INTEGER NOT NULL,
    receveur INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    mox NUMERIC(9,2),

    CONSTRAINT fk_echange_donneur
        FOREIGN KEY (donneur)
        REFERENCES avatar(id),
    
    CONSTRAINT fk_echange_receveur
        FOREIGN KEY (receveur)
        REFERENCES avatar(id),

    CONSTRAINT check_echange_diff
        CHECK (donneur <> receveur)
);

-- échange des items pour plusieurs items

CREATE TABLE echange_item(
    id INTEGER PRIMARY KEY,
    echange_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,

    CONSTRAINT fk_echange_item_echange
        FOREIGN KEY (echange_id)
        REFERENCES echange (id),

    CONSTRAINT fk_echange_item_item
        FOREIGN KEY (item_id)
        REFERENCES item (id)
);

-- table transaction -- 

CREATE TABLE "transaction" (
    id INTEGER PRIMARY KEY,
    echange1_id INTEGER NOT NULL UNIQUE,
    echange2_id INTEGER NOT NULL UNIQUE,

    CONSTRAINT fk_transaction_echange1
        FOREIGN KEY (echange1_id)
        REFERENCES echange(id),

    CONSTRAINT fk_transaction_echange2
        FOREIGN KEY (echange2_id)
        REFERENCES echange(id)
);

-- Emmanuel

CREATE TABLE activite (
    id              INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    joueur_id       INTEGER     NOT NULL,
    debut           TIMESTAMP   NOT NULL DEFAULT NOW(),
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
        REFERENCES avatar(id)
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
        CHECK (sigle ~* 'P$')
);

CREATE TABLE habilete_obtenu (
    avatar_id       INTEGER         NOT NULL,
    habilete_id     INTEGER         NOT NULL,
    date_obtention  TIMESTAMP       NOT NULL DEFAULT NOW(),
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
        CHECK (nom ~* '^[a-zA-Z].{2,15}'),
    CONSTRAINT cc_jeu_sigle
        CHECK (sigle ~* '^[a-zA-Z].{5}')
);

CREATE TABLE portail (
    nom             VARCHAR(32)     NOT NULL UNIQUE,
    source          INTEGER         NOT NULL,
    destination     INTEGER         NOT NULL,
    cout            NUMERIC(4,2)    NOT NULL DEFAULT 0,

    CONSTRAINT cc_portail_source_destination
        CHECK (destination <> source),
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


ALTER TABLE item
    ADD CONSTRAINT fk_item_jeu
        FOREIGN KEY(jeu_id)
        REFERENCES jeu(id)
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE capsule_activite
    ADD CONSTRAINT fk_capsule_activite_monde
        FOREIGN KEY (monde_id)
        REFERENCES jeu(id)
        DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE habilete
    ADD CONSTRAINT fk_habilete_monde
        FOREIGN KEY (monde_id)
        REFERENCES jeu(id)
        DEFERRABLE INITIALLY DEFERRED;