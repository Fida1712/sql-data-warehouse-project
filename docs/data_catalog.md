# Gold Layer Data Catalog

## Overview

The Gold Layer contains business-ready datasets designed for analytics and reporting purposes.  
It consists of **dimension tables** for descriptive business information and **fact tables** for measurable transactional data.

These tables are structured to support reporting, KPI analysis, customer insights, product analysis, and sales trend reporting.

---

# 1. gold.dim_customers

## Purpose

This table stores cleaned and enriched customer information used for business analysis.

It combines customer-related attributes such as personal details, demographics, and location information to support customer segmentation and reporting.

### Columns

| Column Name | Data Type | Description |
|---|---:|---|
| customer_key | INT | Surrogate key generated for uniquely identifying customer records in the warehouse |
| customer_id | INT | Business/customer identifier from source systems |
| customer_number | VARCHAR(50) | Customer reference number used for tracking |
| first_name | VARCHAR(50) | Customer's given name |
| last_name | VARCHAR(50) | Customer's surname or family name |
| country | VARCHAR(50) | Country associated with the customer |
| marital_status | VARCHAR(50) | Standardized marital status value |
| gender | VARCHAR(50) | Standardized gender value |
| birthdate | DATE | Customer birth date in `YYYY-MM-DD` format |
| create_date | DATE | Record creation timestamp in the warehouse |

### Business Use Cases

- Customer segmentation
- Demographic analysis
- Geographic reporting
- Customer behavior insights

---

# 2. gold.dim_products

## Purpose

This table contains product-related information required for reporting and sales analysis.

It stores descriptive product attributes such as category, pricing, product grouping, and operational characteristics.

### Columns

| Column Name | Data Type | Description |
|---|---:|---|
| product_key | INT | Warehouse-generated surrogate key for products |
| product_id | INT | Product identifier from source system |
| product_number | VARCHAR(50) | Product reference code |
| product_name | VARCHAR(50) | Product description or display name |
| category_id | VARCHAR(50) | Identifier representing product category |
| category | VARCHAR(50) | High-level product grouping |
| subcategory | VARCHAR(50) | Detailed product classification |
| maintenance_required | VARCHAR(50) | Indicates whether maintenance is needed |
| cost | INT | Product cost value |
| product_line | VARCHAR(50) | Product line or series classification |
| start_date | DATE | Product availability start date |

### Business Use Cases

- Product performance analysis
- Category-level reporting
- Product profitability analysis
- Inventory and sales insights

---

# 3. gold.fact_sales

## Purpose

This table stores transactional sales information and acts as the primary fact table for business reporting.

It links customer and product dimensions to sales activity and supports KPI calculations, trend analysis, and operational reporting.

### Columns

| Column Name | Data Type | Description |
|---|---:|---|
| order_number | VARCHAR(50) | Unique identifier for sales transactions |
| product_key | INT | Reference to product dimension |
| customer_key | INT | Reference to customer dimension |
| order_date | DATE | Date when order was created |
| shipping_date | DATE | Date when order was shipped |
| due_date | DATE | Expected payment due date |
| sales_amount | DECIMAL(10,2) | Total sales amount for transaction |
| quantity | INT | Number of units sold |
| price | INT | Unit selling price |

### Business Use Cases

- Sales trend analysis
- Revenue reporting
- Customer purchase behavior analysis
- Product sales performance
- KPI reporting

---

## Data Model Summary

The Gold Layer follows a dimensional modeling approach:

- **Dimension Tables** → descriptive business information  
  (`dim_customers`, `dim_products`)

- **Fact Table** → measurable business transactions  
  (`fact_sales`)

This structure improves query performance and simplifies reporting for BI and analytical workloads.
