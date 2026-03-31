SELECT 
---- Extracting days and month from the date
       transaction_date,
       DAYNAME(transaction_date) as Day_Name,
       MONTHNAME(transaction_date) as Month_Name,
       date_format(transaction_time, 'HH:mm:ss') as Purchase_time,

--- Logical conditions for purchasing time
     CASE
        WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN  '00:00:00' AND '11:59:59' THEN 'Moring hours'
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN  '12:00:00' AND '16:59:59' THEN 'Afternoon hours'
       ELSE 'Evening hours'
END as Time_purchase_buckets,

---Logical conditions for the week
     CASE 
         WHEN Day_Name = 'Sat' OR Day_name = 'Sun' THEN 'Weekend'
         ELSE 'Weekday'
END AS Day_Classification,  
  
--- Counting number of sales, products and stores     
       COUNT(DISTINCT transaction_id) as Number_of_Sales,
       COUNT(DISTINCT store_id) as Number_of_Stores,
       COUNT(DISTINCT Product_id) as Number_of_Products,

--- Categorical columns
       store_location,
       Product_category,
       product_type,
       product_detail,

----- Revenue per quantity, generated per day
       SUM(transaction_qty*unit_price) as Revenue_per_day,

-- Logical conditions for the spending
       CASE
           WHEN Revenue_per_day > 200 THEN 'High spend'
           WHEN Revenue_per_day BETWEEN 100 and 200 THEN 'Medium spend'
           ELSE 'Low spend'
END AS Spend_buckets          
FROM `Bright_coffe_shop_casestudy`.`default`.`coffee_shop_analysis_case_study_1`
GROUP BY transaction_date, 
         DAYNAME(transaction_date),
         MONTHNAME(transaction_date),
         date_format(transaction_time, 'HH:mm:ss'),

      CASE
      WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN  '00:00:00' AND '11:59:59' THEN 'Moring hours'
       WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN  '12:00:00' AND '16:59:59' THEN 'Afternoon hours'
       ELSE 'Evening hours'
       END,
     CASE 
         WHEN Day_Name = 'Sat' OR Day_name = 'Sun' THEN 'Weekend'
         ELSE 'Weekday'
          END,
         store_location,
         product_category,
         product_type,
         product_detail
;
      

