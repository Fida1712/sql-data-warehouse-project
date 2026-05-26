# sql-data-warehouse-project(MYSQL)

## Project Overview

This repository documents my hands-on implementation of a modern Data Warehouse and Analytics project using MySQL.

The project focuses on building a structured data warehouse using the Medallion Architecture (Bronze → Silver → Gold), performing ETL transformations, cleaning raw datasets, and preparing business-ready analytical models for reporting and insights.

This implementation was completed as part of a guided learning project (DATA WITH BARAA) and adapted into MySQL to strengthen practical understanding of:

- Data Warehousing
- ETL Development
- SQL & MySQL Stored Procedures
- Data Cleaning & Transformation
- Data Modeling
- Analytics-ready Data Structures

---

## Project Goal

The objective of this project is to consolidate sales-related data from multiple source systems into a centralized analytical database that supports reporting and business analysis.

The project covers:

- Extracting data from CSV source files
- Loading raw data into MySQL
- Cleaning and standardizing data
- Transforming raw data into analysis-ready structures
- Building dimensional models for analytics
- Writing SQL queries for business insights

---

## Architecture

This project follows the **Medallion Architecture** approach:

### Bronze Layer (Raw Data)

- Stores raw data from source systems
- CSV files are loaded directly into MySQL
- Minimal or no transformations applied
- Preserves source-level information

### Silver Layer (Cleaned Data)

- Data cleansing and validation
- Standardization of formats
- Null handling and quality checks
- Data normalization and transformation

Examples:
- Invalid dates handled using MySQL transformations
- Sales, quantity, and pricing validation
- Missing or incorrect values corrected

### Gold Layer (Business Ready Data)

- Analytical data modeling
- Fact and dimension table creation
- Reporting-ready datasets
- Optimized structures for business insights

---

## Tech Stack

- MySQL
- SQL
- CSV Files
- Git & GitHub
- MySQL Workbench

---

## Project Structure

```text
data-warehouse-project/
│
├── datasets/                  # Source CSV files
│
├── scripts/
│   ├── bronze/                # Raw data ingestion scripts
│   ├── silver/                # Data cleaning & transformation scripts
│   ├── gold/                  # Analytical models & reporting tables
│
├── docs/                      # Architecture, notes, diagrams
│
├── tests/                     # Data quality validation scripts
│
├── README.md
└── .gitignore
```

---

## ETL Workflow

### 1. Extract

- Import CSV datasets into MySQL
- Load raw data into Bronze tables

### 2. Transform

- Clean invalid values
- Standardize formats
- Handle missing values
- Fix inconsistent sales calculations
- Convert and validate dates
- Apply transformation logic using SQL and MySQL stored procedures

### 3. Load

- Move transformed data into Silver layer
- Create analytics-ready Gold layer tables

---

## Key Learning Outcomes

Through this project, I practiced:

- Writing advanced SQL queries
- Building ETL pipelines in MySQL
- Using stored procedures
- Implementing error handling in MySQL
- Data cleansing and transformation techniques
- Medallion Architecture concepts
- Dimensional data modeling
- Working with analytical datasets

---

## Challenges & Learnings

Some of the practical challenges solved during implementation:

- Converting SQL Server syntax into MySQL syntax
- Date transformations and validations
- Handling null values and incorrect records
- Building reusable stored procedures
- Implementing MySQL error handling
- Cleaning inconsistent transactional data

---

## What I Customized

Compared to the guided project:

- Implemented the solution using **MySQL** instead of SQL Server
- Adapted T-SQL syntax into MySQL-compatible SQL
- Rewrote ETL logic and transformations
- Used MySQL-specific stored procedures and functions
- Added practical experimentation for learning purposes

---

## Acknowledgment

This project was developed as part of a guided learning journey inspired by a Data Warehouse & Analytics implementation project from DATA WITH BARAA

The original project concept served as a learning reference. This repository represents my own hands-on implementation using MySQL, including adaptations, experimentation, and practical learning.

The purpose of this repository is educational, skill-building, and portfolio development.

---

- Expand reporting and business KPIs

