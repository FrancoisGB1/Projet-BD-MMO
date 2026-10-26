CREATE OR REPLACE FUNCTION encoder_couleur (p_cr INTEGER, p_cg INTEGER, p_cb INTEGER)
    RETURNS INTEGER
LANGUAGE SQL
AS $$
    SELECT ((0::BIT(8) || p_cr::BIT(8) || p_cg::BIT(8) || p_cb::BIT(8))::BIT(32))::INTEGER
$$