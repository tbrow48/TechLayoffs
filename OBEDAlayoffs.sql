-- Exploratory Data Analysis of Layoffs from 2020 - 2023

SELECT * 
FROM layoffs_raw2;

SELECT MAX(total_laid_off)
FROM layoffs_raw2;

SELECT *
FROM layoffs_raw2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_raw2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date)
FROM layoffs_raw2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY stage
ORDER BY 2 DESC;

SELECT YEAR(date), MONTH(date), SUM(total_laid_off)
FROM layoffs_raw2
WHERE YEAR(date) is NOT NULL
GROUP BY YEAR(date), MONTH(date)
ORDER BY 3 DESC;

With Rolling_Total AS(
SELECT YEAR(date) AS year, MONTH(date) AS month, SUM(total_laid_off) AS layoffs
FROM layoffs_raw2
WHERE YEAR(date) is NOT NULL
GROUP BY YEAR(date), MONTH(date)
ORDER BY 1, 2 DESC
)
SELECT year, month, layoffs, SUM(layoffs) OVER(ORDER BY year, month) AS rolling_total
FROM Rolling_Total;

SELECT company,YEAR(date) AS year,SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY company, year
ORDER BY 3 DESC;

WITH Company_Year (company, year, total_laid_off) AS(
SELECT company,YEAR(date) AS year,SUM(total_laid_off)
FROM layoffs_raw2
GROUP BY company, year
ORDER BY 3 DESC
), Company_Rank_Layoffs AS(
SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS rank_layoffs
FROM Company_Year
WHERE year is NOT NULL
)
SELECT * 
FROM Company_Rank_Layoffs
WHERE rank_layoffs <= 5;