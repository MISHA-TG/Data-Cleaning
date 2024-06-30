# Data Cleaning with MySQL

## Project Overview

This project involves cleaning and preparing a dataset stored in a MySQL database. The primary objectives of the project were to remove duplicate records, standardize data values, handle null values, and ensure data integrity.

## Objectives

- **Remove Duplicates**: Identified and removed duplicate records from the dataset.
- **Standardize Data**: Standardized inconsistent data entries to maintain uniformity across the dataset.
- **Handle Null Values**: Identified and handled null values to ensure data completeness.
- **Data Transformation**: Transformed date formats and other fields to ensure consistency and accuracy.

## Technologies Used

- **Database**: MySQL
- **SQL Techniques**: Common Table Expressions (CTEs), Window Functions, Data Manipulation and Transformation

## Steps and SQL Queries

### 1. Removing Duplicates

Duplicate records were identified using a Common Table Expression (CTE) and the `ROW_NUMBER()` window function:

```sql
WITH test_cte AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
    FROM layoffs_staging
)
SELECT * 
FROM test_cte 
WHERE row_num > 1;
```

### 2. Standardizing Data

Standardized various fields such as `company`, `industry`, and `country` to ensure consistency:

```sql
UPDATE layoffs_staging2
SET company = TRIM(company);

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET country = 'United States'
WHERE country = 'United States.';
```

### 3. Handling Null Values

Identified and handled null values to ensure data completeness:

```sql
SELECT * 
FROM layoffs_staging2
WHERE company IS NULL OR location IS NULL OR industry IS NULL;

-- Example of handling null values by replacing them with a default value
UPDATE layoffs_staging2
SET company = 'Unknown'
WHERE company IS NULL;

UPDATE layoffs_staging2
SET location = 'Unknown'
WHERE location IS NULL;

UPDATE layoffs_staging2
SET industry = 'Unknown'
WHERE industry IS NULL;
```

### 4. Transforming Data Formats

Transformed the `date` field to a standard date format:

```sql
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
```

## Conclusion

This project highlights the importance of data cleaning and preparation in maintaining the integrity and usability of data for analysis. By using MySQL, we efficiently removed duplicates, standardized data values, handled null values, and transformed data formats to ensure consistency across the dataset.

