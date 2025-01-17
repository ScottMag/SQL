SELECT sub.quarter
     , CONCAT(YEAR(sub.quarter), ',', DATEPART(QUARTER, sub.quarter)) AS formated_result
     , sub.total_sales
     ,  LAG(sub.total_sales, 1) OVER (ORDER BY sub.quarter) AS total_sales_prev
     ,  (sub.total_sales / LAG(sub.total_sales, 1) OVER (ORDER BY sub.quarter)) - 1  AS growth_rate
  FROM (SELECT calc.quarter, SUM(s.amount) AS total_sales 
          FROM dbo.sales AS s
         CROSS APPLY (SELECT DATE_BUCKET(QUARTER, 1, s.sale_date) AS quarter) AS calc
         GROUP BY calc.quarter
       ) AS sub
 ORDER BY growth_rate DESC