-- 01 Retrieve the total number of orders placed.
select count(order_id) as Total_orders
 from orders;
 
 
-- 02 Calculate the total revenue generated from pizza sales.
select round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id;

-- 03 Identify the highest-priced pizza
select pizza_types.name,pizzas.price from 
pizza_types join pizzas on
pizzas.pizza_type_id = pizza_types.pizza_type_id
order by price desc
limit 3;

-- 04 Identify the most common pizza size ordered.
select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

-- 05 List the top 5 most ordered pizza types along with their quantities

select pizza_types.name,sum(order_details.quantity) as quantity
from pizza_types
join pizzas on  pizza_types.pizza_type_id =  pizzas.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

-- 06 Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category ,sum(order_details.quantity) as quantity
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category
order by quantity;

-- 07 Determine the distribution of orders by hour of the day.
select HOUR(order_time) as hour, count(order_id) as order_count
from orders
group by hour(order_time);

-- 08 Join relevant tables to find the category-wise distribution of pizzas.
select category,count(name) from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day. 
SELECT 
   AVG(total_pizzas) AS average_pizzas_per_day
FROM (
    SELECT 
        orders.order_date,
        SUM(order_details.quantity) AS total_pizzas
    FROM orders
    JOIN order_details
        ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date
) AS daily_sales;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT 
    pizza_types.name,
    ROUND(
        SUM(order_details.quantity * pizzas.price)
        /
        (
            SELECT SUM(order_details.quantity * pizzas.price)
            FROM order_details
            JOIN pizzas
                ON pizzas.pizza_id = order_details.pizza_id
        ) * 100,
        2
    ) AS revenue_percentage
FROM pizza_types
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue_percentage DESC;

--  12 Analyze the cumulative revenue generated over time.
SELECT 
    order_date,
    SUM(revenue) OVER(ORDER BY order_date) AS cumulative_revenue
FROM
(
    SELECT 
        orders.order_date,
        SUM(order_details.quantity * pizzas.price) AS revenue
    FROM orders
    JOIN order_details
        ON orders.order_id = order_details.order_id
    JOIN pizzas
        ON order_details.pizza_id = pizzas.pizza_id
    GROUP BY orders.order_date
) AS daily_sales
ORDER BY order_date ;


