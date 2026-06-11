# Project Overview

This dbt project transforms raw TPCH sample data from Snowflake into a structured, analytics-ready data model. It follows a layered architecture to ensure scalability, maintainability, and clear data lineage across all transformations.

---

## 🎯 Objective

The goal of this project is to:

- Standardize and clean raw transactional data
- Model business entities such as orders and customers
- Provide reliable, tested datasets for analytics and reporting
- Demonstrate best practices in modern data transformation using dbt

---

## 🧱 Data Architecture

The project is organized into three main layers:

### 1. Staging (`stg_*`)
- Source-aligned models
- Renamed columns (snake_case)
- Minimal transformations
- Directly reference Snowflake TPCH tables

**Examples:**
- `stg_tpch__orders`
- `stg_tpch__customers`
- `stg_tpch__lineitems`
- `stg_tpch__nations`

---

### 2. Intermediate (`int_*`)
- Combines staging models
- Adds business-ready attributes
- Used as building blocks for marts

**Example:**
- `int_orders_enriched`
  - Joins orders, customers, and nations
  - Adds derived date fields (year, month, quarter)

---

### 3. Marts (`fct_*`, `dim_*`)
- Final analytics-ready tables
- Denormalized and optimized for BI tools
- Contain business logic and KPIs

**Models:**
- `fct_orders` (Fact table)
  - One row per order
  - Includes aggregated line item metrics (revenue, quantity, discounts)
- `dim_customers` (Dimension table)
  - Customer attributes
  - Lifetime value calculation
  - Customer segmentation (Gold, Silver, Bronze)

---

## 📊 Key Business Logic

### Revenue Calculations
- **Net Price:**  
  `extended_price * (1 - discount)`

- **Gross Price:**  
  `net_price * (1 + tax)`

### Customer Segmentation
Customers are categorized based on lifetime value:

| Tier   | Criteria |
|--------|----------|
| Gold   | ≥ 500,000 |
| Silver | ≥ 100,000 |
| Bronze | < 100,000 |

---

## ✅ Data Quality & Testing

The project includes multiple layers of data validation:

- **Primary Key Constraints**
  - `not_null` and `unique` tests

- **Accepted Values**
  - Order status restricted to: `O`, `F`, `P`

- **Relationships**
  - Enforced between fact and dimension tables

- **Custom Test**
  - Ensures no negative revenue values exist

---

## ⚙️ Technical Highlights

- Built using **dbt**
- Runs on **Snowflake**
- Uses:
  - Incremental models for performance (`fct_orders`)
  - Surrogate keys for consistency
  - Modular SQL transformations via `ref()` and `source()`

---

## 🚀 How to Use

Run the full pipeline:

```bash
dbt run