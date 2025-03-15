CREATE OR REPLACE FUNCTION UpdateInventoryAfterOrderDetailInsert()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Inventory
    SET b_quantity = b_quantity - NEW.quantity
    WHERE book_id = NEW.book_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
