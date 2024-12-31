# US Income Household Project: Data Cleaning Process

SELECT * 
FROM us_income_project.us_household_income
;

SELECT * 
FROM us_income_project.us_household_income_statistics
;


#Step 1: Fix the Column name in the statistics table
ALTER TABLE us_income_project.us_household_income_statistics RENAME COLUMN 	`ï»¿id` TO `id`;

#Step 2: Do a count of # of ID's in each table
SELECT COUNT(id)
FROM us_income_project.us_household_income
;

SELECT COUNT(id)
FROM us_income_project.us_household_income_statistics
;

#Step 3: Trying to see if there are replica ID's
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;


# Step 4: Finding the ID's that are duplicates and removing them. After deleting the statement re run prior syntax to confirm there is not any duplicates.

#Table 1: us_household_income
SELECT *
FROM (
		SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
			FROM us_household_income
	) duplicated
WHERE row_num > 1
;

DELETE FROM us_household_income
WHERE row_id IN 
(
SELECT row_id
FROM (
		SELECT row_id, id, ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
			FROM us_household_income
	 ) duplicated
WHERE row_num > 1 
)
;

#Table 2: us_household_income_statistics -- No duplicates in this table.
SELECT id, COUNT(id)
FROM us_household_income_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

#Step 5: Adjusting all of the columns in each dataset

# Table 1: State_name
SELECT State_name, COUNT(State_name)
FROM us_household_income
GROUP BY State_name
;

# OR -- DISTINCT -- still cant find the alabama error which can cause issues later on since SQL is correcting the spelling issue.
SELECT DISTINCT State_name
FROM us_household_income
;

# Updating a State in the row that is spelled incorrectly
UPDATE us_household_income
SET State_name = 'Georgia'
WHERE State_name = 'georia'
;

UPDATE us_household_income
SET State_name = 'Alabama'
WHERE State_name = 'alabama'
;

#Updating the State Abbreviation -- no abbreviation is needed
SELECT DISTINCT State_ab
FROM us_household_income
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE City = 'Vinemont' AND County = 'Autauga County' AND Place = 'Autauga County'
;


#Cleaning Type
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
ORDER BY Type
;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;


#Cleaning ALand & AWater. Checking if there are Null's, Blanks, or '0'. If there is blank data we want to describe it as 'Null'. Don't put 0's as 'Null' unless otherwise stated.
SELECT ALand, AWater
FROM us_household_income
WHERE AWater = 0 or AWater = '' OR AWater IS NULL 
;
SELECT ALand, AWater
FROM us_household_income
WHERE ALand = 0 or ALand = '' OR ALand IS NULL 
;



