--VIEWING BOTH TABLES
SELECT * FROM table1;

SELECT * FROM table2;

--PATIENT DEMOGRAPHIC FINDINGS
--1. Patient count based on gender 
SELECT count(patient_id) as Patient_Count, gender
from table1
group by gender;

--2. Parents' ethinicity vs. biosped
select count(background_father) as father_enthnicity, count(background_mother) as mother_enthnicity, biopsed
from table1
RIGHT JOIN table2 ON table1.patient_id = table2.patient_id
group by biopsed;

--3. Patient age vs. biopsed
select distinct(age) as Patient_age, biopsed
from table1
JOIN table2 ON table2.patient_id = table1.patient_id
order by age, biopsed desc;

--4. Gender vs biopsed
SELECT gender, COUNT(biopsed) as biopsed_count,
	CASE
		WHEN biopsed = true THEN 'has_cancer'
		WHEN biopsed = false THEN 'dont_have_cancer'
		ELSE 'no_relation'
	END AS Biopsed_Category
FROM table1
JOIN table2 ON table2.patient_id = table1.patient_id
GROUP BY gender, biopsed;

--PATIENT DEMOGRAPHIC LIKELIHOOD OF CANCER 

--1a. Parent's ethnicity vs. patient cancer history 
select distinct(background_father), (background_mother), count(cancer_history) as cancer_hist_count,
	CASE
		WHEN cancer_history = true THEN 'Likelihood'
		WHEN cancer_history = false THEN 'Unlikelihood'
	END AS Demographic_Cancer_Likelihood
from table1
group by background_father, background_mother, cancer_history
order by Demographic_Cancer_Likelihood desc;

--2. smoke & drink vs. Gender
select gender, count(smoke) as count_smoke, count(drink) as count_drink,
	CASE
		WHEN drink AND SMOKE = true then 'cancerous_smoke_drink_true'
		WHEN smoke = true then 'cancerous_smoke_true'
		WHEN drink = true then 'cancerous_drink_true'
		ELSE 'noncancerous'
	end as smoking_driniking_rating
from table1
RIGHT JOIN table2 ON table2.patient_id=table1.patient_id
GROUP BY gender, drink, smoke
ORDER BY smoking_driniking_rating;

--3. Percentage of patient with family history 
--a
select gender, 
count(
	CASE 
		WHEN skin_cancer_history = true THEN 1 END) as skin_cancer_count
from table1
group by gender;

--b
select gender, 
count(
	CASE 
		WHEN skin_cancer_history = true THEN 1 END)*100.0/count(*) as percentage_skin_cancer
from table1
group by gender;


--LEISURE CHARACTERISTICS FINDINGS
--1. Average diameter 1 & 2 on biopsy
SELECT AVG(diameter_1) as Average_diameter1, AVG(diameter_2) as Average_diameter2, biopsed 
FROM table2
GROUP BY biopsed;

--2. Count of diagnosis vs. biopsed and gender
SELECT diagnostic, count(diagnostic) as diagnostic_count, biopsed, gender
FROM table2
RIGHT JOIN table1 ON table1.patient_id=table2.patient_id
GROUP BY diagnostic, biopsed, gender
ORDER BY diagnostic;

--3. Biopsed by region
SELECT region, count(region) as region_count, biopsed
from table2
GROUP BY region, biopsed
ORDER BY biopsed;

--LEISURE CHARACTERISTICS - LIKELIHOOD OF CANCER
--1. Count of patient that smoke, drink vs. biosped, diagnostic, fitspatrick
SELECT count(smoke) AS smoke_count, count(drink)AS drink_count, smoke, drink, biopsed, diagnostic, fitspatrick,
	CASE
		WHEN biopsed = true THEN 'Has_Cancer'
		ELSE 'no_cancer'
	END AS patient_s_d_count
FROM table1
LEFT JOIN table2 ON table2.patient_id = table1.patient_id
GROUP BY smoke, drink, biopsed, diagnostic, fitspatrick
ORDER BY patient_s_d_count;

--ENVIRONMENTAL FACTOR - FINDINGS
--1. Pesticide exposure of patient by gender
SELECT pesticide, biopsed, COUNT(pesticide) as pesticide_count
FROM table1
JOIN table2 ON table2.patient_id = table1.patient_id
GROUP BY pesticide, biopsed
ORDER BY pesticide, biopsed;

--2. Count of patient by diagnostic, biopsed, access to piped water, 
--sewage system, cancer history, skin cancer history, skin type etc - I NEED TO DO MORE JOB ON THIS QUERY
SELECT has_piped_water, has_sewage_system, biopsed, diagnostic, cancer_history, skin_cancer_history, fitspatrick,
COUNT(has_piped_water) AS pipewater_count, COUNT(has_sewage_system) AS sewage_count, 
COUNT(diagnostic) as diagnostic_count, COUNT(cancer_history) AS cancer_hist_count, 
COUNT(skin_cancer_history) as skin_cancer_count, COUNT(fitspatrick) as fitspatrick_count
FROM table1
JOIN table2 ON table2.patient_id = table1.patient_id
GROUP BY has_piped_water, has_sewage_system, biopsed, diagnostic, cancer_history, skin_cancer_history, fitspatrick
ORDER BY diagnostic;


--DIFFERENT TYPE OF SKIN CANCER FINDINGS
--1. Categorizing the gender, fitspatrick base on skin type
SELECT count(gender) as Gender_Count, count(fitspatrick) as Fitspatrick_Count, gender, fitspatrick, 
	CASE 
		WHEN fitspatrick =0 THEN 'Unknown'	
		WHEN fitspatrick <=3 THEN 'High risk of skin cancer'
		WHEN fitspatrick <=6 THEN 'Lower risk of skin cancer'
		ELSE 'Unknown'
	END AS category_of_fitspatrick
FROM table2
JOIN table1 ON table2.patient_id = table1.patient_id
GROUP BY gender, fitspatrick
ORDER BY gender;

--2. Age of patient vs. skin type
SELECT fitspatrick, count(fitspatrick) as fitspatrick_count, age, count(distinct(age)) as age_count
FROM table1
LEFT JOIN table2 ON table1.patient_id = table2.patient_id
GROUP BY age, fitspatrick
ORDER by age desc;
--please note: the majority of patients have skin type of 0-3, just like 30% of them have the skin type of 4-5


--DIFFERENT TYPE OF SKIN CANCER LIKELIHOOD OF CANCER
--1. Analysis smoking and drinking vs. skin type (fitspatrick) 
SELECT smoke, drink, fitspatrick, count(smoke) AS smoke_count, count(drink)AS drink_count, 
count(fitspatrick) AS fitspatrick_count
FROM table1
JOIN table2 ON table1.patient_id = table2.patient_id
GROUP BY smoke, drink, fitspatrick
order BY smoke_count, drink_count,fitspatrick_count;

--2. Skin cancer history vs. patient that smoke and drink with their skin type and biosped
SELECT skin_cancer_history, cancer_history, smoke, drink, fitspatrick, biopsed, 
count(skin_cancer_history) AS skin_hist, count(cancer_history) AS cancer_hist,  
count(smoke) AS smoke_count, count(drink) AS drink_count, COUNT(fitspatrick) AS count_fitspatrick 
FROM table1
JOIN table2 ON table1.patient_id = table2.patient_id
GROUP BY skin_cancer_history, cancer_history, smoke, drink, fitspatrick, biopsed
ORDER BY skin_hist, cancer_hist, smoke_count, drink_count, fitspatrick desc;











