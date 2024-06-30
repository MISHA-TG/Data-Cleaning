-- DELETING DUPLICATES


SELECT*
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT*
FROM layoffs;

SELECT* 
FROM layoffs_staging;

WITH test_cte AS
(
SELECT*, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)
AS row_num
FROM layoffs_staging
)
SELECT*
FROM test_cte
WHERE row_num>1;

SELECT* 
FROM layoffs_staging
WHERE company='Better.com';


CREATE TABLE `layoffs_staging2` (
  `company` varchar(29) DEFAULT NULL,
  `location` varchar(16) DEFAULT NULL,
  `industry` varchar(15) DEFAULT NULL,
  `total_laid_off` varchar(14) DEFAULT NULL,
  `percentage_laid_off` varchar(19) DEFAULT NULL,
  `date` varchar(10) DEFAULT NULL,
  `stage` varchar(14) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `funds_raised_millions` varchar(21) DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

SELECT* 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT*, ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions)
AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES=0;
DELETE
FROM layoffs_staging2
WHERE row_num>1;
SET SQL_SAFE_UPDATES=1;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;



-- STANDARDIZING DATA

SELECT DISTINCT(company)
FROM layoffs_staging2;

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT DISTINCT(location)
FROM layoffs_staging2;

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry='Crypto'
WHERE industry LIKE 'crypto%';

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country='United States'
WHERE country='United States.';

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;




-- NULL VALUES


SELECT* 
FROM layoffs_staging2
WHERE total_laid_off=''
AND percentage_laid_off='';

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry='';

SELECT*
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry='')
AND t2.industry!='';

SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
WHERE (t1.industry='')
AND t2.industry!='';

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry=t2.industry
WHERE (t1.industry='')
AND t2.industry!='';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

DELETE
FROM layoffs_staging2
WHERE company LIKE 'Bally%'
AND `date`=0000-00-00;

DELETE
FROM layoffs_staging2
WHERE total_laid_off=''
AND percentage_laid_off='';

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
