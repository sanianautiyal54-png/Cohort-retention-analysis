# Cohort & Retention Analysis

## Project Overview

This project analyzes customer purchasing behavior using cohort analysis to understand how customer retention changes over time.

The analysis uses the **Online Retail dataset** and focuses on grouping customers according to their first purchase month, then measuring how many customers continue purchasing in the following months.

**Tools used:** Python, Pandas, SQL, Excel, and Google Colab.

## Task Objective

The main objective is to:

- Group customers by their first purchase month
- Build cohort tables
- Calculate customer retention month over month
- Create a cohort retention heatmap
- Create a retention curve comparing at least two cohorts
- Generate 3–5 business insights from the retention patterns

## Dataset

The project uses the **Online Retail dataset from the UCI Machine Learning Repository**. It contains transaction data for a UK-based online retailer from 1 December 2010 to 9 December 2011. Important fields include InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, and Country. citeturn0search1

Dataset: https://archive.ics.uci.edu/dataset/352/online+retail

## Project Workflow

```text
Online Retail Dataset
        ↓
Data Cleaning
        ↓
SQL Analysis
        ↓
Customer First Purchase Month
        ↓
Cohort Assignment
        ↓
Months Since First Purchase
        ↓
Retention Calculation
        ↓
Cohort Retention Table
        ↓
Retention Heatmap
        ↓
Retention Curve
        ↓
Business Insights
```

## Data Cleaning

The data preparation included:

- Handling missing CustomerID values
- Converting InvoiceDate into a proper date/time format
- Removing cancellation transactions
- Checking invalid or non-positive quantities where appropriate
- Checking invalid unit prices
- Creating month fields required for cohort analysis

The dataset identifies cancellations using invoice numbers beginning with `C`. citeturn0search1

## SQL Analysis

SQL was used to prepare the customer-level cohort data and perform the main analysis.

The SQL work included:

- Finding unique customers
- Finding each customer's first purchase date
- Finding each customer's first purchase month
- Assigning customers to cohorts
- Calculating purchase months
- Calculating months since first purchase
- Counting active customers by cohort and month
- Preparing data for the retention table

### Cohort Logic

Each customer is assigned to the month in which they made their first purchase.

Example:

```text
Customer A → First purchase: January 2011
Customer B → First purchase: February 2011
Customer C → First purchase: February 2011

January 2011 → Cohort
February 2011 → Cohort
```

## Retention Calculation

Retention is calculated as:

```text
Retention % =
Customers Active in Month N
÷
Customers in the Original Cohort
× 100
```

For example, if a cohort has 1,000 customers initially and 400 purchase again in Month 1:

```text
400 / 1000 × 100 = 40%
```

## Cohort Retention Heatmap

The heatmap uses:

- **Rows:** Cohort / first purchase month
- **Columns:** Months since first purchase
- **Values:** Retention percentage

This visual helps show how customer retention changes across different cohorts and lifecycle months.

## Retention Curve

A retention curve compares at least two cohorts using:

- **X-axis:** Months since first purchase
- **Y-axis:** Retention percentage
- **Lines:** Selected customer cohorts

This makes it possible to compare how different cohorts behave over the same customer lifecycle.

## Python / Google Colab

Python was used in Google Colab for:

- Reading the dataset
- Cleaning the transaction data
- Creating cohort fields
- Calculating retention
- Creating the cohort table
- Creating the retention heatmap
- Creating the retention curve

Main libraries:

```python
import pandas as pd
import matplotlib.pyplot as plt
```

The Google Colab notebook is included in the repository.

## Deliverables

The project contains:

1. **Cohort retention table / heatmap**
2. **Retention curve comparing at least two cohorts**
3. **3–5 business insights based on the results**

## Business Insights

The final insights are based on the actual analysis results.

The analysis looks at:

- How quickly retention decreases after the first purchase
- Which cohorts maintain stronger retention over subsequent months
- Whether newer cohorts show improving or declining retention
- Where the largest customer drop-off occurs
- Whether retention patterns are consistent across cohorts

## Repository Structure

```text
cohort-retention-analysis/
│
├── data/
│   └── Online_Retail.xlsx
│
├── sql/
│   └── cohort_analysis.sql
│
├── python/
│   └── cohort_analysis.ipynb
│
├── outputs/
│   ├── cohort_heatmap.png
│   └── retention_curve.png
│
├── screenshots/
│   └── project_screenshots.png
│
└── README.md
```

## Tools Used

| Tool | Purpose |
|---|---|
| Python | Data analysis and visualization |
| Pandas | Data cleaning and transformation |
| SQL | Cohort and customer-level analysis |
| Excel | Dataset handling / supporting analysis |
| Google Colab | Python development environment |
| Matplotlib | Data visualization |
| GitHub | Project documentation and submission |

## Project Outcome

This project demonstrates an end-to-end customer retention analysis workflow using cohort analysis.

Skills demonstrated:

- Data cleaning
- SQL
- Python
- Pandas
- Cohort analysis
- Customer retention analysis
- Data visualization
- Business insight generation
- Google Colab
- GitHub documentation

## Dataset Citation

Chen, D. (2015). **Online Retail**. UCI Machine Learning Repository.

DOI: https://doi.org/10.24432/C5BW33

Dataset source: https://archive.ics.uci.edu/dataset/352/online+retail

## Author

**Sania Nautiyal**

Data Analytics Project

**Skills:** Python | Pandas | SQL | Excel | Cohort Analysis | Data Visualization
