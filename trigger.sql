-- SQLite looks a lot like DuckDB
.schema
.tables
SELECT * FROM Species;
.nullvalue -NULL-
--The problem we're going to try to fix:
INSERT INTO Species VAlUES ('abcd', 'thing1','' ,'Study species');
SELECT * FROM Species;

-- Time to create our trigger!
CREATE TRIGGER  Fix_up_species
AFTER INSERT ON Species
FOR EACH ROW    
BEGIN
    UPDATE Species
        SET Scientific_name = NULL
        WHERE Code = new.Code AND Scientific_name = '';
        END;

-- Let's test it!
INSERT INTO species 
    VALUES ('efgh', 'thing2', '', 'Study species');
SELECT * FROM Species;
.schema