CREATE TRIGGER AfterOrderDetailInsert
AFTER INSERT ON OrderDetail
FOR EACH ROW
EXECUTE FUNCTION UpdateInventoryAfterOrderDetailInsert();
