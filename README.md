# 🏠 Real Estate Market Analysis — India
### *Because buying a house shouldn't feel like gambling* 🎲

![Python](https://img.shields.io/badge/Python-3.10-blue?style=for-the-badge&logo=python)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-316192?style=for-the-badge&logo=postgresql)
![XGBoost](https://img.shields.io/badge/XGBoost-89%25_R²-green?style=for-the-badge)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-orange?style=for-the-badge&logo=jupyter)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)

---

## 🤔 Why I Built This

Every Indian family has *that one uncle* who thinks he's a real estate expert.

> *"Beta, Mumbai mein invest karo — prices kabhi nahi girte!"*
> *"Arre furnished flat lena, bahut fayda hoga!"*
> *"Lucknow mein mat kharido — wahan kuch nahi hota!"*

I got tired of opinions. So I let the **data talk**. 📊

---

## 🎯 What This Project Does

Analyzes **5,000 real estate listings** across **10 Indian cities** to answer:

- 🏙️ Which city gives the best **price per sqft**?
- 💰 Where should you invest for **maximum rental yield**?
- 🛋️ Is a **furnished flat** actually worth the premium?
- 🏗️ Does **floor number** affect property price?
- 🚨 Which listings are **overpriced scams**?
- 🤖 Can **Machine Learning** predict property prices accurately?

**Spoiler: Yes. With 89% accuracy.** 😎

---

## 📊 Key Findings

| 🔍 Finding | 📈 Insight |
|---|---|
| 🥇 Most Expensive City | Mumbai — highest avg price/sqft |
| 💸 Best Rental Yield | Lucknow — 3.41% annually |
| 🛋️ Furnished Premium | +10-12% over unfurnished |
| 🏷️ Fastest Selling | Budget segment — 72% sold |
| 📉 Age Impact | 10+ yr old property = 15% cheaper |
| 🏗️ Floor Premium | High floors cost more — data confirms it |
| 🤖 Best ML Model | XGBoost — R² = 0.892, MAE ≈ ₹14L |

---

## 🛠️ Tech Stack

```
Python      →  EDA, Feature Engineering, ML Modeling
PostgreSQL  →  Data Storage, 15 Advanced SQL Queries
XGBoost     →  Price Prediction Model (Best Performer)
SQLAlchemy  →  Python ↔ PostgreSQL Bridge (psycopg2)
Jupyter     →  End-to-end Notebook (14 Steps)
Power BI    →  Dashboard (Coming Soon 👀)
```

---

## 📁 Project Structure

```
real-estate-market-analysis/
│
├── 📓 Real_Estate_Analytics.ipynb     # Main notebook — 14 steps!
├── 📊 real_estate_data.csv            # 5,000 row synthetic dataset
├── 🗄️ real_estate_SQL_queries.sql     # 15 PostgreSQL queries + 3 Views
├── 📋 requirements.txt                # All dependencies
│
├── 📈 Visualizations (7 plots)/
│   ├── viz_01_city_distribution.png
│   ├── viz_02_yearly_trends.png
│   ├── viz_03_property_furnishing.png
│   ├── viz_04_rental_yield.png
│   ├── viz_05_bhk_segment.png
│   ├── viz_06_sold_seller.png
│   └── viz_07_correlation_heatmap.png
│
└── 📤 Power BI CSVs/
    ├── powerbi_city_summary.csv
    ├── powerbi_bhk_analysis.csv
    ├── powerbi_monthly_trend.csv
    └── powerbi_full_data.csv
```

---

## 📓 Notebook Walkthrough — 14 Steps

```
STEP 1  →  Import Libraries
STEP 2  →  Load Dataset
STEP 3  →  Data Overview & Quality Check
STEP 4  →  Data Cleaning & Feature Engineering
STEP 5  →  Load Data into PostgreSQL (SQLAlchemy)  ← 🔥
STEP 6  →  EDA — City-wise Listing Distribution
STEP 7  →  EDA — Yearly Price Trends
STEP 8  →  EDA — Property Type & Furnishing Patterns
STEP 9  →  EDA — City-wise Rental Yield
STEP 10 →  EDA — BHK & Price Segment Analysis
STEP 11 →  EDA — Sold % & Price Distribution
STEP 12 →  Correlation Heatmap
STEP 13 →  Hypothesis Testing (3 Statistical Tests)
STEP 14 →  Final Summary & Key Insights
```

---

## 🗄️ SQL File — 15 Queries + 3 Views

### Basic (Q1–Q4)
```
Q1  →  City-wise listings & sold %
Q2  →  Avg price per sqft by city
Q3  →  Property type distribution
Q4  →  BHK-wise average price
```

### Intermediate (Q5–Q10)
```
Q5  →  Furnishing impact on price
Q6  →  Rental yield by city
Q7  →  Top 10 localities
Q8  →  Floor premium analysis
Q9  →  Seller type vs negotiability
Q10 →  Year-wise listing trend
```

### Advanced (Q11–Q15) — Window Functions! 🚀
```
Q11 →  Price segmentation (NTILE)
Q12 →  City rank by price (RANK)
Q13 →  Overpriced listings detector 🚨
Q14 →  Running total (SUM OVER)
Q15 →  Median vs Mean price (PERCENTILE_CONT)
```

### 3 Power BI Views
```sql
v_city_summary    →  City-level KPIs
v_price_trend     →  Year x City x Property Type
v_bhk_analysis    →  BHK x City x Furnishing
```

### Sample — The Scam Detector 🚨
```sql
-- Q13: Find overpriced listings (price > 1.8x city average)
SELECT p.property_id, p.city, p.locality,
       ROUND((p.price_per_sqft / city_avg.avg_psf)::NUMERIC, 2) AS premium_ratio
FROM properties p
JOIN (
    SELECT city, AVG(price_per_sqft) AS avg_psf
    FROM properties GROUP BY city
) city_avg USING (city)
WHERE p.price_per_sqft > city_avg.avg_psf * 1.8
ORDER BY premium_ratio DESC;
```

---

## 🚀 How to Run

### Step 1 — Clone the repo
```bash
git clone https://github.com/AdityaRajAchyut/real-estate-market-analysis.git
cd real-estate-market-analysis
```

### Step 2 — Install dependencies
```bash
pip install -r requirements.txt
```

### Step 3 — Setup PostgreSQL
1. Open **pgAdmin 4**
2. Create database: `real_estate_db`
3. Run notebook **STEP 5** — data auto-loads into PostgreSQL! ✅

### Step 4 — Launch Jupyter
```bash
jupyter notebook
```
Open `Real_Estate_Analytics.ipynb` → **Run All** 🎉

### Step 5 — Run SQL Queries
Open `real_estate_SQL_queries.sql` in pgAdmin → **F5** ✅

---

## 🧪 Hypothesis Testing Results

```
TEST 1: Do Furnished flats cost significantly more?
→ YES — Statistically significant (p < 0.05) ✅

TEST 2: Does BHK significantly affect price? (ANOVA)
→ YES — Strong effect confirmed (p < 0.05) ✅

TEST 3: Is Mumbai price/sqft significantly higher than Bangalore?
→ YES — Mumbai wins by a mile 😤 (p < 0.05) ✅
```

---

## 🤖 ML Model Performance

| Model | R² Score | MAE |
|---|---|---|
| Linear Regression | 71.0% | ₹28.4L |
| Ridge Regression | 71.2% | ₹28.1L |
| Random Forest | 86.4% | ₹16.2L |
| **XGBoost** ⭐ | **89.2%** | **₹14.3L** |

> **Why XGBoost wins:** Real estate pricing is non-linear — location effects, floor premiums, amenity combos don't follow straight lines. Tree-based models handle this naturally.

**Top Price Predictors:**
1. 📍 Locality
2. 📐 Area (sqft)
3. 🏙️ City
4. 🏚️ Age of Property
5. 🛋️ Furnishing Status

---

## 💡 Business Recommendations

1. **Investors** → Buy in Lucknow/Jaipur for rental income (3.4%+ yield)
2. **End Users** → 3 BHK sweet spot — best demand & resale value
3. **Builders** → Focus on budget segment — 72% sell rate is unbeatable
4. **Buyers** → Use Q13 query to spot overpriced listings before buying!
5. **Renters** → Negotiate on unfurnished — save 10-12% easily

---

## 🔜 Coming Soon

- [ ] Power BI Dashboard 📊
- [ ] Streamlit Web App 🌐
- [ ] City-wise Price Forecasting 📈
- [ ] Neighbourhood-level Analysis 🗺️

---

## 👨‍💻 Author

**Aditya Raj Achyut**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://linkedin.com/in/your-profile)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-black?style=for-the-badge&logo=github)](https://github.com/AdityaRajAchyut)

---

> *"In God we trust. All others bring data."* — W. Edwards Deming

⭐ **Star this repo if it saved you from your uncle's advice!**
