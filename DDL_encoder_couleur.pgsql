-- Encoder couleur RGB en INTEGER 32 bit
-- p_r, p_g, p_b: Champ couleurs r, g et b de 0 à 255
-- exemple: SELECT encoder_couleur(255, 255, 255) -> Retourne un INTEGER 1677725
CREATE OR REPLACE FUNCTION encoder_couleur (p_r INTEGER, p_g INTEGER, p_b INTEGER)
    RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT ((0::BIT(8) || p_r::BIT(8) || p_g::BIT(8) || p_b::BIT(8))::BIT(32))::INTEGER
$$