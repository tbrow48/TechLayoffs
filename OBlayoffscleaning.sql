SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Look at Null values or blank values
-- 4. Remove columns

CREATE TABLE layoffs_raw
LIKE layoffs;

SELECT *
FROM layoffs_raw;

INSERT layoffs_raw
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_raw;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_raw
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM layoffs_raw
WHERE company = 'Casper';

CREATE TABLE `layoffs_raw2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_raw2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_raw2
WHERE row_num > 1;

SELECT *
FROM layoffs_raw2
WHERE row_num > 1;

INSERT INTO layoffs_raw2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_raw;

SELECT *
FROM layoffs_raw2;

-- All Duplicates have been deleted

-- Stardardizing Data

SELECT company, TRIM(company)
FROM layoffs_raw2;

UPDATE layoffs_raw2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_raw2
ORDER BY industry;

SELECT *
FROM layoffs_raw2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_raw2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_raw2
ORDER BY country;

UPDATE layoffs_raw2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT date
FROM layoffs_raw2;

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_raw2;

UPDATE layoffs_raw2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_raw2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_raw2
WHERE total_laid_off = 'None'
AND percentage_laid_off = 'None';

SELECT *
FROM layoffs_raw2
WHERE industry = 'None'
OR industry = '';

SELECT l1.industry, l2.industry
FROM layoffs_raw2 l1
JOIN layoffs_raw2 l2 ON 
	l1.company = l2.company
    AND l1.location = l2.location
WHERE (l1.industry = 'None' OR l1.industry = '' OR l1.industry IS NULL)
AND (l2.industry != 'None' OR l2.industry IS NOT NULL);

UPDATE layoffs_raw2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_raw2 l1
JOIN layoffs_raw2 l2
	ON l1.company = l2.company
SET l1.industry = l2.industry
WHERE (l1.industry = 'None' OR l1.industry = '' OR l1.industry IS NULL)
AND (l2.industry != 'None' OR l2.industry IS NOT NULL);

SELECT * 
FROM layoffs_raw2
WHERE company = 'Airbnb';

SELECT * 
FROM layoffs_raw2
WHERE total_laid_off = 'None'
AND percentage_laid_off = 'None';

DELETE
FROM layoffs_raw2
WHERE total_laid_off = 'None'
AND percentage_laid_off = 'None';

SELECT * 
FROM layoffs_raw2;

ALTER TABLE layoffs_raw2
DROP COLUMN row_num;

UPDATE layoffs_raw2
SET total_laid_off = NULL
WHERE total_laid_off = 'None';

UPDATE layoffs_raw2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'None';

UPDATE layoffs_raw2
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'None';

ALTER TABLE layoffs_raw2
MODIFY COLUMN `percentage_laid_off` FLOAT;

ALTER TABLE layoffs_raw2
MODIFY COLUMN `total_laid_off` INT;

ALTER TABLE layoffs_raw2
MODIFY COLUMN `funds_raised_millions` INT;

SELECT * 
FROM layoffs_raw2;
