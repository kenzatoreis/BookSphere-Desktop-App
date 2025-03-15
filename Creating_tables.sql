-- -- User Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    user_fname VARCHAR(255) NOT NULL,
    user_lname VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL UNIQUE
);

-- Categories Table
CREATE TABLE Category (
    cat_id SERIAL PRIMARY KEY,
    cat_name VARCHAR(255) NOT NULL,
    cat_description TEXT
);

ALTER TABLE Category
ADD CONSTRAINT unique_category_name UNIQUE (cat_name);

-- Books Table
CREATE TABLE Book (
    book_id SERIAL PRIMARY KEY,
    b_title VARCHAR(255) NOT NULL,
    b_author VARCHAR(255) NOT NULL,
    b_isbn VARCHAR(20) NOT NULL UNIQUE,
    b_price NUMERIC(10, 2) NOT NULL,
    cat_id INT,
    FOREIGN KEY (cat_id) REFERENCES Category(cat_id)
);

-- Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    status VARCHAR(100),
    date DATE,
    total_amount NUMERIC(10, 2),
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Order Details Table
CREATE TABLE OrderDetail (
    order_id INT,
    book_id INT,
    quantity INT,
    subtotal NUMERIC(10, 2),
    PRIMARY KEY (order_id, book_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Payments Table
CREATE TABLE Payment (
    payment_id SERIAL PRIMARY KEY,
    payment_method VARCHAR(100),
    payment_date DATE,
    payment_amount NUMERIC(10, 2),
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
-- Creating the Inventory table
CREATE TABLE Inventory (
    book_id INT PRIMARY KEY,
    b_quantity INT NOT NULL,
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

-- Creating the Report table
CREATE TABLE Report (
    report_id SERIAL PRIMARY KEY,
    date_generated DATE NOT NULL,
    total_sales DECIMAL(10, 2) NOT NULL,
	order_id INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Creating the ReportOrder table 
CREATE TABLE ReportOrder (
    report_id INT,
    order_id INT,
    PRIMARY KEY (report_id, order_id),
    FOREIGN KEY (report_id) REFERENCES Report(report_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
