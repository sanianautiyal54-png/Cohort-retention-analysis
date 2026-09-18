create database online_retail

select top(10)*from onlineretail

-- Step 1: Clean raw transactional data in SQL Server
WITH cleaned_retail AS (
    SELECT
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country
    FROM onlineretail
    WHERE Customer_ID IS NOT NULL
      AND Quantity > 0
      AND Price > 0
      AND Invoice NOT LIKE 'C%'  -- Exclude cancellations
)
SELECT * FROM cleaned_retail;

-- Step 2: Find cohort start month and calculate months elapsed (cohort_index)
WITH cleaned_retail AS (
    SELECT
        Customer_ID,
        InvoiceDate
    FROM onlineretail
    WHERE Customer_ID IS NOT NULL
      AND Quantity > 0
      AND Price > 0
      AND Invoice NOT LIKE 'C%'
),

-- Identify customer's first purchase month
customer_first_purchase AS (
    SELECT
        Customer_ID,
        DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) AS cohort_month
    FROM cleaned_retail
    GROUP BY Customer_ID
),

-- Link transactions to cohort and compute month index using DATEDIFF
customer_monthly_activity AS (
    SELECT DISTINCT
        r.Customer_ID,
        c.cohort_month,
        DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1) AS purchase_month,
        DATEDIFF(month, c.cohort_month, DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1)) AS cohort_index
    FROM cleaned_retail r
    INNER JOIN customer_first_purchase c
        ON r.Customer_ID = c.Customer_ID
)
SELECT * FROM customer_monthly_activity;

-- Step 3: Retention percentage calculation per cohort and index
WITH cleaned_retail AS (
    SELECT
        Customer_ID,
        InvoiceDate
    FROM onlineretail
    WHERE Customer_ID IS NOT NULL
      AND Quantity > 0
      AND Price > 0
      AND Invoice NOT LIKE 'C%'
),

customer_first_purchase AS (
    SELECT
        Customer_ID,
        DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) AS cohort_month
    FROM cleaned_retail
    GROUP BY Customer_ID
),

cohort_activity AS (
    SELECT
        c.cohort_month,
        DATEDIFF(month, c.cohort_month, DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1)) AS cohort_index,
        COUNT(DISTINCT r.Customer_ID) AS active_customers
    FROM cleaned_retail r
    INNER JOIN customer_first_purchase c
        ON r.Customer_ID = c.Customer_ID
    GROUP BY 
        c.cohort_month,
        DATEDIFF(month, c.cohort_month, DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1))
),

cohort_base_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM cohort_activity
    WHERE cohort_index = 0
)

SELECT
    FORMAT(ca.cohort_month, 'yyyy-MM') AS cohort,
    ca.cohort_index,
    ca.active_customers,
    cb.cohort_size,
    ROUND((CAST(ca.active_customers AS FLOAT) / cb.cohort_size) * 100.0, 2) AS retention_rate_pct
FROM cohort_activity ca
INNER JOIN cohort_base_size cb
    ON ca.cohort_month = cb.cohort_month
ORDER BY 
    ca.cohort_month, 
    ca.cohort_index;

    -- Step 4: Pivoted cohort retention matrix (Months 0 to 12)
WITH cleaned_retail AS (
    SELECT
        Customer_ID,
        InvoiceDate
    FROM onlineretail
    WHERE Customer_ID IS NOT NULL
      AND Quantity > 0
      AND Price > 0
      AND Invoice NOT LIKE 'C%'
),

customer_first_purchase AS (
    SELECT
        Customer_ID,
        DATEFROMPARTS(YEAR(MIN(InvoiceDate)), MONTH(MIN(InvoiceDate)), 1) AS cohort_month
    FROM cleaned_retail
    GROUP BY Customer_ID
),

cohort_activity AS (
    SELECT
        c.cohort_month,
        DATEDIFF(month, c.cohort_month, DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1)) AS cohort_index,
        COUNT(DISTINCT r.Customer_ID) AS active_customers
    FROM cleaned_retail r
    INNER JOIN customer_first_purchase c
        ON r.Customer_ID = c.Customer_ID
    GROUP BY 
        c.cohort_month,
        DATEDIFF(month, c.cohort_month, DATEFROMPARTS(YEAR(r.InvoiceDate), MONTH(r.InvoiceDate), 1))
),

cohort_base_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM cohort_activity
    WHERE cohort_index = 0
)

SELECT
    CONVERT(VARCHAR(7), ca.cohort_month, 120) AS cohort,
    cb.cohort_size,
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 0  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 0],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 1  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 1],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 2  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 2],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 3  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 3],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 4  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 4],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 5  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 5],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 6  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 6],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 7  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 7],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 8  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 8],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 9  THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 9],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 10 THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 10],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 11 THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 11],
    ROUND(100.0 * MAX(CASE WHEN ca.cohort_index = 12 THEN ca.active_customers END) / cb.cohort_size, 1) AS [Month 12]
FROM cohort_activity ca
INNER JOIN cohort_base_size cb
    ON ca.cohort_month = cb.cohort_month
GROUP BY 
    ca.cohort_month, 
    cb.cohort_size
ORDER BY 
    ca.cohort_month;