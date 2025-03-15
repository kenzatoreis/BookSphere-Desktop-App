CREATE OR REPLACE FUNCTION TotalSalesForUser(p_user_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_sales NUMERIC;
BEGIN
    SELECT SUM(o.total_amount) INTO total_sales
    FROM Orders o
    WHERE o.user_id = p_user_id;

    RETURN total_sales;
END;
$$ LANGUAGE plpgsql;
