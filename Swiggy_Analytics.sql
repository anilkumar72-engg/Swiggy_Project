--Data validation & cleaning

--Null Check

SELECT * FROM Swiggy_Data;


   SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Null_Order_ID,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Null_Order_Date,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS Null_State,
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS Null_City,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS Null_Location,
    SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) AS Null_Restaurant_Name,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS Null_Dish_Name,
    SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS Null_Price_INR,
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS Null_Rating,
    SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS Null_Rating_Count,
    SUM(CASE WHEN Payment_Method IS NULL THEN 1 ELSE 0 END) AS Null_Payment_Method,
    SUM(CASE WHEN Delivery_Type IS NULL THEN 1 ELSE 0 END) AS Null_Delivery_Type,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS Null_Customer_ID
    FROM Swiggy_Data;

--blank or Empty Strings
select* from Swiggy_Data
where 
State ='' OR City ='' or Restaurant_Name ='' or Location=''or Category=''or Dish_Name=''or Price_INR='' or Rating='' or Rating_Count='';


-- Duplicate Detection
select 
Order_ID, Order_Date, State, City, Location, Restaurant_Name, Category, Dish_Name, Price_INR, Rating, Rating_Count, Payment_Method, Delivery_Type, Customer_ID,count(*) as CNT
from Swiggy_Data
group by
Order_ID, Order_Date, State, City, Location, Restaurant_Name, Category, Dish_Name, Price_INR, Rating, Rating_Count, Payment_Method, Delivery_Type, Customer_ID
having count(*)>1


--creting schema

--creating Dimension table
--date table 
create table dim_date(
	date_id int identity (1,1) primary key,
	Full_Date date,
	Year int,
	Month int,
	Month_name varchar(20),
	Quarter int,
	Day int,
	Week int
	)

--dim_location
CREATE TABLE dim_location (
    Location_ID INT IDENTITY(1,1) PRIMARY KEY,
    State VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Location VARCHAR(200) NOT NULL,
    CONSTRAINT UQ_Location UNIQUE (State, City, Location)
);

--dim_restaurant
CREATE TABLE dim_restaurant (
    Restaurant_ID INT IDENTITY(1,1) PRIMARY KEY,
    Restaurant_Name VARCHAR(300) NOT NULL UNIQUE
);

--dim_category (Category / Cuisine Dimension)
CREATE TABLE dim_category (
    Category_ID INT IDENTITY(1,1) PRIMARY KEY,
    Category VARCHAR(150) NOT NULL UNIQUE
);


--dim_dish (Dish Dimension)
CREATE TABLE dim_dish (
    Dish_ID INT IDENTITY(1,1) PRIMARY KEY,
    Dish_Name VARCHAR(300) NOT NULL UNIQUE
);

---Fact Table

CREATE TABLE fact_orders (
    Fact_ID BIGINT IDENTITY(1,1) PRIMARY KEY,

    -- Foreign Keys
    Date_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Restaurant_ID INT NOT NULL,
    Category_ID INT NOT NULL,
    Dish_ID INT NOT NULL,

    -- Fact (Measures)
    Order_ID VARCHAR(50) NOT NULL,
    Price_INR DECIMAL(10,2) NOT NULL,
    Rating DECIMAL(3,2) NULL,
    Rating_Count INT NULL,
    Payment_Method VARCHAR(50) NULL,
    Delivery_Type VARCHAR(50) NULL,
    Customer_ID VARCHAR(50) NULL,

    -- Foreign Key Constraints
    CONSTRAINT FK_fact_date 
        FOREIGN KEY (Date_ID) REFERENCES dim_date(Date_ID),

    CONSTRAINT FK_fact_location 
        FOREIGN KEY (Location_ID) REFERENCES dim_location(Location_ID),

    CONSTRAINT FK_fact_restaurant 
        FOREIGN KEY (Restaurant_ID) REFERENCES dim_restaurant(Restaurant_ID),

    CONSTRAINT FK_fact_category 
        FOREIGN KEY (Category_ID) REFERENCES dim_category(Category_ID),

    CONSTRAINT FK_fact_dish 
        FOREIGN KEY (Dish_ID) REFERENCES dim_dish(Dish_ID)
);

select * from Swiggy_Data


----insert Data into the table
insert into dim_date(Full_Date,Year,Month,Month_name,Quarter,Day,Week)
select distinct
Order_Date,
YEAR(Order_Date),
MONTH(Order_Date),
DATENAME(MONTH,Order_Date),
DATEPART(quarter,Order_Date),
day(Order_Date),
datepart(Week,Order_Date)
from Swiggy_Data
where Order_Date is not null
	
--insert into locations table

insert into dim_location(State,City,Location)
select distinct
state,City,Location
from Swiggy_Data

--insert into restaurant
insert into dim_restaurant
select distinct
Restaurant_Name
from Swiggy_Data

--insert into category
insert into dim_category
select distinct
Category 
from Swiggy_Data

--insert into  dish
insert into dim_dish
select distinct
Dish_Name
from Swiggy_Data

--insert into Fact Table

INSERT INTO fact_orders
(
    Date_ID, 
    Location_ID, 
    Restaurant_ID, 
    Category_ID, 
    Dish_ID,
    Order_ID, 
    Price_INR, 
    Rating, 
    Rating_Count,
    Payment_Method, 
    Delivery_Type, 
    Customer_ID
)
SELECT
    d.Date_ID,
    l.Location_ID,
    r.Restaurant_ID,
    c.Category_ID,
    di.Dish_ID,
    sc.Order_ID,
    sc.Price_INR,
    sc.Rating,
    sc.Rating_Count,
    sc.Payment_Method,
    sc.Delivery_Type,
    sc.Customer_ID
FROM Swiggy_Data sc
JOIN dim_date d 
    ON sc.Order_Date = d.Full_Date
JOIN dim_location l 
    ON sc.State = l.State
   AND sc.City = l.City
   AND sc.Location = l.Location
JOIN dim_restaurant r 
    ON sc.Restaurant_Name = r.Restaurant_Name
JOIN dim_category c 
    ON sc.Category = c.Category
JOIN dim_dish di 
    ON sc.Dish_Name = di.Dish_Name;



select * from fact_orders

--- All tables join Query
SELECT
    f.Fact_ID,
    f.Order_ID,
    d.Full_Date,
    d.Year,
    d.Month,
    d.Month_Name,
    d.Quarter,
    d.Day,
    d.Week,
    
    l.State,
    l.City,
    l.Location,

    r.Restaurant_Name,
    c.Category,
    di.Dish_Name,

    f.Price_INR,
    f.Rating,
    f.Rating_Count,
    f.Payment_Method,
    f.Delivery_Type,
    f.Customer_ID

FROM fact_orders f
JOIN dim_date d 
    ON f.Date_ID = d.Date_ID
JOIN dim_location l 
    ON f.Location_ID = l.Location_ID
JOIN dim_restaurant r 
    ON f.Restaurant_ID = r.Restaurant_ID
JOIN dim_category c 
    ON f.Category_ID = c.Category_ID
JOIN dim_dish di 
    ON f.Dish_ID = di.Dish_ID;


	----KPI's

--1.Total Orders
select count(*) as Total_orders
from fact_orders

---2..Total Revenue
select 
format(sum(convert (float,Price_INR))/1000000, 'N2') +' INR Million'
as total_revenue
from fact_orders

---3.Average Order value
select avg(Price_INR) as Avg_Order_Value
from fact_orders

---4.Average Rating
select avg(Rating) as Avg_rating
from fact_orders

----5.Total Rating Count

select sum(Rating_Count) as Total_Rating_Count
from fact_orders


----SECTION 2 — CATEGORY / RESTAURANT INSIGHTS

---6.Top Performing Restaurants (by revenue)
SELECT 
    r.Restaurant_Name,
    SUM(f.Price_INR) AS Total_Revenue
FROM fact_orders f
JOIN dim_restaurant r ON f.Restaurant_ID = r.Restaurant_ID
GROUP BY r.Restaurant_Name
ORDER BY Total_Revenue DESC;

---7. Top Restaurants by Order Count
select 
r.Restaurant_Name,
count(*) as Total_Orders
from fact_orders f
join dim_restaurant r on f.Restaurant_ID =r.Restaurant_ID
group by r.Restaurant_Name
order by Total_Orders desc

----8.Best Rated Restaurants
select 
r.Restaurant_Name,
avg(f.Rating) as Avg_Rating
from fact_orders f
join dim_restaurant r on f.Restaurant_ID =r.Restaurant_ID
group by r.Restaurant_Name
having avg(f.Rating) >=4.0
order by Avg_Rating desc

---9. Most Ordered Dish by Category
SELECT 
    c.Category,
    di.Dish_Name,
    COUNT(*) AS Orders
FROM fact_orders f
JOIN dim_category c ON f.Category_ID = c.Category_ID
JOIN dim_dish di ON f.Dish_ID = di.Dish_ID
GROUP BY c.Category, di.Dish_Name
ORDER BY c.Category, Orders DESC;


---10.Monthly Trend of Orders
select
d.year,d.month,
count(*) as Orders
from fact_orders f
join dim_date d on f.Date_ID = d.Date_ID
group by d.year,d.month
order by d.year,d.month


---11.Day-of-Week performance
select 
d.Day,
count(*) as Orders
from fact_orders f
join dim_date d on f.Date_ID =d.Date_ID
group by d.Day
order by orders desc

---12.High-performing Areas (Locations)
select * from dim_location

select
l.Location,
count(*) as Orders
from fact_orders f
join dim_location l on f.Location_ID =l.Location_ID
group by l.Location
order by orders desc


---13.Top Cities by Revenue
select 
l.City,
sum(f.Price_INR) as Revenue
from fact_orders f
join dim_location l on f.Location_ID=l.Location_ID
group by l.City
order by Revenue desc

