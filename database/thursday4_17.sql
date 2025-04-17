
library(duckdb)
duckdb mydata.duckdb

SELECT DISTINCT Location
      FROM Site
      ORDER BY Location
      LIMIT 3;
      
      

SELECT ....
-- Other operators
-- LIKE for string matching, uses % as the wildcard character (not *)
SELECT * FROM Site WHERE Location LIKE '%Canada';
-- IS this case-sensitive matching or not? Depends on the database
SELECT * FROM Site WHERE Location LIKE '%canada';
-- LIKE is primitive matching, but nowadays everybody support regexp's
-- Common pattern: databases provide tons of functions
SELECT * FROM Site WHERE regexp_matches(Location, '.west.*');

-- 'select' expressions; i.e., you can do computation
SELECT Site_name, Area FROM Site;
SELECT Site_name, Area*2.47 FROM Site;
SELECT Site_name, aREA*2.47 AS Area_acres FROM Site;

-- You can use your database as a calculator
SELECT 2+2;

-- Strinf concatenation operator: classic one is ||, others via functoins
SELECT Site_name || ' in ' || Location FROM Site;

--AGGREGATION AND GROUPING
SELECT COUNT (*) FROM Species;

-- ^^* means number of rows
SELECT COUNT(Scientific_name) FROM Species;
-- ^^ counts number of non-NULL values
-- can also count # of distinct values

SELECT DISTINCT Relevance FROM Species;
SELECT COUNT(DISTINCT Relevance) FROM Species;

-- moving on to arithmetic operations
SELECT AVG(Area) FROM Site;
SELECT AVG(Area) FROM Site WHERE Location LIKE '%Alaska%';
-- MIN, MAX

-- A quiz: what happends when you do this?:
-- Suppose we want the largest site and its name
SELECT Site_name, MAX(Area) FROM Site;

-- introduction to grouping
SELECT Location, MAX(Area)
  FROM Site
  GROUP BY Location;
  
SELECT Location, COUNT(*), MAX(Area)
  FROM Site
  GROUP BY Location;
  
SELECT Location, COUNT(*), MAX(Area)
  FROM Site
  WHERE Location LIKE '%Canada'
  Group BY Location;
  
-- A WHERE clause limits the rows that are going in to the expressiuon at the beginning
-- A HAVING filters the groups
SELECT Location, COUNT(*) AS Count, MAX(Area) AS Max_area
  FROM Site
  WHERE Location LIKE '%Canada'
  GROUP BY Location
  HAVING Count > 1;
  
-- NULL processing
-- NULL indicates the absence of data in a table
-- But in an expression, it means unknown
SELECT COUNT(*) FROM Bird_nests;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge > 5;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge <= 5;
-- How can we find out which rows are null?
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NULL;
SELECT COUNT(*) FROM Bird_nests WHERE floatAge IS NOT NULL;

-- Joins
SELECT * FROM Camp_assignment LIMIT 10;
SELECT * FROM Personnel;
SELECT * FROM Camp_assignment JOIN Personnel
  ON Observer = Abbreviation
  LIMIT 10;
  
-- What happens?
SELECT * FROM Camp_assignment CROSS JOIN Personnel;


-- You may need to qualify column names
SELECT * FROM Camp_assignment JOIN Personnel
  ON Camp_assignment.Observer = Personnel.Abbreviation
  LIMIT 10;

-- Anotehr way is to use aliases
SELECT * FROM Camp_assignment AS CA JOIN Personnel AS P
  ON CA.Observer = P.Abbreviation
  LIMIT 10;
  
-- Relational algebra and nested queries and subqueries
SELECT COUNT(*) FROM Bird_nests;
SELECT COUNT(*) FROM (SELECT COUNT(*) FROM Bird_nests);

-- Create temp tables
CREATE TEMP TABLE nest_count AS SELECT COUNT(*) FROM Bird_nests;
.table
SELECT * FROM nest_count;
DROP TABLE nest_count;
-- another place to nest queries, in IN clauses
SELECT Observer FROM Bird_nests;
SELECT * FROM Personnel ORDER BY Abbreviation;
SELECT * FROM Bird_nests
  WHERE Observer IN (
    SELECT Abbreviation FROM Personnel
      WHERE Abbreviation LIKE 'a%'
  );






  
