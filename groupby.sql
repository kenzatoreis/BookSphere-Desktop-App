-- -- Total sales by category
--  SELECT c.cat_name, SUM(od.subtotal) AS total_sales
--  FROM Category c
--  JOIN Book b ON c.cat_id = b.cat_id
--  JOIN OrderDetail od ON b.book_id = od.book_id
--  GROUP BY c.cat_name;

-- -- Number of orders per user
--  SELECT o.user_id, COUNT(*) AS order_count
--  FROM Orders o
--  GROUP BY o.user_id;

-- -- -- Total payments received per payment method
--  SELECT p.payment_method, SUM(p.payment_amount) AS total_payments
--  FROM Payment p
--  GROUP BY p.payment_method;
