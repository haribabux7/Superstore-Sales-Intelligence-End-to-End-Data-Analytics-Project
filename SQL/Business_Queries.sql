-- Business_Queries.sql: 30+ business questions with SQL, insight, and recommendation


/*
1. Business Question: What is total revenue, profit, and margin?
Business Insight: Baseline financial performance is established.
Recommendation: Track this KPI weekly and align targets to margin, not revenue alone.
*/
SELECT SUM(revenue) revenue, SUM(profit) profit, SUM(profit)/NULLIF(SUM(revenue),0) margin FROM superstore_cleaned;


/*
2. Business Question: Which category generates the highest revenue?
Business Insight: Revenue concentration differs by category.
Recommendation: Prioritize inventory and campaigns in leading categories.
*/
SELECT category, SUM(revenue) revenue FROM superstore_cleaned GROUP BY category ORDER BY revenue DESC;


/*
3. Business Question: Which category is least profitable?
Business Insight: A high-revenue category may still underperform on profit.
Recommendation: Audit discounting and supplier costs for weak categories.
*/
SELECT category, SUM(profit) profit FROM superstore_cleaned GROUP BY category ORDER BY profit ASC;


/*
4. Business Question: Which sub-categories lose money?
Business Insight: Loss-making sub-categories directly reduce enterprise profit.
Recommendation: Redesign pricing, promotions, and procurement terms.
*/
SELECT sub_category, SUM(profit) profit FROM superstore_cleaned GROUP BY sub_category HAVING SUM(profit)<0 ORDER BY profit;


/*
5. Business Question: Which region delivers the best profit?
Business Insight: Regional profit mix identifies strong markets.
Recommendation: Replicate best regional practices in weaker regions.
*/
SELECT region, SUM(profit) profit FROM superstore_cleaned GROUP BY region ORDER BY profit DESC;


/*
6. Business Question: Which state has the highest revenue?
Business Insight: Top states drive most commercial volume.
Recommendation: Protect stock availability and service levels in top states.
*/
SELECT state, SUM(revenue) revenue FROM superstore_cleaned GROUP BY state ORDER BY revenue DESC LIMIT 10;


/*
7. Business Question: Which state has the lowest profit?
Business Insight: Some states destroy value despite sales.
Recommendation: Review local pricing, shipping cost, and discount rules.
*/
SELECT state, SUM(profit) profit FROM superstore_cleaned GROUP BY state ORDER BY profit ASC LIMIT 10;


/*
8. Business Question: What is monthly revenue trend?
Business Insight: Trend highlights seasonality and growth periods.
Recommendation: Plan staffing and inventory around seasonal peaks.
*/
SELECT order_month, SUM(revenue) revenue FROM superstore_cleaned GROUP BY order_month ORDER BY order_month;


/*
9. Business Question: What is year-over-year revenue growth?
Business Insight: Growth rate shows business momentum.
Recommendation: Investigate years/months with below-target growth.
*/
WITH y AS (SELECT order_year, SUM(revenue) revenue FROM superstore_cleaned GROUP BY order_year) SELECT order_year, revenue, (revenue-LAG(revenue) OVER(ORDER BY order_year))/NULLIF(LAG(revenue) OVER(ORDER BY order_year),0) growth FROM y;


/*
10. Business Question: Which customer segment is most profitable?
Business Insight: Profit varies across Consumer, Corporate, and Home Office.
Recommendation: Tailor acquisition and retention spend by segment value.
*/
SELECT segment, SUM(profit) profit FROM superstore_cleaned GROUP BY segment ORDER BY profit DESC;


/*
11. Business Question: What is average order value by segment?
Business Insight: AOV identifies higher basket segments.
Recommendation: Use bundles and cross-sell to lift low-AOV segments.
*/
SELECT segment, SUM(revenue)/NULLIF(COUNT(DISTINCT order_id),0) aov FROM superstore_cleaned GROUP BY segment ORDER BY aov DESC;


/*
12. Business Question: Who are the top 10 customers by revenue?
Business Insight: Key accounts represent expansion opportunities.
Recommendation: Build VIP retention and account management programs.
*/
SELECT customer_id, customer_name, SUM(revenue) revenue FROM superstore_cleaned GROUP BY customer_id, customer_name ORDER BY revenue DESC LIMIT 10;


/*
13. Business Question: Who are the top 10 customers by profit?
Business Insight: Profit value differs from sales value.
Recommendation: Reward and retain high-profit customers.
*/
SELECT customer_id, customer_name, SUM(profit) profit FROM superstore_cleaned GROUP BY customer_id, customer_name ORDER BY profit DESC LIMIT 10;


/*
14. Business Question: Which customers are loss-making?
Business Insight: Some relationships may not be economically viable.
Recommendation: Adjust discount limits and shipping terms for loss-making accounts.
*/
SELECT customer_id, customer_name, SUM(profit) profit FROM superstore_cleaned GROUP BY customer_id, customer_name HAVING SUM(profit)<0 ORDER BY profit LIMIT 20;


/*
15. Business Question: What products sell the most units?
Business Insight: Unit velocity supports inventory planning.
Recommendation: Prioritize reorder points for fast-moving products.
*/
SELECT product_name, SUM(quantity) units FROM superstore_cleaned GROUP BY product_name ORDER BY units DESC LIMIT 10;


/*
16. Business Question: Which products have the lowest margin?
Business Insight: Low-margin products erode value at scale.
Recommendation: Renegotiate supplier cost or reduce promotional frequency.
*/
SELECT product_name, SUM(profit)/NULLIF(SUM(revenue),0) margin FROM superstore_cleaned GROUP BY product_name HAVING SUM(revenue)>1000 ORDER BY margin ASC LIMIT 10;


/*
17. Business Question: How does discount level impact profit?
Business Insight: Deeper discounts often reduce margin.
Recommendation: Set approval workflows for high discounts.
*/
SELECT discount_band, SUM(revenue) revenue, SUM(profit) profit, AVG(profit_margin) avg_margin FROM superstore_cleaned GROUP BY discount_band ORDER BY avg_margin;


/*
18. Business Question: Which orders had high discount and negative profit?
Business Insight: High discount exceptions create avoidable losses.
Recommendation: Review sales rep discount authority and exception controls.
*/
SELECT order_id, customer_name, product_name, discount, revenue, profit FROM superstore_cleaned WHERE discount>=0.3 AND profit<0 ORDER BY profit ASC LIMIT 50;


/*
19. Business Question: Which ship mode is most profitable?
Business Insight: Shipping choices influence profitability and service.
Recommendation: Promote modes balancing speed and margin.
*/
SELECT ship_mode, SUM(profit) profit, AVG(ship_days) avg_ship_days FROM superstore_cleaned GROUP BY ship_mode ORDER BY profit DESC;


/*
20. Business Question: What is average shipping time by region?
Business Insight: Long lead times can affect retention.
Recommendation: Improve fulfillment routes in slow regions.
*/
SELECT region, AVG(ship_days) avg_ship_days FROM superstore_cleaned GROUP BY region ORDER BY avg_ship_days DESC;


/*
21. Business Question: Which city produces the highest revenue?
Business Insight: City-level hotspots support localized marketing.
Recommendation: Run focused campaigns in high-potential cities.
*/
SELECT city, state, SUM(revenue) revenue FROM superstore_cleaned GROUP BY city, state ORDER BY revenue DESC LIMIT 10;


/*
22. Business Question: Which city has the worst profit?
Business Insight: Losses can be geographically clustered.
Recommendation: Assess freight cost and local discounting in weak cities.
*/
SELECT city, state, SUM(profit) profit FROM superstore_cleaned GROUP BY city, state ORDER BY profit ASC LIMIT 10;


/*
23. Business Question: What share of orders are profitable?
Business Insight: Order-level profit mix reveals operational health.
Recommendation: Reduce loss-making orders through price and discount controls.
*/
SELECT profitability_status, COUNT(DISTINCT order_id) orders FROM superstore_cleaned GROUP BY profitability_status;


/*
24. Business Question: What is customer repeat rate?
Business Insight: Repeat purchase behavior indicates retention quality.
Recommendation: Create retention journeys for first-time buyers.
*/
WITH c AS (SELECT customer_id, COUNT(DISTINCT order_id) orders FROM superstore_cleaned GROUP BY customer_id) SELECT AVG(CASE WHEN orders>1 THEN 1.0 ELSE 0 END) repeat_rate FROM c;


/*
25. Business Question: What is customer lifetime value distribution?
Business Insight: CLV helps separate strategic accounts from low-value accounts.
Recommendation: Invest service resources based on profit-based CLV.
*/
SELECT customer_id, customer_name, SUM(profit) lifetime_profit FROM superstore_cleaned GROUP BY customer_id, customer_name ORDER BY lifetime_profit DESC;


/*
26. Business Question: Which segment responds with most orders?
Business Insight: Order frequency indicates demand depth.
Recommendation: Design segment-specific order frequency campaigns.
*/
SELECT segment, COUNT(DISTINCT order_id) orders FROM superstore_cleaned GROUP BY segment ORDER BY orders DESC;


/*
27. Business Question: Which sub-category has high revenue but low profit?
Business Insight: High-volume/low-profit areas need management attention.
Recommendation: Shift promotions from volume to profitable bundles.
*/
SELECT sub_category, SUM(revenue) revenue, SUM(profit) profit FROM superstore_cleaned GROUP BY sub_category HAVING SUM(revenue)>50000 ORDER BY profit ASC;


/*
28. Business Question: What is revenue per customer by region?
Business Insight: Revenue productivity varies by market.
Recommendation: Increase penetration in low productivity regions.
*/
SELECT region, SUM(revenue)/NULLIF(COUNT(DISTINCT customer_id),0) revenue_per_customer FROM superstore_cleaned GROUP BY region ORDER BY revenue_per_customer DESC;


/*
29. Business Question: Which month has highest profit?
Business Insight: Peak profit months indicate demand and margin windows.
Recommendation: Plan campaigns and staffing before peak months.
*/
SELECT order_month, SUM(profit) profit FROM superstore_cleaned GROUP BY order_month ORDER BY profit DESC LIMIT 5;


/*
30. Business Question: Which category has the highest return on discount?
Business Insight: Discount efficiency differs by category.
Recommendation: Allocate promotions to categories where discounts generate profitable revenue.
*/
SELECT category, SUM(profit)/NULLIF(SUM(discount*revenue),0) profit_per_discounted_revenue FROM superstore_cleaned WHERE discount>0 GROUP BY category ORDER BY profit_per_discounted_revenue DESC;


/*
31. Business Question: What are products with high sales outlier flags?
Business Insight: Sales outliers may be strategic bulk orders.
Recommendation: Separate enterprise deals from normal forecasting models.
*/
SELECT product_name, COUNT(*) outlier_lines, SUM(revenue) revenue FROM superstore_cleaned WHERE sales_outlier_flag=1 GROUP BY product_name ORDER BY outlier_lines DESC LIMIT 10;
