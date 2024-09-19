
---1. How many pizzas were ordered?
select 
	count(*) as no_of_pizza_ordered 
	from customer_orders;


---2. How many unique customers were made
select 
	count(distinct customer_id) as no_of_customers
	from customer_orders;

---3. How many successful orders were delivered by each runner?
select 
	runner_id, count(distance) no_of_successful_orders
	from runner_orders 
	where duration<>'null'
	group by runner_id;


---4. How many of each type of pizza was delivered?
select 
	pizza_id, count(pickup_time) as unique_pizza_delivered
	from customer_orders c join runner_orders r
	on c.order_id=r.order_id
	where pickup_time<>'null'
	group by pizza_id;
	


---5. How many Vegetarian and Meatlovers were ordered by each customer?
select 
	customer_id, cast(pizza_name as varchar(15)) as pizza_name,
	count(c.pizza_id) as no_of_orders
	from customer_orders c join pizza_names n
	on c.pizza_id=n.pizza_id
	group by customer_id, cast(pizza_name as varchar(15))
	order by customer_id;


---6.What was the maximum number of pizzas delivered in a single order?
select top 1
	c.order_id, count(pizza_id) as max_pizza_ordered
	from runner_orders r join customer_orders c 
	on r.order_id = c.order_id
	where pickup_time <> 'null'
	group by c.order_id
	order by count(pizza_id) desc


select top 2 * from runner_orders
select * from customer_orders
select * from pizza_toppings
select * from pizza_recipes
select * from pizza_names