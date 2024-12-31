# US Income Household Income Explanatory Data Analysis
SELECT * 
FROM us_household_income
;

SELECT * 
FROM us_household_income_statistics
;

#State Level: Top 10 States with the Most Land
SELECT State_Name, SUM(ALand) AS sum_land, SUM(AWater) AS sum_water
FROM us_household_income
GROUP BY State_Name
ORDER BY sum_land DESC
LIMIT 10
;

#Inner Joining the tables together to capture all of the data. 
# It is important to exhaust all options when joining data so all is captured. Pay attention to when importing data...
#... into SQL. Not all data may transfer. This will negatively effect data analysis.
SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM us_household_income u
INNER JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE Mean <> 0
;

# State Level: Top 10 Mean & Median Income at The State Level. In Descending Order.
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Type Level: Top 10 Communities at The Type Level. 
# Qualifications: 30 or More participants required.
SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u
INNER JOIN us_household_income_statistics s 
	ON u.id = s.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(TYPE) > 30
ORDER BY 4 DESC
LIMIT 10
;

# City Level: Top 10 Wealthiest Cities. 
# Qualifications: 30 or More participants required in the City.
SELECT u.State_Name, City, COUNT(City), ROUND(AVG(Mean),2), ROUND(AVG(Median),2) 
FROM us_household_income u
 JOIN us_household_income_statistics s 
	ON u.id = s.id
GROUP BY u.State_Name, City
HAVING COUNT(TYPE) > 30
ORDER BY 4 DESC
LIMIT 10
;
























































