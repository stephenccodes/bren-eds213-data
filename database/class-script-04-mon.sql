.tables
SELECT Nest_ID, COUNT(*) FROM Bird_eggs
   GROUP BY Nest_ID;
.maxrows 8
SELECT Species FROM Bird_nests WHERE Site = 'nome';
SELECT Species, COUNT(*) AS Nest_count
   FROM Bird_nests
   WHERE Site = 'nome'
   GROUP BY Species
   ORDER BY Species
   LIMIT 2;
-- can nest queries
SELECT Scientific_name, Nest_count FROM
   (SELECT Species, COUNT(*) AS Nest_count
   FROM Bird_nests
   WHERE Site = 'nome'
   GROUP BY Species
   ORDER BY Species
   LIMIT 2) JOIN Species ON Species = Code;
   -- outer joins
   CREATE TEMP TABLE a (
   cola INTEGER, 
   common INTEGER
   );
   INSERT INTO a VALUES (1, 1), (2, 2), (3, 3);
   SELECT * FROM a;
   
   CREATE TEMP TABLE b (common INTEGER, colb INTEGER);
   INSERT INTO b VALUES (2, 2), (3, 3), (4, 4), (5, 5);
   SELECT * FROM b;
   
   -- inner join
   --- The joinds we've been doing so far have been "inner" joins
   SELECT * FROM a JOIN B USING (common);
   SELECT * FROM a INNER JOIN b USING (common);
   SELECT * FROM a JOIN b ON a.common = b.common;
   
   -- By doing an "outer" join --- eother "left: or "right" -- we'll add certain missing rows
   -- left or right outer join
   SELECT * FROM a LEFT JOIN b USING (common);
   SELECT * FROM a RIGHT JOIN b ON a.common = b.common;
     
   --A running example: what species do *not* have any nest data?   
   SELECT COUNT(*) FROM Species;
   SELECT COUNT(DISTINCT Species) FROM Bird_nests;
   -- Method 1
   SELECT Code FROM Species
    WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
  SELECT Code FROM Species
    WHERE Code NOT IN (SELECT Species FROM Bird_nests);
    
    
  -- Method 2
  SELECT * FROM Species LEFT JOIN Bird_nests
    ON Code = Species;
    WHERE Species IS NULL;
  
  -- It's also possible to join a table wit itself, a so-called "self-join"
  
  -- Understanding a limitation of DuckDB
  SELECT Nest_ID, COUNT(*
    FROM Bird_nests JOIN Bird_eggs
    USING  (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;
    
-- Let's ADD IN Observer
SELECT Nest_ID, Observer, COUNT(*) AS Num_eggs
  FROM Bird_nests JOIN Bird_eggs
  USING (NEST_ID)
  WHERE Nest_ID LIKE '13b%'
  GROUP BY Nest_ID;
  
SELECT * FROM Bird_nests JOIN Bird_eggs
  USING (Nest_ID)
  WHERE Nest_ID LIKE '13B%';
  
  
-- DuckDB solution #1
SELECR NEST_iD, Obserrvser, COUNT(*) AS Num_eggs
  GROUP BY Nest_ID
  
  .....
  
  
-- DuckDB solutioun #2
SELECT Nest_ID, ANY_VALUE(Observer) as Observer, COUNT(*) AS Num_eggs
  FROM Bird_nests JOIN Bird_eggs
  USING (Nest_ID)
  WHERE Nest_ID LIKE '13B%'
  GROUP BY Nest_ID;
  
-- Views: a virtual table
  CREATE VIEW my_nests AS 
    SELECT Nest_ID, ANY_VALUE(Observer) as Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;

.tables
SELECT * FROM my_nests;
SELECT Nest_ID, Name, Num_EGGS
  FROM my_nests JOIN Personnel
  ON Observer = Abbreviation;
  
-- view
-- temp table
-- what's the diff?
CREATE TEMP TABLE my_nests AS 
    SELECT Nest_ID, ANY_VALUE(Observer) AS Observer, COUNT(*) AS Num_eggs
    FROM Bird_nests JOIN Bird_eggs
    USING (Nest_ID)
    WHERE Nest_ID LIKE '13B%'
    GROUP BY Nest_ID;
.table

-- What about modifications (inserts, updates, deeltes) on a view? Possible?
-- It depends
-- Whether it's theoretically possible
-- How smart the database is

-- Last topic: set operations
-- UNION, UNION ALL, INTERSECT, EXCEPT

SELECT * FROM Bird_eggs LIMIT 5;

SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length*25.4 AS Length, Width*25.4 AS Width
    FROM Bird_eggs
    WHERE Book_PAGE LIKE 'b14%'
UNION
SELECT Book_page, Year, Site, Nest_ID, Egg_num, Length, Width
    FROM Bird_EGGS
    WHERE Book_page NOT LIKE 'b14%';


# Method #3 for running example
SELECT Code FROM Species
EXCEPT
SELECT DISTINCT Species FROM Bird_nests;


     .nullvalue -NULL-
   .nullvalue ''
   SELECT * FROM a RIGHT JOIN b USING (common);
   -- What species do *not* have nest data?
   SELECT * FROM Species
      WHERE Code NOT IN (SELECT DISTINCT Species FROM Bird_nests);
    -- Let's do the same using an outer join
SELECT Code, Scientific_name, Nest_ID, Species, Year
   FROM Species LEFT JOIN Bird_nests ON Code = Species;
.nullvalue -NULL-
SELECT COUNT(*) FROM Bird_nests WHERE Species = 'ruff';
SELECT Code, Scientific_name, Nest_ID, Species, Year
   FROM Species LEFT JOIN Bird_nests ON Code = Species
   WHERE Nest_ID IS NULL;
-- a gotcha when doing grouping
SELECT * FROM Bird_eggs LIMIT 3;
SELECT * FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01';
SELECT Nest_ID, COUNT(*)
   FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01'
   GROUP BY Nest_ID;
-- but what about this?
-- gives an error, doesn't make sense
SELECT Nest_ID, COUNT(*), Length
   FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01'
   GROUP BY Nest_ID;
--- what about this now?
SELECT Nest_ID, Species, COUNT(*)
   FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01'
   GROUP BY Nest_ID;
-- workaround #1
SELECT Nest_ID, Species, COUNT(*)
   FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01'
   GROUP BY Nest_ID, Species;
-- workaround #2
SELECT Nest_ID, ANY_VALUE(Species), COUNT(*)
   FROM Bird_nests JOIN Bird_eggs USING (Nest_ID)
   WHERE Nest_ID = '14eabaage01'
   GROUP BY Nest_ID;
-- views
SELECT * FROM Camp_assignment;
SELECT Year, Site, Name, Start, "End"
   FROM Camp_assignment JOIN Personnel
   ON Observer = Abbreviation;
CREATE VIEW v AS
   SELECT Year, Site, Name, Start, "End"
   FROM Camp_assignment JOIN Personnel
   ON Observer = Abbreviation;
-- a view looks just like a table, but it's not real
SELECT * FROM v;
CREATE VIEW v2 AS SELECT COUNT(*) FROM Species;
SELECT * FROM v2;
-- set operations: UNION, INTERSECT, EXCEPT
-- iffy example
SELECT Book_page, Nest_ID, Egg_num, Length, Width FROM Bird_eggs;
SELECT Book_page, Nest_ID, Egg_num, Length*25.4, Width*25.4 FROM Bird_eggs
   WHERE Book_page = 'b14.6'
   UNION
SELECT Book_page, Nest_ID, Egg_num, Length, Width, FROM Bird_eggs
   WHERE Book_page != 'b14.6';
-- UNION vs UNION ALL
-- just mashes tables together; not intelligent
-- Third way to answer: Which species have no nest data?
SELECT Code FROM Species
   EXCEPT SELECT DISTINCT Species FROM Bird_nests;
DROP VIEW v;