SELECT CAST(SUM(sub.salary + calc.bonus) AS DECIMAL(19,2)) AS total_salary_with_bonuses  -- Debug: SELECT sub.employee_id, sub.name, sub.salary, sub.last_review_score, sub.avg_score, calc.bonus, sub.salary + calc.bonus AS salary_with_bonuses
  FROM (SELECT e.employee_id, e.name, e.salary
             , c2.last_review_score
             , AVG(c2.last_review_score) OVER () AS avg_score
          FROM employees AS e
         CROSS APPLY (SELECT LEN(REPLACE(REPLACE(YEAR_END_PERFORMANCE_SCORES, '[', ''), ']', '')) - CHARINDEX(',', REVERSE(REPLACE(REPLACE(YEAR_END_PERFORMANCE_SCORES, '[', ''), ']', ''))) + 1 AS pos_last_comma) AS c1
         CROSS APPLY (
		 SELECT CAST(SUBSTRING(REPLACE(REPLACE(YEAR_END_PERFORMANCE_SCORES, '[', ''), ']', ''), c1.pos_last_comma + 1, 999) AS DEC(5,2)) AS last_review_score 
		 ) AS c2
       ) AS sub
  CROSS APPLY (SELECT IIF(sub.last_review_score > sub.avg_score, sub.salary * 0.15, 0) AS bonus
              ) AS calc
;