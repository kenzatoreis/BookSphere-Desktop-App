CREATE VIEW TotalBooksSoldAndRevenue AS
SELECT 
    b.book_id, 
    b.b_title, 
    b.b_author, 
    b.b_price, 
    SUM(od.quantity) AS total_quantity_sold, 
    SUM(od.subtotal) AS total_revenue
FROM 
    Book b
JOIN 
    OrderDetail od ON b.book_id = od.book_id
GROUP BY 
    b.book_id, b.b_title, b.b_author, b.b_price;
	
SELECT * FROM TotalBooksSoldAndRevenue;

