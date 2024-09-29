--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- RESOLVE THE ERROR





--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
	runner_id,
	avg(datediff(MINUTE, order_time,CAST(pickup_time AS datetime))) as runner_time
FROM runner_orders r 
JOIN customer_orders c
    ON r.order_id = c.order_id
	group by runner_id;

--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?
--RESOLVE THE ERROR 
select 
	c.order_id, avg(cast(
						replace(duration,'mins','') 
						as decimal)) as duration
	from runner_orders r join customer_orders c
	on r.order_id = c.order_id
	group by c.order_id;

--4. What was the average distance travelled for each customer?
select 
	customer_id, round(
					avg(
						CAST(
							REPLACE(distance, 'km', '') 
							as decimal)
						)
					,2) as distances 
	from runner_orders r join customer_orders c
	on r.order_id = c.order_id
	group by customer_id;

-- 5.What was the difference between the longest and shortest delivery times for all orders?
with cte_table as(
		select 
			cast(
				case 
					when duration like '%mins' then replace(duration,'mins','')
					when duration like '%minute' then replace(duration,'minute','')
					when duration like '%minutes' then replace(duration,'minutes','')
				end 
			AS INT) as durations
			from runner_orders
			)
select concat(max(durations)  - min(durations),' Min') as Long_Short_Diff
	from cte_table;



--6. What was the average speed for each runner for each 
--delivery and do you notice any trend for these values?
with cte_table as(
		select 
			runner_id,		
			avg(
				CAST(
					REPLACE(distance, 'km', '') 
					as decimal)
				) as distances,
			cast(
				case 
					when duration like '%mins' then replace(duration,'mins','')
					when duration like '%minute' then replace(duration,'minute','')
					when duration like '%minutes' then replace(duration,'minutes','')
				end 
			AS INT) as durations
			from runner_orders
			group by runner_id, 
				cast(
					case 
						when duration like '%mins' then replace(duration,'mins','')
						when duration like '%minute' then replace(duration,'minute','')
						when duration like '%minutes' then replace(duration,'minutes','')
					end 
				AS INT)
			)
select 
	runner_id, 
	round(avg(distances/durations),2) as speed_of_Runner
from cte_table
group by runner_id;

--7. What is the successful delivery percentage for each runner?
select 
	runner_id,
	round(cast(count(duration) as decimal)/cast(count(order_id) as decimal)* 100,2) as successful_delivery_percentage
from runner_orders
group by runner_id