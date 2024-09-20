
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

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--using count
select 
	c.customer_id,
	count(case when exclusions is not NULL or extras is not null then pizza_id end) as changed, 
	count(case when exclusions is NULL and extras is null then pizza_id end) as no_changed 
	from customer_orders c join runner_orders r 
	on c.order_id=r.order_id 
	where cancellation is NULL  
	group by customer_id

-- using sum
select c.customer_id,
sum(case when c.exclusions is not NULL or c.extras is not NULL then 1 else 0 end) as changed_pizzas,
sum(case when c.exclusions is NULL and c.extras is NULL then 1 else 0 end) as unchanged_pizzas
from customer_orders as c join runner_orders as r
on c.order_id = r.order_id
where r.cancellation is null
group by c.customer_id;


--8.How many pizzas were delivered that had both exclusions and extras?
select 
sum(case when c.exclusions is not NULL and c.extras is not NULL then 1 else 0 end) as having_extras_and_exclusions
from customer_orders as c join runner_orders as r
on c.order_id = r.order_id
where r.cancellation is null

--9. What was the total volume of pizzas ordered for each hour of the day?
select
	DATEPART(hour,order_time) as hours,
	count(DATEPART(hour,order_time)) as pizza_volume
	from customer_orders
	group by DATEPART(hour,order_time)
	order by count(DATEPART(hour,order_time)) desc

--10.What was the volume of orders for each day of the week?
SELECT 
	DATENAME(dw,order_time) as day_of_week,
	count(DATENAME(dw,order_time)) as pizza_volume
	from customer_orders
	group by DATENAME(dw,order_time)
	order by count(DATENAME(dw,order_time)) desc

