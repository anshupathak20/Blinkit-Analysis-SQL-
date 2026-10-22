-- Import Raw Data from CSV

select * from blinkit_analysis 

-- Count all data for check the total rows 

select count(*) from blinkit_analysis

-- Data Cleaning 

update blinkit_analysis 
set item_fat_content = 
case 
when item_fat_content IN ('LF','low fat') then 'Low Fat'
when item_fat_content = 'reg' then 'Regular' 
else item_fat_content end

-- Check Data 

select distinct item_fat_content from blinkit_analysis

--KPI's 
-- Total Sales in Millions

select cast(sum(total_sales)/1000000 as decimal(10,2)) as total_sales_millions 
from blinkit_analysis 
where outlet_establishment_year = 2020

-- Avg Sales 

select cast(avg(total_sales) as decimal(10,0)) as avg_sales 
from blinkit_analysis
where outlet_establishment_year = 2020

-- Numbers of Items 

select count(*) as No_of_items from blinkit_analysis
where outlet_establishment_year = 2020

-- Average Rating 

select cast(avg(rating) as decimal(10,2)) from blinkit_analysis
where outlet_establishment_year = 2020

-- BUSINESS REQUIREMENT 

-- Sales & other metrics by fat content
select item_fat_content, 
       cast(sum(total_sales) / 1000 as decimal(10,2)) as total_sales_thousands,
	   cast(avg(total_sales) as decimal(10,2)) as avg_sales,
	   count(*) as no_of_items ,
	   cast(avg(rating) as decimal(10,2)) as avg_rating 
from blinkit_analysis
group by 1 order by total_sales_thousands desc 

-- Top 5 Sales by items 
select item_type, 
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(total_sales) as decimal(10,2)) as avg_sales,
	   count(*) as no_of_items ,
	   cast(avg(rating) as decimal(10,2)) as avg_rating 
from blinkit_analysis
group by 1 order by total_sales desc
limit 5 

-- Fat content by outlet type 

select outlet_location_type,
       cast(
           sum( 
		   case when item_fat_content = 'Low Fat' then total_sales else 0 end) as decimal(10,2)) as low_fat,
	   cast(
           sum(
           case when item_fat_content = 'Regular' then total_sales else 0 end) as decimal(10,2)) as regular 
from blinkit_analysis
group by 1 
order by 1 

-- Sales by Outlet Establishment 

select outlet_establishment_year ,
       cast(sum(total_sales) as decimal(10,2)) as total_sales,
	   cast(avg(total_sales) as decimal(10,2)) as avg_sales,
	   cast(avg(rating)as decimal(10,2)) as avg_rating,
	   count(*) as no_of_item
from blinkit_analysis
group by 1 
order by outlet_establishment_year asc 

-- Percentage of Sales & total sales by outlet size 

select outlet_size,
       cast(sum(total_sales) as decimal(10,2)) as total_sales ,
	   cast((sum(total_sales) * 100.0 / sum(sum(total_sales)) over()) as decimal(10,2)) sales_percentage
from blinkit_analysis
group by 1 
order by total_sales desc

-- By Outlet Location 

select outlet_location_type,
       cast(sum(total_sales) as decimal (10,2)) as total_sales,
	   cast(avg(total_sales) as decimal (10,2)) as avg_sales,
	   count(*) as no_of_items,
	   cast(avg(rating) as decimal (10,2)) as avg_rating
from blinkit_analysis
group by 1 
order by total_sales desc





