CREATE OR REPLACE FUNCTION AddOrder(
    p_status VARCHAR,
    p_date DATE,
    p_total_amount NUMERIC,
    p_user_id INT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Orders (status, date, total_amount, user_id)
    VALUES (p_status, p_date, p_total_amount, p_user_id);
END;
$$ LANGUAGE plpgsql;
