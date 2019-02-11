-- SELECT DISTINCT: looking at only the unique values in a particular column

SELECT DISTINCT year, month -- only need to include DISTINCT once in a SELECT clause
  FROM tutorial.aapl_historical_stock_price
  ORDER BY year, month

SELECT DISTINCT year
  FROM tutorial.aapl_historical_stock_price
  ORDER BY year

-- Using DISTINCT in aggregations

SELECT COUNT(DISTINCT month) AS unique_months -- counts the unique values in the month column
  FROM tutorial.aapl_historical_stock_price

SELECT month,
  AVG(volume) AS avg_trade_volume
  FROM tutorial.aapl_historical_stock_price
  GROUP BY month
  ORDER BY 2 DESC
  
-- cf.) using DISTINCT, particularly in aggregations, can slow your queries down quite a bit.

-- ex) counting the number of unique values in the month column for each year

SELECT year, COUNT(DISTINCT month) AS months_count
  FROM tutorial.aapl_historical_stock_price
  GROUP BY year
  ORDER BY year

-- ex) separately counting the no. of unique values in the month column 
-- & the no. of unique values in the year column

SELECT COUNT(DISTINCT year) AS year_count, COUNT(DISTINCT month) AS month_count
  FROM tutorial.aapl_historical_stock_price

--=====================================================================================================

-- CASE: handling if/then logic

SELECT player_name, -- retrieving & displaying all the values in the `player_name` & `year` columns
       year,
       CASE WHEN year = 'SR' THEN 'yes' -- checking each row to see if the conditional statment is true
       ELSE NULL END AS is_a_senior -- if the conditional statement if true, the word 'yes' gets printed in the `is_a_senior` column
       FROM benn.college_football_players -- if not, nothing happens in that row, leaving a null value in the `is_a_senior` column


-- ex) including a column that is flagged `yes` when a player is from CA, and sorting the results with those players first

SELECT player_name, state,
       CASE WHEN state = 'CA' Then 'yes'
       ELSE NULL AS from_california
  FROM benn.college_football_players
  ORDER BY 3
  
-- Adding multiple conditions to a CASE statement

SELECT player_name,
       weight,
       CASE WHEN weight > 250 THEN 'over 250'
       WHEN weight > 200 THEN '201-250'
       WHEN weight > 175 THEN '176-200'
       ELSE '175 or under' END AS weight_group
      FROM benn.college_football_players 
      
-- ex) query including players' names & a column classifying them into four categories

SELECT player_name, height,
       CASE WHEN height > 200 THEN 'over 200'
       WHEN height >180 AND height <= 200 THEN '181-200'
       WHEN height >160 AND height <= 180 THEN '161-180'
       ELSE '160 or under' END AS height_group
       FROM benn.college_football_players

-- Using CASE w/ aggregate functions

SELECT CASE WHEN year = 'FR' THEN 'FR'
      ELSE 'Not FR' END AS year_group,
      COUNT(1) AS count -- only counting rows that fulfill a certain condition
      FROM benn.college_football_players
      GROUP BY CASE WHEN year = 'FR' THEN 'FR'
      ELSE 'Not FR' END

SELECT COUNT(1) AS fr_count
  FROM benn.college_football_players
  WHERE year = 'FR' -- using the WHERE clause only allows you to count one condition
  
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
  GROUP BY 1
  
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
  GROUP BY year_group
  
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            * -- replace the * with an aggregation and add a GROUP BY CLAUSE
  FROM benn.college_football_players
  
  
-- a query that counts the number of 300lb+ players for each of the following regions: 
-- West Coast (CA, OR, WA), Texas, and Other (Everywhere else).

SELECT CASE WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
            WHEN state = 'TX' THEN 'Texas'
            ELSE 'Other' END AS arbitrary_regional_designation,
            COUNT(1) AS players
  FROM benn.college_football_players
  WHERE weight >= 300
  GROUP BY 1
  
-- a query that calculates the combined weight of all underclass players (FR/SO) in California 
-- as well as the combined weight of all upperclass players (JR/SR) in California.

SELECT CASE WHEN year IN ('FR', 'SO') THEN 'underclass'
            WHEN year IN ('JR', 'SR') THEN 'upperclass'
            ELSE NULL END AS class_group,
            SUM(weight) AS combined_player_weight
            FROM benn.college_football_players
            WHERE state = 'CA'
            GROUP BY 1
            
-- Using CASE inside of aggregate functions: `pivoting`

SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
            FROM benn.college_football_players
            GROUP BY 1
            
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players
  
-- ex) a query that displays the number of players in each state, 
-- with FR, SO, JR, and SR players in separate columns and another column for the total number of players. 
-- Order results such that states with the most players come first.

SELECT state,
       COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count,
       COUNT(1) AS total_players
  FROM benn.college_football_players
 GROUP BY state
 ORDER BY total_players DESC
 
-- ex) a query that shows the number of players at schools with names that start with A through M, 
-- and the number at schools with names starting with N - Z.

SELECT CASE WHEN school_name < 'n' THEN 'A-M'
            WHEN school_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS school_name_group,
       COUNT(1) AS players
  FROM benn.college_football_players
 GROUP BY 1
