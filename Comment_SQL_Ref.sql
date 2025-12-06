-- List first 10 products in department_id = 5
SELECT *
FROM public.products
WHERE department_id = 5
LIMIT 10;

-- Count how many products are in aisle_id = 10
SELECT COUNT(*) AS aisle_product_count
FROM public.products
WHERE aisle_id = 10;

-- Count the total number of orders per department. Use products joined with order_products_prior.
select a.department_id, count(a.product_id)
from public.products as a
inner join public.order_products_prior as b
on a.product_id=b.product_id
group by a.department_id;

-- Join products with departments
select a.product_name, b.department
from public.products as a
left join public.departments as b
on a.department_id=b.department_id;

-- For each customer (user_id), calculate the total number of orders.
-- Filter to only show customers with more than 50 orders.
select user_id, count(order_id) as order_count
from public.orders
group by user_id
having count(order_id) > 50
--or
select *
from (select user_id, count(order_id) as order_count
from public.orders
group by user_id)
where order_count > 50;


-- For each customer, show their orders sorted by order_number and calculate a running total of products ordered using a window function.
WITH products_per_order AS (
  SELECT
    op.order_id,
    COUNT(*) AS products_in_order
  FROM public.order_products__prior op
  GROUP BY op.order_id
)
SELECT
  o.user_id,
  o.order_id,
  o.order_number,
  ppo.products_in_order,
  SUM(ppo.products_in_order) OVER (
    PARTITION BY o.user_id
    ORDER BY o.order_number
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS running_total_products
FROM public.orders o
LEFT JOIN products_per_order ppo
  ON o.order_id = ppo.order_id
ORDER BY o.user_id, o.order_number
LIMIT 200;

select *
from public.orders
limit 5;

-- Using a CTE, find each department’s average reorder rate (reordered = 1) from the order_products__prior table joined with products
Select *
from public.products
limit 5;
select *
from public.order_products_prior
limit 5;

select a.product_id, a.department_id, b.reordered
from public.products as a
inner join public.order_products_prior as b
on a.product_id=b.product_id

WITH products_products_prior as (
    select a.product_id, a.department_id, b.reordered
    from public.products as a
    inner join public.order_products_prior as b
    on a.product_id=b.product_id
)
select department_id, avg(reordered)
from products_products_prior
group by department_id

