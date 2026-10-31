-- Encoder couleur INTEGER 32 bit en représentation hexadécimale
-- p_couleur: Couleur encodé en INTEGER par la fonction "encoder_couleur"
-- exemple: SELECT couleur_to_hexa(16777215) -> Retourne #ffffff
CREATE OR REPLACE FUNCTION couleur_to_hexa (p_couleur INTEGER)
    RETURNS CHAR(7)
LANGUAGE SQL
AS $$
    SELECT '#' || UPPER(LPAD(to_hex(p_couleur)::TEXT, 6, '0'))
$$;