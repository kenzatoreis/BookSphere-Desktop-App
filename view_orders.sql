-- View for Orders with Details
CREATE VIEW OrdersWithDetails AS
SELECT o.*, od.book_id, od.quantity, od.subtotal
FROM Orders o
JOIN OrderDetail od ON o.order_id = od.order_id;

SELECT * FROM OrdersWithDetails;
