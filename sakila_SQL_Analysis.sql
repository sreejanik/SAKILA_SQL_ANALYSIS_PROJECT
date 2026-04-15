USE sakila;

show tables;

desc staff;
desc payment;


-- CUSTOMER ANALYSIS
-- total no.of customers
SELECT COUNT(*) AS total_customers
FROM customer;

-- customers who rented the most movies
SELECT c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_rentals DESC;

-- top customers who spent more
SELECT c.customer_id, c.first_name, c.last_name,
       SUM(p.amount) AS total_spent, 
       COUNT(p.rental_id) AS total_rentals
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
limit 10;

-- average spending per customer
SELECT AVG(total_spent) AS avg_customer_spending
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
) AS customer_spending;

-- customers who rented less than 5 movie
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
LEFT JOIN rental r
ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;

-- REVENUE ANALYSIS
-- total revenue
SELECT SUM(amount) AS total_revenue
FROM payment;

-- average payment amount
SELECT AVG(amount) AS avg_payment
FROM payment;

-- revenue genetated by each customer
SELECT p.customer_id, c.first_name,c.last_name,
       SUM(p.amount) AS total_revenue
FROM payment p
join customer c on p.customer_id = c.customer_id
GROUP BY customer_id
ORDER BY total_revenue DESC;


-- which movies generate highest total revenue
SELECT 
    f.title,
    SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 10;

select * from staff;
select * from store;

-- revenue by store
SELECT s.store_id,
       SUM(p.amount) AS store_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- MOVIE ANALYSIS

-- total no.of films available
SELECT COUNT(*) AS total_films
FROM film;

-- most rented movies
SELECT f.title,
       COUNT(r.rental_id) AS total_rentals
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY total_rentals DESC
LIMIT 10;

-- least rented movies
SELECT f.title,
       COUNT(r.rental_id) AS total_rentals
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY total_rentals ASC;

-- most popular movie categories
SELECT c.name AS category,
       COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;


SELECT c.name AS category_name, 
    SUM(p.amount) AS total_revenue,
    COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC;


-- average rental rate of movies
SELECT c.name AS category,
       COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- TIME-BASED ANALYSIS

-- RENTALS per month
SELECT MONTHNAME(rental_date) AS rental_month,
       COUNT(*) AS total_rentals
FROM rental
GROUP BY rental_month
ORDER BY rental_month;
select distinct MONTH(rental_date) from rental;

-- revenue per month
SELECT MONTHNAME(payment_date) AS month,
       SUM(amount) AS revenue
FROM payment
GROUP BY month
ORDER BY month;

-- rentals per day of the week
SELECT DAYNAME(rental_date) AS day,
       COUNT(*) AS rentals
FROM rental
GROUP BY day;

-- average rental duration
SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_days
FROM rental;

-- STORE ANALYSIS
-- total stores
SELECT COUNT(*) AS total_stores
FROM store;

-- customers per store
SELECT store_id,
       COUNT(customer_id) AS total_customers
FROM customer
GROUP BY store_id;

desc payment;

-- rentals, revenue, customers of 2 stores
SELECT 
    s.store_id,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    SUM(p.amount) AS total_revenue,
    COUNT(r.rental_id) AS total_rentals
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment p ON c.customer_id = p.customer_id
JOIN rental r ON p.rental_id = r.rental_id
GROUP BY s.store_id;

-- rentals per store
SELECT s.store_id,
       COUNT(r.rental_id) AS total_rentals
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY s.store_id;

-- revenue per store
SELECT s.store_id,
       SUM(p.amount) AS total_revenue
FROM store s
JOIN staff st ON s.store_id = st.store_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;


-- **top 3 actors whose movies are rented the most
SELECT a.first_name, a.last_name,
       COUNT(r.rental_id) AS total_rentals
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id
ORDER BY total_rentals DESC
LIMIT 3;

SELECT 
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    COUNT(DISTINCT fa.film_id) AS no_of_films,
    COUNT(r.rental_id) AS no_of_rentals
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, actor_name
ORDER BY no_of_rentals DESC
LIMIT 5;

