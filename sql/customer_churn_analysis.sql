/* =====================================================
   Customer Churn Analysis - SQL
   Table: churn_clean  (from churn_clean.csv, 440,832 customers)
   الهدف: نعرف مين العملاء اللي بيسيبوا، وليه، ومين اللي في خطر
   ===================================================== */

-- 0. إنشاء الجدول (بنحدد أسماء الأعمدة وأنواعها)، وبعدين نستورد ملف churn_clean.csv فيه
CREATE TABLE churn_clean (
    customer_id          INT PRIMARY KEY,
    age                  INT,
    gender               VARCHAR(10),
    tenure               INT,
    usage_frequency      INT,
    support_calls        INT,
    payment_delay        INT,
    subscription_type    VARCHAR(20),
    contract_length      VARCHAR(20),
    total_spend          INT,
    last_interaction     INT,
    churn                INT,
    churn_label          VARCHAR(10),
    age_group            VARCHAR(10),
    tenure_group         VARCHAR(10),
    spend_group          VARCHAR(15),
    support_calls_group  VARCHAR(20),
    payment_delay_group  VARCHAR(20),
    inactivity_group     VARCHAR(10),
    avg_monthly_spend    DECIMAL(10,2)
);

-- Q1. نسبة الـ Churn الكلية كام؟
SELECT COUNT(*) AS total_customers,
       SUM(churn) AS churned_customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean;

-- Q2. هل نوع الاشتراك (Basic / Standard / Premium) بيأثر على الـ Churn؟
SELECT subscription_type,
       COUNT(*) AS customers,
       SUM(churn) AS churned,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY subscription_type
ORDER BY churn_rate_pct DESC;

-- Q3. أنهي مدة عقد (شهري / ربع سنوي / سنوي) أكتر تسرباً؟
SELECT contract_length,
       COUNT(*) AS customers,
       SUM(churn) AS churned,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY contract_length
ORDER BY churn_rate_pct DESC;

-- Q4. هل كتر مكالمات خدمة العملاء بيزود الـ Churn؟
SELECT support_calls_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY support_calls_group
ORDER BY MIN(support_calls);

-- Q5. هل التأخر في الدفع مرتبط بالمغادرة؟
SELECT payment_delay_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY payment_delay_group
ORDER BY MIN(payment_delay);

-- Q6. هل العميل القديم (مدة اشتراك أطول) أكتر ولاء؟
SELECT tenure_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY tenure_group
ORDER BY MIN(tenure);

-- Q7. أنهي فئة عمرية أكتر تسرباً؟
SELECT age_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY age_group
ORDER BY MIN(age);

-- Q8. هل العملاء اللي بيصرفوا أكتر بيمشوا أقل؟
SELECT spend_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY spend_group
ORDER BY MIN(total_spend);

-- Q9. هل في فرق بين الذكور والإناث في الـ Churn؟
SELECT gender,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY gender;

-- Q10. هل العملاء اللي بعدوا عن التفاعل بيمشوا أكتر؟
SELECT inactivity_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY inactivity_group
ORDER BY MIN(last_interaction);

-- Q11. بروفايل العميل: اللي مشي مقابل اللي فضل (متوسط كل مؤشر)
SELECT churn_label,
       COUNT(*) AS customers,
       ROUND(AVG(age), 1) AS avg_age,
       ROUND(AVG(tenure), 1) AS avg_tenure,
       ROUND(AVG(usage_frequency), 1) AS avg_usage,
       ROUND(AVG(support_calls), 1) AS avg_support_calls,
       ROUND(AVG(payment_delay), 1) AS avg_payment_delay,
       ROUND(AVG(total_spend), 0) AS avg_spend,
       ROUND(AVG(last_interaction), 1) AS avg_days_since_contact
FROM churn_clean
GROUP BY churn_label;

-- Q12. إيراد العملاء اللي مشيوا يمثل كام من إجمالي الإنفاق؟
SELECT churn_label,
       SUM(total_spend) AS total_spend,
       ROUND(100.0 * SUM(total_spend) / (SELECT SUM(total_spend) FROM churn_clean), 1) AS pct_of_total_spend
FROM churn_clean
GROUP BY churn_label;

-- Q13. أنهي شرائح العملاء الأعلى تسرباً؟ (تجميع 3 عوامل مع بعض)
SELECT contract_length,
       support_calls_group,
       payment_delay_group,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM churn_clean
GROUP BY contract_length, support_calls_group, payment_delay_group
HAVING COUNT(*) >= 1000          -- تجاهل الشرائح الصغيرة جداً
ORDER BY churn_rate_pct DESC;

-- Q14. تقسيم العملاء لمستويات خطر (High / Medium / Low): كام عميل في كل مستوى؟
WITH risk AS (
    SELECT *,
           CASE
               WHEN contract_length = 'Monthly' OR support_calls >= 6 OR payment_delay >= 21 THEN 'High risk'
               WHEN support_calls BETWEEN 3 AND 5 OR payment_delay BETWEEN 11 AND 20 THEN 'Medium risk'
               ELSE 'Low risk'
           END AS risk_level
    FROM churn_clean
)
SELECT risk_level,
       COUNT(*) AS customers,
       ROUND(100.0 * SUM(churn) / COUNT(*), 1) AS churn_rate_pct
FROM risk
GROUP BY risk_level
ORDER BY churn_rate_pct DESC;
