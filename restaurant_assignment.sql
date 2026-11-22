
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255)
);

CREATE TABLE restaurant (
    res_id SERIAL PRIMARY KEY,
    res_name VARCHAR(255),
    image VARCHAR(255),
    description VARCHAR(255)
);

CREATE TABLE food_type (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(255)
);

CREATE TABLE food (
    food_id SERIAL PRIMARY KEY,
    food_name VARCHAR(255),
    image VARCHAR(255),
    price FLOAT,
    description VARCHAR(255),
    type_id INT REFERENCES food_type(type_id)
);

CREATE TABLE sub_food (
    sub_id SERIAL PRIMARY KEY,
    sub_name VARCHAR(255),
    sub_price FLOAT,
    food_id INT REFERENCES food(food_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    food_id INT REFERENCES food(food_id),
    amount INT,
    code VARCHAR(255),
    arr_sub_id VARCHAR(255)
);

CREATE TABLE like_res (
    user_id INT REFERENCES users(user_id),
    res_id INT REFERENCES restaurant(res_id),
    date_like TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, res_id)
);

CREATE TABLE rate_res (
    user_id INT REFERENCES users(user_id),
    res_id INT REFERENCES restaurant(res_id),
    amount INT,
    date_rate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, res_id)
);

-- 3. SAMPLE DATA

INSERT INTO users (full_name, email, password) VALUES
('Nguyen Van A', 'a@gmail.com', '123456'),
('Tran Van B', 'b@gmail.com', '123456'),
('Le Van C', 'c@gmail.com', '123456'),
('Pham Van D', 'd@gmail.com', '123456'),
('Hoang Van E', 'e@gmail.com', '123456'),
('Nguyen Van F', 'f@gmail.com', '123456');

INSERT INTO restaurant (res_name, image, description) VALUES
('Pizza Company', 'pizza.jpg', 'Pizza ngon'),
('KFC', 'kfc.jpg', 'Ga ran'),
('McDonald', 'mcdonald.jpg', 'Hamburger'),
('Lotteria', 'lotteria.jpg', 'Ga ran Han Quoc');

INSERT INTO food_type (type_name) VALUES
('Do an nhanh'),
('Do uong'),
('Mon chinh');

INSERT INTO food (food_name, image, price, description, type_id) VALUES
('Pizza', 'pizza.jpg', 150000, 'Pizza pho mai', 1),
('Hamburger', 'burger.jpg', 80000, 'Burger bo', 1),
('Coca Cola', 'coca.jpg', 20000, 'Nuoc ngot', 2),
('Ga ran', 'chicken.jpg', 60000, 'Ga ran gion', 3);

INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('Them pho mai', 15000, 1),
('Them xuc xich', 20000, 1),
('Them trung', 10000, 2);

INSERT INTO orders (user_id, food_id, amount, code, arr_sub_id) VALUES
(1, 1, 2, 'ABC01', '1,2'),
(1, 2, 1, 'ABC02', '3'),
(2, 1, 3, 'ABC03', '1'),
(2, 3, 2, 'ABC04', ''),
(3, 4, 1, 'ABC05', ''),
(3, 2, 2, 'ABC06', '3'),
(4, 1, 1, 'ABC07', ''),
(1, 4, 2, 'ABC08', '');

INSERT INTO like_res (user_id, res_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 1), (3, 3),
(4, 2), (4, 3),
(5, 1), (5, 2);

INSERT INTO rate_res (user_id, res_id, amount) VALUES
(1, 1, 5),
(2, 1, 4),
(3, 2, 5),
(4, 3, 3);

-- 4. ASSIGNMENT QUERIES

-- Query 1: Top 5 users who liked the most restaurants
SELECT
    u.user_id,
    u.full_name,
    COUNT(lr.res_id) AS total_like
FROM users u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_like DESC
LIMIT 5;

-- Query 2: Top 2 restaurants with the most likes
SELECT
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS total_like
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_like DESC
LIMIT 2;

-- Query 3: User who placed the most orders (number of order records)
SELECT
    u.user_id,
    u.full_name,
    COUNT(o.order_id) AS total_order
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_order DESC
LIMIT 1;

-- Query 4: Users who have never ordered, liked, or rated a restaurant
SELECT
    u.user_id,
    u.full_name,
    u.email
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.user_id
)
AND NOT EXISTS (
    SELECT 1 FROM like_res lr WHERE lr.user_id = u.user_id
)
AND NOT EXISTS (
    SELECT 1 FROM rate_res rr WHERE rr.user_id = u.user_id
);



-- 1. Top 5 người like nhà hàng nhiều nhất
SELECT 
    u.user_id,
    u.full_name,
    COUNT(lr.res_id) AS total_like
FROM users u
JOIN like_res lr ON u.user_id = lr.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_like DESC
LIMIT 5;


-- 2. Top 2 nhà hàng có lượt like nhiều nhất
SELECT
    r.res_id,
    r.res_name,
    COUNT(lr.user_id) AS total_like
FROM restaurant r
JOIN like_res lr ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_like DESC
LIMIT 2;


-- 3. Người đặt hàng nhiều nhất
SELECT
    u.user_id,
    u.full_name,
    COUNT(o.order_id) AS total_order
FROM users u
JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id, u.full_name
ORDER BY total_order DESC
LIMIT 1;


-- 4. Người dùng không hoạt động
SELECT
    u.user_id,
    u.full_name,
    u.email
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM orders o WHERE o.user_id = u.user_id
)
AND NOT EXISTS (
    SELECT 1 FROM like_res lr WHERE lr.user_id = u.user_id
)
AND NOT EXISTS (
    SELECT 1 FROM rate_res rr WHERE rr.user_id = u.user_id
);