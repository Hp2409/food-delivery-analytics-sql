
-- FOOD DELIVERY SQL MINI PROJECT
-- SCHEMA + SAMPLE DATA + ANALYTICAL QUERIES

-- TABLE: Customers
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15),
    city VARCHAR(50)
);

-- TABLE: Restaurants
CREATE TABLE Restaurants (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(50),
    cuisine VARCHAR(30),
    city VARCHAR(50)
);

-- TABLE: DeliveryPartners
CREATE TABLE DeliveryPartners (
    partner_id INT PRIMARY KEY,
    partner_name VARCHAR(50),
    vehicle_type VARCHAR(20)
);

-- TABLE: Orders
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    partner_id INT,
    order_time DATETIME,
    delivery_time DATETIME,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
    FOREIGN KEY (partner_id) REFERENCES DeliveryPartners(partner_id)
);

-- SAMPLE DATA
INSERT INTO Customers VALUES
(1,'Arun','9876543210','Chennai'),
(2,'Meera','9998887771','Bangalore'),
(3,'John','7788996655','Chennai');

INSERT INTO Restaurants VALUES
(1,'SpiceHub','Indian','Chennai'),
(2,'PastaPoint','Italian','Bangalore'),
(3,'BurgerDen','American','Chennai');

INSERT INTO DeliveryPartners VALUES
(1,'Ravi','Bike'),
(2,'Karan','Scooter'),
(3,'David','Cycle');

INSERT INTO Orders VALUES
(101,1,1,1,'2024-05-01 14:10','2024-05-01 14:40',350),
(102,2,2,3,'2024-05-02 18:20','2024-05-02 19:05',560),
(103,1,3,2,'2024-05-03 12:00','2024-05-03 12:30',250),
(104,3,1,1,'2024-05-03 20:15','2024-05-03 20:55',420);

-- QUERIES

-- 1. List all customers
SELECT * FROM Customers;

-- 2. Restaurants in Chennai
SELECT restaurant_name FROM Restaurants WHERE city='Chennai';

-- 3. Total orders per customer
SELECT customer_id, COUNT(order_id) AS total_orders
FROM Orders
GROUP BY customer_id;

-- 4. Average delivery time
SELECT AVG(TIMESTAMPDIFF(MINUTE, order_time, delivery_time)) AS avg_delivery_minutes
FROM Orders;

-- 5. Revenue per restaurant
SELECT restaurant_id, SUM(amount) AS total_revenue
FROM Orders
GROUP BY restaurant_id;

-- 6. Top spending customers
SELECT c.name, SUM(o.amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 2;

-- 7. Delivery partner performance
SELECT dp.partner_name,
       AVG(TIMESTAMPDIFF(MINUTE, order_time, delivery_time)) AS avg_time
FROM Orders o
JOIN DeliveryPartners dp ON o.partner_id = dp.partner_id
GROUP BY dp.partner_id;

-- 8. Most popular cuisine
SELECT cuisine, COUNT(*) AS orders_count
FROM Orders o
JOIN Restaurants r ON o.restaurant_id=r.restaurant_id
GROUP BY cuisine
ORDER BY orders_count DESC
LIMIT 1;
