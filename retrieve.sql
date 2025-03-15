-- -- -- Retrieve all users
--  SELECT * FROM Users;

-- -- -- -- Retrieve all categories
-- -- SELECT * FROM Category;

-- -- -- Retrieve all orders with their details
-- SELECT o.*, od.book_id, od.quantity, od.subtotal
-- FROM Orders o
-- JOIN OrderDetail od ON o.order_id = od.order_id;

-- -- -- -- Retrieve all payments for a specific user
-- SELECT p.*
-- FROM Payment p
-- JOIN Orders o ON p.order_id = o.order_id
-- WHERE o.user_id = 21; -- Replace 21 with the specific user_id
