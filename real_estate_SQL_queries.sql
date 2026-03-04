--  🏠 REAL ESTATE ANALYTICS PROJECT — PostgreSQL Scripts
--  Dataset : real_estate_data.csv (5000 rows — India)
--  Author  : Aditya Raj Achyut


-- STEP 1: VERIFY DATA
-- ──────────────────────────────────────────

SELECT COUNT(*) AS total_rows FROM properties;
SELECT * FROM properties LIMIT 5;


-- ──────────────────────────────────────────
-- STEP 4: BASIC ANALYSIS QUERIES
-- ──────────────────────────────────────────

-- Q1: Total properties by city with sold %
SELECT
    city,
    COUNT(*)                                          AS total_listings,
    SUM(is_sold)                                      AS sold,
    COUNT(*) - SUM(is_sold)                           AS available,
    ROUND(100.0 * SUM(is_sold) / COUNT(*), 1)         AS sold_pct
FROM properties
GROUP BY city
ORDER BY total_listings DESC;


-- Q2: Average price per sqft by city
SELECT
    city,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)    AS avg_price_psf,
    ROUND(MIN(price_per_sqft)::NUMERIC, 0)    AS min_price_psf,
    ROUND(MAX(price_per_sqft)::NUMERIC, 0)    AS max_price_psf,
    COUNT(*)                          AS listings
FROM properties
GROUP BY city
ORDER BY avg_price_psf DESC;


-- Q3: Property type distribution with percentage
SELECT
    property_type,
    COUNT(*)                                                        AS count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1)              AS pct
FROM properties
GROUP BY property_type
ORDER BY count DESC;


-- Q4: BHK-wise average price
SELECT
    bhk,
    COUNT(*)                               AS listings,
    ROUND((AVG(price) / 1000000.0)::NUMERIC, 2)       AS avg_price_cr,
    ROUND(AVG(area_sqft)::NUMERIC, 0)               AS avg_area_sqft,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)          AS avg_psf
FROM properties
GROUP BY bhk
ORDER BY bhk;


-- ──────────────────────────────────────────
-- STEP 5: INTERMEDIATE QUERIES
-- ──────────────────────────────────────────

-- Q5: Furnishing status impact on price by city
SELECT
    city,
    furnishing_status,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)   AS avg_psf,
    COUNT(*)                         AS listings
FROM properties
GROUP BY city, furnishing_status
ORDER BY city, avg_psf DESC;


-- Q6: Rental yield analysis by city
SELECT
    city,
    ROUND(AVG(monthly_rent * 12.0 / price * 100)::NUMERIC, 2)   AS avg_rental_yield_pct,
    ROUND(AVG(monthly_rent)::NUMERIC, 0)                          AS avg_monthly_rent,
    ROUND((AVG(price) / 1000000.0)::NUMERIC, 2)                    AS avg_price_cr
FROM properties
GROUP BY city
ORDER BY avg_rental_yield_pct DESC;


-- Q7: Top 10 localities by listing count
SELECT
    city,
    locality,
    COUNT(*)                           AS total_listings,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)     AS avg_price_cr,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)      AS avg_psf
FROM properties
GROUP BY city, locality
ORDER BY total_listings DESC
LIMIT 10;


-- Q8: Floor premium analysis
SELECT
    CASE
        WHEN floor_no = 0              THEN 'Ground Floor'
        WHEN floor_no BETWEEN 1 AND 5  THEN 'Low (1-5)'
        WHEN floor_no BETWEEN 6 AND 15 THEN 'Mid (6-15)'
        ELSE                                'High (16+)'
    END                             AS floor_category,
    COUNT(*)                        AS listings,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)   AS avg_psf
FROM properties
GROUP BY
    CASE
        WHEN floor_no = 0              THEN 'Ground Floor'
        WHEN floor_no BETWEEN 1 AND 5  THEN 'Low (1-5)'
        WHEN floor_no BETWEEN 6 AND 15 THEN 'Mid (6-15)'
        ELSE                                'High (16+)'
    END
ORDER BY avg_psf DESC;


-- Q9: Seller type vs negotiability
SELECT
    seller_type,
    COUNT(*)                                                          AS total,
    SUM(CASE WHEN negotiable = 'Yes' THEN 1 ELSE 0 END)              AS negotiable_count,
    ROUND(100.0 * SUM(CASE WHEN negotiable='Yes' THEN 1 ELSE 0 END)
          / COUNT(*), 1)                                              AS negotiable_pct
FROM properties
GROUP BY seller_type;


-- Q10: Year-wise listing trend (PostgreSQL date functions)
SELECT
    EXTRACT(YEAR FROM listing_date)   AS year,
    EXTRACT(MONTH FROM listing_date)  AS month,
    COUNT(*)                          AS listings,
    SUM(is_sold)                      AS sold,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)    AS avg_price_cr
FROM properties
GROUP BY year, month
ORDER BY year, month;


-- ──────────────────────────────────────────
-- STEP 6: ADVANCED QUERIES
-- ──────────────────────────────────────────

-- Q11: Price segmentation using NTILE (quartiles)
SELECT
    price_bucket,
    COUNT(*)                          AS listings,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)    AS avg_price_cr,
    SUM(is_sold)                      AS sold
FROM (
    SELECT *,
        CASE NTILE(4) OVER (ORDER BY price)
            WHEN 1 THEN 'Budget (Q1)'
            WHEN 2 THEN 'Mid-Range (Q2)'
            WHEN 3 THEN 'Premium (Q3)'
            WHEN 4 THEN 'Luxury (Q4)'
        END AS price_bucket
    FROM properties
) t
GROUP BY price_bucket
ORDER BY MIN(price);


-- Q12: City rank by avg price per sqft using RANK()
SELECT
    city,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)                            AS avg_psf,
    RANK() OVER (ORDER BY AVG(price_per_sqft) DESC)          AS price_rank
FROM properties
GROUP BY city;


-- Q13: Overpriced listings (price > 1.8x city average)
SELECT
    p.property_id,
    p.city,
    p.locality,
    p.property_type,
    p.bhk,
    p.area_sqft,
    p.price,
    p.price_per_sqft,
    ROUND(city_avg.avg_psf::NUMERIC, 0)                  AS city_avg_psf,
    ROUND((p.price_per_sqft / city_avg.avg_psf)::NUMERIC, 2) AS premium_ratio
FROM properties p
JOIN (
    SELECT city, AVG(price_per_sqft) AS avg_psf
    FROM properties
    GROUP BY city
) city_avg USING (city)
WHERE p.price_per_sqft > city_avg.avg_psf * 1.8
ORDER BY premium_ratio DESC
LIMIT 20;


-- Q14: Running total of listings by month (PostgreSQL window function)
SELECT
    EXTRACT(YEAR FROM listing_date)   AS year,
    EXTRACT(MONTH FROM listing_date)  AS month,
    COUNT(*)                          AS monthly_listings,
    SUM(COUNT(*)) OVER (
        ORDER BY EXTRACT(YEAR FROM listing_date),
                 EXTRACT(MONTH FROM listing_date)
    )                                 AS running_total
FROM properties
GROUP BY year, month
ORDER BY year, month;


-- Q15: City-wise median price (PostgreSQL PERCENTILE_CONT)
SELECT
    city,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price)::NUMERIC / 1000000, 2) AS median_price_cr,
    ROUND(AVG(price)::NUMERIC / 1000000, 2)                                          AS mean_price_cr
FROM properties
GROUP BY city
ORDER BY median_price_cr DESC;


-- ──────────────────────────────────────────
-- STEP 7: VIEWS FOR POWER BI
-- ──────────────────────────────────────────

CREATE OR REPLACE VIEW v_city_summary AS
SELECT
    city,
    COUNT(*)                                          AS total_listings,
    SUM(is_sold)                                      AS sold,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)                    AS avg_price_cr,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)                     AS avg_psf,
    ROUND(AVG(monthly_rent*12.0/price*100)::NUMERIC, 2)        AS avg_rental_yield,
    ROUND(100.0 * SUM(is_sold)/COUNT(*), 1)           AS sold_pct
FROM properties
GROUP BY city;


CREATE OR REPLACE VIEW v_price_trend AS
SELECT
    EXTRACT(YEAR FROM listing_date)   AS yr,
    city,
    property_type,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)    AS avg_price_cr,
    COUNT(*)                           AS listings
FROM properties
GROUP BY yr, city, property_type;


CREATE OR REPLACE VIEW v_bhk_analysis AS
SELECT
    city,
    bhk,
    furnishing_status,
    COUNT(*)                          AS listings,
    ROUND((AVG(price)/1000000.0)::NUMERIC, 2)    AS avg_price_cr,
    ROUND(AVG(price_per_sqft)::NUMERIC, 0)     AS avg_psf,
    ROUND(AVG(area_sqft)::NUMERIC, 0)          AS avg_area
FROM properties
GROUP BY city, bhk, furnishing_status;


-- ── CHECK VIEWS ──
SELECT * FROM v_city_summary;
SELECT * FROM v_price_trend LIMIT 10;
SELECT * FROM v_bhk_analysis LIMIT 10;