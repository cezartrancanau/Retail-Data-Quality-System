USE retail_data_quality;

-- QUERY 01:
-- Shows the first 10 sales records.
-- Use this query immediately after running the database setup file to confirm that the sales table contains data and that the main columns were loaded correctly.
-- Because no ORDER BY clause is used, the database may return the first available rows in its internal storage order.
-- Concepts used: SELECT, wildcard column selection, LIMIT.
SELECT *
FROM sales
LIMIT 10;

-- QUERY 02:
-- Returns every order whose status is Completed.
-- This is a common operational filter used when cancelled and returned orders must be excluded from normal sales processing.
-- The results are ordered from the earliest to the latest order date.
-- Concepts used: SELECT, WHERE, ORDER BY.
SELECT *
FROM sales
WHERE order_status = 'Completed'
ORDER BY order_date;

-- QUERY 03:
-- Returns orders created through the Online sales channel.
-- This query helps compare online activity with Store and Marketplace activity and displays the newest records first.
-- Concepts used: SELECT, WHERE, ORDER BY with descending order.
SELECT *
FROM sales
WHERE sales_channel = 'Online'
ORDER BY order_date DESC;

-- QUERY 04:
-- Returns all orders placed during the first quarter of 2025.
-- BETWEEN includes both boundary dates, so orders from January 1 and March 31 are included.
-- This type of date filter is commonly used for monthly, quarterly and annual reporting.
-- Concepts used: WHERE, BETWEEN, date filtering, ORDER BY.
SELECT *
FROM sales
WHERE order_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY order_date;

-- QUERY 05:
-- Finds orders containing at least 10 units.
-- This can be used to identify unusually large quantities, bulk purchases or orders that may need an additional review.
-- Concepts used: column selection, WHERE with a comparison operator, ORDER BY.
SELECT order_id, product_id, quantity
FROM sales
WHERE quantity >= 10
ORDER BY quantity DESC;

-- QUERY 06:
-- Lists each customer region only once.
-- DISTINCT removes repeated region values and is useful when preparing filter lists or checking the available categories in a column.
-- Concepts used: SELECT DISTINCT, ORDER BY.
SELECT DISTINCT region
FROM customers
ORDER BY region;

-- QUERY 07:
-- Finds products whose name contains the word Monitor.
-- The percent signs are wildcard characters, allowing text to appear before or after the searched word.
-- With the project's utf8mb4_unicode_ci collation, MySQL LIKE searches are case-insensitive.
-- Concepts used: WHERE, LIKE, wildcard search.
SELECT *
FROM products
WHERE product_name LIKE '%Monitor%';

-- QUERY 08:
-- Shows the 15 most recent orders.
-- The records are first sorted by order date from newest to oldest, and LIMIT then keeps only the first 15 rows.
-- This is useful for a recent-activity report or a quick operational review.
-- Concepts used: selected columns, ORDER BY DESC, LIMIT.
SELECT order_id, order_date, customer_id, product_id, order_status
FROM sales
ORDER BY order_date DESC
LIMIT 15;

-- QUERY 09:
-- Counts the total number of records stored in the sales table.
-- COUNT(*) includes every row, even when optional columns contain NULL values.
-- This is useful for validating the number of imported transactions.
-- Concepts used: COUNT, column alias.
SELECT COUNT(*) AS total_sales_records
FROM sales;

-- QUERY 10:
-- Counts how many different customers appear in the sales table.
-- COUNT(DISTINCT customer_id) removes repeated customer IDs before counting them.
-- This measures the number of customers with at least one transaction.
-- Concepts used: COUNT, DISTINCT, alias.
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM sales;

-- QUERY 11:
-- Counts orders for each order status.
-- The table is grouped into Completed, Returned and Cancelled records, then sorted from the largest group to the smallest.
-- This query supports completion, return and cancellation reporting.
-- Concepts used: COUNT, GROUP BY, ORDER BY aggregate result.
SELECT order_status, COUNT(*) AS total_orders
FROM sales
GROUP BY order_status
ORDER BY total_orders DESC;

-- QUERY 12:
-- Counts orders for each sales channel.
-- It can be used to compare Online, Store and Marketplace activity by transaction volume.
-- The channel with the greatest number of orders is shown first.
-- Concepts used: COUNT, GROUP BY, ORDER BY.
SELECT sales_channel, COUNT(*) AS total_orders
FROM sales
GROUP BY sales_channel
ORDER BY total_orders DESC;

-- QUERY 13:
-- Calculates the total completed units sold for each product ID.
-- Returned and cancelled orders are excluded so that the result reflects completed sales only.
-- The products are ordered from the highest to the lowest number of units sold.
-- Concepts used: WHERE, SUM, GROUP BY, ORDER BY.
SELECT product_id, SUM(quantity) AS units_sold
FROM sales
WHERE order_status = 'Completed'
GROUP BY product_id
ORDER BY units_sold DESC;

-- QUERY 14:
-- Calculates the average quantity per completed order.
-- ROUND limits the displayed result to two decimal places, which makes the report easier to read.
-- Concepts used: AVG, ROUND, WHERE.
SELECT ROUND(AVG(quantity), 2) AS average_quantity
FROM sales
WHERE order_status = 'Completed';

-- QUERY 15:
-- Shows the smallest and largest quantity found in the sales table.
-- MIN and MAX are useful for understanding the range of values and for spotting possible outliers.
-- Concepts used: MIN, MAX, aliases.
SELECT
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity
FROM sales;

-- QUERY 16:
-- Creates a detailed sales report by combining four related tables.
-- The sales table stores foreign keys, while the joined tables provide customer region, product information and the representative's name.
-- INNER JOIN returns only records that have matching rows in all referenced tables.
-- Concepts used: table aliases, multiple INNER JOIN operations, foreign-key relationships, ORDER BY.
SELECT
    s.order_id,
    s.order_date,
    c.customer_email,
    c.region,
    p.product_name,
    p.category,
    sr.representative_name,
    s.sales_channel,
    s.quantity,
    p.unit_price,
    s.discount_rate,
    s.order_status
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
JOIN sales_representatives sr
    ON s.representative_id = sr.representative_id
ORDER BY s.order_date;

-- QUERY 17:
-- Calculates gross revenue and net revenue for every order.
-- Gross revenue equals quantity multiplied by unit price. Net revenue also applies the order discount.
-- The report is sorted by net revenue from highest to lowest.
-- Concepts used: JOIN, calculated columns, arithmetic, ROUND, ORDER BY alias.
SELECT
    s.order_id,
    p.product_name,
    s.quantity,
    p.unit_price,
    ROUND(s.quantity * p.unit_price, 2) AS gross_revenue,
    ROUND(s.quantity * p.unit_price * (1 - s.discount_rate), 2) AS net_revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
ORDER BY net_revenue DESC;

-- QUERY 18:
-- Calculates net revenue, total cost and profit for each order.
-- Profit is calculated as discounted revenue minus quantity multiplied by unit cost.
-- This query demonstrates how transactional and product master data can be combined to create financial KPIs.
-- Concepts used: JOIN, arithmetic expressions, ROUND, ORDER BY.
SELECT
    s.order_id,
    p.product_name,
    ROUND(s.quantity * p.unit_price * (1 - s.discount_rate), 2) AS net_revenue,
    ROUND(s.quantity * p.unit_cost, 2) AS total_cost,
    ROUND(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost,
        2
    ) AS profit
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
ORDER BY profit DESC;

-- QUERY 19:
-- Summarises completed sales by product.
-- For every product, the query calculates total units sold and total net revenue after discounts.
-- Grouping by both product ID and product name keeps the result readable while preserving a unique product identifier.
-- Concepts used: JOIN, WHERE, SUM, GROUP BY, ROUND, ORDER BY.
SELECT
    p.product_id,
    p.product_name,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS net_revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY net_revenue DESC;

-- QUERY 20:
-- Calculates completed units, revenue and profit for each product category.
-- The query combines sales quantities and discounts with product prices and costs.
-- This is a standard category-performance report used in management dashboards.
-- Concepts used: JOIN, conditional filtering, multiple SUM calculations, GROUP BY, ROUND.
SELECT
    p.category,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS net_revenue,
    ROUND(SUM(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost
    ), 2) AS profit
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY p.category
ORDER BY net_revenue DESC;

-- QUERY 21:
-- Calculates completed orders, units, revenue and profit for each customer region.
-- The customer table provides the region and the product table provides price and cost values.
-- This query demonstrates a business report that requires joins across three tables before aggregation.
-- Concepts used: multiple JOINs, COUNT, SUM, calculated KPIs, GROUP BY, ORDER BY.
SELECT
    c.region,
    COUNT(*) AS completed_orders,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS net_revenue,
    ROUND(SUM(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost
    ), 2) AS profit
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY c.region
ORDER BY net_revenue DESC;

-- QUERY 22:
-- Measures completed-order performance for every sales representative.
-- The report calculates order count, units sold, revenue and profit, then sorts representatives by total profit.
-- Grouping includes both representative ID and name to avoid ambiguity.
-- Concepts used: multiple JOINs, aggregate functions, GROUP BY, ORDER BY calculated profit.
SELECT
    sr.representative_name,
    COUNT(*) AS completed_orders,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS revenue,
    ROUND(SUM(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost
    ), 2) AS profit
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
JOIN sales_representatives sr
    ON s.representative_id = sr.representative_id
WHERE s.order_status = 'Completed'
GROUP BY sr.representative_id, sr.representative_name
ORDER BY profit DESC;

-- QUERY 23:
-- Creates a monthly completed-sales summary.
-- DATE_FORMAT converts each full order date into a YYYY-MM reporting period before the rows are grouped.
-- The result includes monthly orders, units and revenue in chronological order.
-- Concepts used: MySQL DATE_FORMAT, JOIN, COUNT, SUM, GROUP BY expression.
SELECT
    DATE_FORMAT(s.order_date, '%Y-%m') AS sales_month,
    COUNT(*) AS completed_orders,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY DATE_FORMAT(s.order_date, '%Y-%m')
ORDER BY sales_month;

-- QUERY 24:
-- Creates a quarterly revenue summary.
-- MySQL QUARTER extracts the quarter number and CONCAT formats it as Q1, Q2, Q3 or Q4.
-- The query then groups and totals completed revenue by the calculated quarter.
-- Concepts used: MySQL QUARTER, CONCAT, GROUP BY calculated alias.
SELECT
    CONCAT('Q', QUARTER(s.order_date)) AS quarter,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY quarter
ORDER BY quarter;

-- QUERY 25:
-- Calculates the average value of completed orders.
-- The inner query first calculates an individual value for every completed order. The outer query then averages those calculated values.
-- This is a simple derived-table subquery and is useful when the required measure does not exist as a stored column.
-- Concepts used: subquery in FROM, JOIN, calculated column, AVG, ROUND.
SELECT ROUND(AVG(order_value), 2) AS average_order_value
FROM (
    SELECT
        s.order_id,
        s.quantity * p.unit_price * (1 - s.discount_rate) AS order_value
    FROM sales s
    JOIN products p
        ON s.product_id = p.product_id
    WHERE s.order_status = 'Completed'
);

-- QUERY 26:
-- Calculates the profit-margin percentage for each product category.
-- Profit is divided by net revenue and multiplied by 100. NULLIF prevents a division-by-zero error when revenue is zero.
-- The categories are sorted from the highest margin to the lowest.
-- Concepts used: JOIN, SUM, arithmetic, NULLIF, ROUND, GROUP BY.
SELECT
    p.category,
    ROUND(
        100.0 * SUM(
            s.quantity * p.unit_price * (1 - s.discount_rate)
            - s.quantity * p.unit_cost
        )
        / NULLIF(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 0),
        2
    ) AS profit_margin_pct
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY p.category
ORDER BY profit_margin_pct DESC;

-- QUERY 27:
-- Classifies each order as Large, Medium or Small based on net order value.
-- CASE checks the highest threshold first so that orders above 5,000 are not incorrectly classified as Medium.
-- The calculated value and category are useful for customer or order segmentation.
-- Concepts used: JOIN, CASE, calculated columns, ORDER BY alias.
SELECT
    s.order_id,
    ROUND(s.quantity * p.unit_price * (1 - s.discount_rate), 2) AS order_value,
    CASE
        WHEN s.quantity * p.unit_price * (1 - s.discount_rate) >= 5000 THEN 'Large Order'
        WHEN s.quantity * p.unit_price * (1 - s.discount_rate) >= 2000 THEN 'Medium Order'
        ELSE 'Small Order'
    END AS order_size
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
ORDER BY order_value DESC;

-- QUERY 28:
-- Groups orders into discount bands.
-- CASE classifies each order as No Discount, Low, Medium or High Discount, after which the query counts orders and calculates the average percentage in each band.
-- This helps identify how frequently larger discounts are being used.
-- Concepts used: CASE, COUNT, AVG, ROUND, GROUP BY calculated alias.
SELECT
    CASE
        WHEN discount_rate = 0 THEN 'No Discount'
        WHEN discount_rate <= 0.10 THEN 'Low Discount'
        WHEN discount_rate <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_band,
    COUNT(*) AS orders,
    ROUND(AVG(discount_rate) * 100, 2) AS average_discount_pct
FROM sales
GROUP BY discount_band
ORDER BY average_discount_pct;

-- QUERY 29:
-- Classifies every order as Profitable, Break-even or Loss.
-- The same profit calculation is evaluated in each CASE condition to decide the final label.
-- This query can be used to find transactions that may require pricing or discount review.
-- Concepts used: JOIN, CASE, calculated profit, ROUND.
SELECT
    s.order_id,
    ROUND(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost,
        2
    ) AS profit,
    CASE
        WHEN s.quantity * p.unit_price * (1 - s.discount_rate)
             - s.quantity * p.unit_cost > 0 THEN 'Profitable'
        WHEN s.quantity * p.unit_price * (1 - s.discount_rate)
             - s.quantity * p.unit_cost = 0 THEN 'Break-even'
        ELSE 'Loss'
    END AS profit_status
FROM sales s
JOIN products p
    ON s.product_id = p.product_id;

-- QUERY 30:
-- Returns customers that appear in more than one sales record.
-- GROUP BY creates one result row per customer and HAVING filters the groups after the count has been calculated.
-- This differs from WHERE, which filters individual rows before grouping.
-- Concepts used: GROUP BY, COUNT, HAVING, ORDER BY.
SELECT
    customer_id,
    COUNT(*) AS total_orders
FROM sales
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

-- QUERY 31:
-- Returns customers with at least three completed orders.
-- WHERE first removes returned and cancelled orders, then HAVING keeps only customer groups meeting the minimum count.
-- Concepts used: WHERE before grouping, COUNT, GROUP BY, HAVING.
SELECT
    customer_id,
    COUNT(*) AS completed_orders
FROM sales
WHERE order_status = 'Completed'
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY completed_orders DESC;

-- QUERY 32:
-- Returns products with more than 100 completed units sold.
-- The product name is added through a join, and HAVING filters the total quantity after aggregation.
-- This is useful for identifying high-volume products.
-- Concepts used: JOIN, SUM, GROUP BY multiple columns, HAVING.
SELECT
    p.product_name,
    SUM(s.quantity) AS units_sold
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(s.quantity) > 100
ORDER BY units_sold DESC;

-- QUERY 33:
-- Returns completed orders whose value is above the average completed-order value.
-- The subquery calculates the overall average, while the outer query calculates each order value and compares it with that average.
-- The same product join is required in both query levels because price is stored in the products table.
-- Concepts used: scalar subquery, multiple JOINs, AVG, calculated comparison.
SELECT
    s.order_id,
    p.product_name,
    ROUND(s.quantity * p.unit_price * (1 - s.discount_rate), 2) AS order_value
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
  AND s.quantity * p.unit_price * (1 - s.discount_rate) > (
      SELECT AVG(s2.quantity * p2.unit_price * (1 - s2.discount_rate))
      FROM sales s2
      JOIN products p2
          ON s2.product_id = p2.product_id
      WHERE s2.order_status = 'Completed'
  )
ORDER BY order_value DESC;

-- QUERY 34:
-- Returns products whose completed revenue is above the average revenue per product.
-- The innermost grouped query calculates one total for each product, and the next query averages those totals.
-- The outer query then keeps only products whose own grouped revenue exceeds that benchmark.
-- Concepts used: grouped subquery, derived table, AVG of grouped totals, HAVING.
SELECT
    p.product_name,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS product_revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(s.quantity * p.unit_price * (1 - s.discount_rate)) > (
    SELECT AVG(product_total)
    FROM (
        SELECT
            SUM(s2.quantity * p2.unit_price * (1 - s2.discount_rate)) AS product_total
        FROM sales s2
        JOIN products p2
            ON s2.product_id = p2.product_id
        WHERE s2.order_status = 'Completed'
        GROUP BY s2.product_id
    )
)
ORDER BY product_revenue DESC;

-- QUERY 35:
-- Returns customers whose completed revenue is above the average completed revenue per customer.
-- The nested query first creates customer-level totals and calculates their average. The outer query compares each customer's total with that value.
-- This demonstrates a practical customer-value segmentation query.
-- Concepts used: multiple JOINs, grouped subquery, HAVING, aggregate comparison.
SELECT
    c.customer_id,
    c.customer_email,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS customer_revenue
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY c.customer_id, c.customer_email
HAVING SUM(s.quantity * p.unit_price * (1 - s.discount_rate)) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT
            SUM(s2.quantity * p2.unit_price * (1 - s2.discount_rate)) AS customer_total
        FROM sales s2
        JOIN products p2
            ON s2.product_id = p2.product_id
        WHERE s2.order_status = 'Completed'
        GROUP BY s2.customer_id
    )
)
ORDER BY customer_revenue DESC;

-- QUERY 36:
-- Finds products that have never appeared in the sales table.
-- LEFT JOIN keeps every product, including those without a matching sale. The WHERE condition then selects only unmatched products.
-- This is useful for identifying inactive or newly added products.
-- Concepts used: LEFT JOIN, NULL check, unmatched-record analysis.
SELECT
    p.product_id,
    p.product_name
FROM products p
LEFT JOIN sales s
    ON p.product_id = s.product_id
WHERE s.product_id IS NULL;

-- QUERY 37:
-- Finds customers that have no sales records.
-- LEFT JOIN preserves all customers and the NULL condition identifies customers without a matching transaction.
-- Concepts used: LEFT JOIN, NULL check, master-data completeness.
SELECT
    c.customer_id,
    c.customer_email,
    c.region
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- QUERY 38:
-- Calculates returned and cancelled order counts and rates.
-- CASE returns 1 when a row matches a status and 0 otherwise, allowing SUM to perform conditional counting.
-- Multiplying by 100 converts the ratio into a percentage.
-- Concepts used: conditional aggregation, CASE inside SUM, COUNT, ROUND.
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END) AS returned_orders,
    SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Returned' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS return_rate_pct,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM sales;

-- QUERY 39:
-- Calculates completed orders and revenue for each payment method.
-- The product join is needed because unit price is stored in the products table rather than the sales table.
-- The result shows which payment method is associated with the greatest completed revenue.
-- Concepts used: JOIN, WHERE, COUNT, SUM, GROUP BY, ORDER BY.
SELECT
    s.payment_method,
    COUNT(*) AS completed_orders,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS revenue
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY s.payment_method
ORDER BY revenue DESC;

-- QUERY 40:
-- Creates a two-dimensional report by customer region and product category.
-- Grouping by both fields produces one result row for every region-category combination with completed activity.
-- This is similar to a simple Excel PivotTable with Region in rows and Category as a second grouping level.
-- Concepts used: multiple JOINs, GROUP BY two columns, aggregate KPIs.
SELECT
    c.region,
    p.category,
    COUNT(*) AS completed_orders,
    ROUND(SUM(s.quantity * p.unit_price * (1 - s.discount_rate)), 2) AS revenue
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_id = p.product_id
WHERE s.order_status = 'Completed'
GROUP BY c.region, p.category
ORDER BY c.region, revenue DESC;

-- QUERY 41:
-- Compares monthly regional revenue targets with actual completed revenue.
-- The target table is preserved with LEFT JOIN so that months or regions with no sales still appear with zero actual revenue.
-- CASE excludes non-completed sales, COALESCE replaces missing totals with zero, and the final calculation returns the variance from target.
-- Concepts used: multiple LEFT JOINs, date matching, CASE, COALESCE, SUM, GROUP BY.
SELECT
    t.target_month,
    t.region,
    t.revenue_target,
    ROUND(COALESCE(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
            ELSE 0
        END
    ), 0), 2) AS actual_revenue,
    ROUND(
        COALESCE(SUM(
            CASE
                WHEN s.order_status = 'Completed'
                THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                ELSE 0
            END
        ), 0) - t.revenue_target,
        2
    ) AS revenue_variance
FROM sales_targets t
LEFT JOIN customers c
    ON t.region = c.region
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
   AND DATE_FORMAT(s.order_date, '%Y-%m') = t.target_month
LEFT JOIN products p
    ON s.product_id = p.product_id
GROUP BY t.target_month, t.region, t.revenue_target
ORDER BY t.target_month, t.region;

-- QUERY 42:
-- Calculates the monthly regional target-achievement percentage.
-- Actual completed revenue is divided by the stored revenue target. NULLIF prevents division by zero, while COALESCE handles periods without sales.
-- A value of 100 means the target was met exactly; values above 100 indicate that it was exceeded.
-- Concepts used: LEFT JOIN, CASE, COALESCE, NULLIF, percentage calculation.
SELECT
    t.target_month,
    t.region,
    t.revenue_target,
    ROUND(COALESCE(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
            ELSE 0
        END
    ), 0), 2) AS actual_revenue,
    ROUND(
        100.0 * COALESCE(SUM(
            CASE
                WHEN s.order_status = 'Completed'
                THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                ELSE 0
            END
        ), 0)
        / NULLIF(t.revenue_target, 0),
        2
    ) AS achievement_pct
FROM sales_targets t
LEFT JOIN customers c
    ON t.region = c.region
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
   AND DATE_FORMAT(s.order_date, '%Y-%m') = t.target_month
LEFT JOIN products p
    ON s.product_id = p.product_id
GROUP BY t.target_month, t.region, t.revenue_target
ORDER BY t.target_month, t.region;

-- QUERY 43:
-- Checks the sales table for duplicate order IDs.
-- GROUP BY forms one group for each ID and HAVING keeps IDs occurring more than once.
-- Because order_id is defined as a primary key, a correctly created database should return no rows.
-- Concepts used: data-quality validation, GROUP BY, COUNT, HAVING.
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY order_id
HAVING COUNT(*) > 1;

-- QUERY 44:
-- Checks required identifier columns for NULL or blank values.
-- TRIM removes spaces before comparing text with an empty string, preventing a value containing only spaces from passing validation.
-- A correctly loaded database with enforced primary and foreign keys should return no rows.
-- Concepts used: IS NULL, TRIM, OR conditions, data-quality checking.
SELECT *
FROM sales
WHERE order_id IS NULL
   OR TRIM(order_id) = ''
   OR customer_id IS NULL
   OR TRIM(customer_id) = ''
   OR product_id IS NULL
   OR TRIM(product_id) = '';

-- QUERY 45:
-- Checks numeric business rules for quantity and discount.
-- The query identifies quantities that are zero or negative and discount values outside the approved 0 to 50 percent range.
-- The table constraints should prevent these values during insertion, so no rows are expected.
-- Concepts used: comparison operators, OR, business-rule validation.
SELECT *
FROM sales
WHERE quantity <= 0
   OR discount_rate < 0
   OR discount_rate > 0.5;

-- QUERY 46:
-- Performs a basic format check on customer email addresses.
-- The pattern requires text before an at sign and a dot after it. This is a practical junior-level check, not a complete internet email validation.
-- Concepts used: IS NULL, NOT LIKE, wildcard pattern.
SELECT *
FROM customers
WHERE customer_email IS NULL
   OR customer_email NOT LIKE '%@%.%';

-- QUERY 47:
-- Finds products whose approved selling price is lower than their unit cost.
-- The calculated unit margin helps explain the size of the pricing problem.
-- Such products may generate losses even before order-level discounts are applied.
-- Concepts used: master-data validation, comparison, calculated column, ROUND.
SELECT
    product_id,
    product_name,
    unit_price,
    unit_cost,
    ROUND(unit_price - unit_cost, 2) AS unit_margin
FROM products
WHERE unit_price < unit_cost;

-- QUERY 48:
-- Finds individual orders with negative calculated profit.
-- The query includes all inputs used in the calculation so that the reason for the loss can be reviewed directly.
-- A loss may result from the relationship between price, cost and discount rather than from invalid data.
-- Concepts used: JOIN, calculated profit, WHERE on an expression.
SELECT
    s.order_id,
    p.product_name,
    s.quantity,
    p.unit_price,
    p.unit_cost,
    s.discount_rate,
    ROUND(
        s.quantity * p.unit_price * (1 - s.discount_rate)
        - s.quantity * p.unit_cost,
        2
    ) AS profit
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.quantity * p.unit_price * (1 - s.discount_rate)
      - s.quantity * p.unit_cost < 0;

-- QUERY 49:
-- Creates a complete customer-level summary report.
-- LEFT JOIN keeps customers even when they have no sales. Conditional aggregation counts completed orders and totals only completed revenue and profit.
-- The result can be used to identify the most valuable customers by completed revenue.
-- Concepts used: multiple LEFT JOINs, CASE inside SUM, GROUP BY, aggregate reporting.
SELECT
    c.customer_id,
    c.customer_email,
    c.region,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    ROUND(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
            ELSE 0
        END
    ), 2) AS completed_revenue,
    ROUND(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                 - s.quantity * p.unit_cost
            ELSE 0
        END
    ), 2) AS completed_profit
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
LEFT JOIN products p
    ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_email, c.region
ORDER BY completed_revenue DESC;

-- QUERY 50:
-- Returns the main management KPIs in a single summary row.
-- The query calculates total and completed orders, unique customers, completed units, revenue, profit and profit margin.
-- Conditional aggregation ensures that financial KPIs include completed orders only, while NULLIF safely handles a possible zero-revenue total.
-- Concepts used: COUNT, COUNT DISTINCT, CASE, SUM, calculated KPIs, NULLIF, ROUND.
SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN s.order_status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    COUNT(DISTINCT s.customer_id) AS unique_customers,
    SUM(CASE WHEN s.order_status = 'Completed' THEN s.quantity ELSE 0 END) AS units_sold,
    ROUND(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
            ELSE 0
        END
    ), 2) AS net_revenue,
    ROUND(SUM(
        CASE
            WHEN s.order_status = 'Completed'
            THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                 - s.quantity * p.unit_cost
            ELSE 0
        END
    ), 2) AS profit,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN s.order_status = 'Completed'
                THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                     - s.quantity * p.unit_cost
                ELSE 0
            END
        )
        / NULLIF(SUM(
            CASE
                WHEN s.order_status = 'Completed'
                THEN s.quantity * p.unit_price * (1 - s.discount_rate)
                ELSE 0
            END
        ), 0),
        2
    ) AS profit_margin_pct
FROM sales s
JOIN products p
    ON s.product_id = p.product_id;
