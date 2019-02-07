
-- COUNT: counting the number of rows in a particular column

SELECT COUNT(*) -- COUNT(*): Counting all rows
  FROM tutorial.aapl_historical_stock_price
  
SELECT COUNT(high) -- COUNT(col): Counting individual columns; rows in which the high column is not null
  FROM tutorial.aapl_historical_stock_price
  
SELECT COUNT(date) AS count_of_date -- AS(aliases) adding column names to make a little more sense
  FROM tutorial.aapl_historical_stock_price

SELECT COUNT(date) AS "Count of Date" -- with double quotes: be able to put spaces
  FROM tutorial.aapl_historical_stock_price

-- ex) checking which column has the most null values
SELECT COUNT(year) AS year, -- a query counting every single column
       COUNT(month) AS month,
       COUNT(open) AS open,
       COUNT(high) AS high,
       COUNT(low) AS low,
       COUNT(close) AS close,
       COUNT(volume) AS volume
  FROM tutorial.aapl_historical_stock_price

--=====================================================================================================

-- SUM: totals the values in a given column

SELECT SUM(volume) -- 1) aggregators only aggregate vertically; 
  FROM tutorial.aapl_historical_stock_price -- 2) no need to worry as much about the presence of nulls; 
  
  
-- ex) calculating the average opening price
SELECT SUM(open) / COUNT(open) AS avg_open_price
  FROM tutorial.aapl_historical_stock_price
  
--=====================================================================================================

-- MIN/MAX: returning the lowest and highest values in a particular column

-- selecting the min and the max from the numerical volume column
SELECT MIN(volume) AS min_volume,  
       MAX(volume) AS max_volume
  FROM tutorial.aapl_historical_stock_price

-- ex) checking the Apple's lowest stock price
SELECT MIN(low) AS lowest_stock_price
  FROM tutorial.aapl_historical_stock_price
  
-- ex) checking the highest single-day increase in Apple's share value
SELECT MAX(close - open) AS single_day_increase
  FROM tutorial.aapl_historical_stock_price

--=====================================================================================================

-- AVG: calculating the average of a selected group of values
-- 1) can only be used on numerical columns
-- 2) ignores nulls completely

SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price
  WHERE high IS NOT NULL -- NO NEED TO BE USED, ACTUALLY
  
SELECT AVG(high)
  FROM tutorial.aapl_historical_stock_price

-- ex) calculting the average daily trade volume for Apple stock
SELECT AVG(volume) as avg_volume
  FROM tutorial.aapl_historical_stock_price

--=====================================================================================================

-- GROUP BY: to separate data into groups, which can be aggregated independently of one another

SELECT year,
       COUNT(*) AS count
       FROM tutorial.aapl_historical_stock_price
       GROUP BY year

SELECT year, month,
       COUNT(*) AS count
       FROM tutorial.aapl_historical_stock_price
       GROUP BY year, month -- able to group by multiple columns; but have to separate column names with commas
       

-- ex) calculating the total number of shares traded each month & ordering the results chronologically

SELECT year, month, SUM(volume) AS volume_sum
      FROM tutorial.aapl_historical_stock_price
      GROUP BY year, month
      ORDER BY year, month


SELECT year, month, SUM(volume) AS volume_sum
      FROM tutorial.aapl_historical_stock_price
      GROUP BY 1, 2 -- possible to use numbers for column names instead
      
SELECT year,
       month,
       COUNT(*) AS count
  FROM tutorial.aapl_historical_stock_price
 GROUP BY year, month -- the order of column names in group by clause doesn't matter;
 ORDER BY month, year -- but the order of column names in order by clause does matter
 
 
 -- ex) calculating the average daily price change in Apple stock, grouped by year
 
 SELECT year,
        AVG(high - low) AS avg_price_change
        FROM tutorial.aapl_historical_stock_price
        GROUP BY year
        ORDER BY year
        
        
-- ex) calculating the lowest and highest prices that Apple stock achieved each month

SELECT year, month,
       MIN(low) as lowest_price,
       MAX(high) as highest_price
       FROM tutorial.aapl_historical_stock_price
       GROUP BY year, month
       ORDER BY year, month
       
--=====================================================================================================

-- HAVING: filter on aggregate columns

SELECT year, month,
       MAX(high) AS month_high
       FROM tutorial.aapl_historical_stock_price
       GROUP BY year, month
       HAVING MAX(high) > 400
       ORDER BY year, month