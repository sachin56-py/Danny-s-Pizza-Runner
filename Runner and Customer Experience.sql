--1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--select * from runners

SELECT 
    DATEADD(WEEK, DATEDIFF(WEEK, '2021-01-01', signup_date), '2021-01-01') AS week_start,
    COUNT(*) AS runner_count
FROM 
    runners
GROUP BY 
    DATEADD(WEEK, DATEDIFF(WEEK, '2021-01-01', signup_date), '2021-01-01')
ORDER BY 
    week_start;


select 
	DATEPART(week,dateadd(day,-DATEDIFF(day,'2021-01-01','2020-12-28'),registration_date)) as week_number,
	count(runner_id) as no_of_runner_registered
	from runners
	group by DATEPART(week,dateadd(day,-DATEDIFF(day,'2021-01-01','2020-12-28'),registration_date))


--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT
	runner_id,
	avg(datediff(MINUTE, order_time,CAST(pickup_time AS datetime))) as runner_time
FROM runner_orders r 
JOIN customer_orders c
    ON r.order_id = c.order_id
	group by runner_id;
