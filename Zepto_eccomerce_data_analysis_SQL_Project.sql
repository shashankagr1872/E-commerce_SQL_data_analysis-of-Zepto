drop table if exists zepto;

create table zepto(
sku_id Serial primary key,
category varchar(120),
name varchar(120) not null,
mrp numeric(8,2),
percentdiscount numeric(5,2),
availablequantity integer,
discountedsellingprice numeric(8,2),
weightingms integer,
outofstock bool,
quantity integer

);

--DATA EXPLORATION--
SELECT count(*) FROM ZEPTO;

SELECT * FROM ZEPTO 
LIMIT 10;
SELECT * FROM ZEPTO
WHERE NAME IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
percentdiscount IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;
select distinct category
from zepto
order by category;

--product out of stock vs in stock--

select outofstock,count(sku_id)
from zepto
group by outofstock;


--product name present multiple times--
select name,count(sku_id)as sku
from zepto
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--DATA CLEANING--

--product with price =0 --
select * from zepto 
where mrp=0 or discountedsellingprice=0;

-- Deleting the zero price row--
delete from zepto 
where mrp=0;

--set the prices in rupees--
update zepto
set mrp=mrp/100.0,
discountedsellingprice=discountedsellingprice/100.0;
  select* from zepto;



  
-- Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,percentdiscount
from zepto
order by percentdiscount desc
limit 10;

--Q2.What are the Products with High MRP but Out of Stock--
select distinct name,mrp,outofstock
from zepto
where outofstock = true and mrp >300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category,
sum(discountedsellingprice*availablequantity) as total_revenue
from zepto
group by category
order by total_revenue desc;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name,mrp,percentdiscount 
from zepto 
where mrp>500 and percentdiscount<10
order by mrp desc,percentdiscount;


-- Q5. Identify the top 7 categories offering the highest average discount percentage
select category,round(avg(percentdiscount),2) as average_discount
from zepto
group by category
order by average_discount desc
limit 7;

-- Q6. Find the price per gram for products above 100g and sort by best value.
 select distinct name,weightingms,discountedsellingprice,
 round(discountedsellingprice/weightingms,2) as price_per_gms
 from zepto
 where weightingms >=100
order by price_per_gms desc;

--Q7.Group the products into categories like Low, Medium, Bulk.

select distinct name,weightingms,
case when weightingms <1000 then 'low'
      when weightingms <5000 then 'medium'
	  else 'bulk'
	  end as weight_category
from zepto;	  
select * from zepto;
--Q8.What is the Total Inventory Weight Per Category 
	select category,
	sum(availablequantity*weightingms) as inventory_per_category
from zepto
group by category
order by inventory_per_category;
	  

