# Customer Churn Analysis

A five-person team project examining customer churn in a subscription dataset. The workflow combines Python data preparation, SQL analysis, and a Power BI report to describe churn patterns and customer segments that may warrant retention attention.

## Project Objectives

- Measure the overall churn rate and compare it across customer segments.
- Examine relationships between churn and contract length, subscription plan, support calls, payment delays, tenure, spend, and recent interaction.
- Create a simple rule-based risk grouping for follow-up analysis.

## Tools and Technologies

- Python and pandas for data cleaning and feature engineering
- SQL Server / T-SQL for aggregation and segment analysis
- Power BI for report visuals and filters

## Dataset

The source dataset contains 440,832 non-empty customer records and 12 original columns. The cleaning notebook removes one fully blank row, checks for duplicate customer IDs and missing values, standardizes names and types, then adds eight derived columns for a 20-column analysis table.

Source: [Customer Churn Dataset on Kaggle](https://www.kaggle.com/datasets/muhammadshahidazeem/customer-churn-dataset). Follow the dataset page's license and attribution terms.

## Analysis Workflow

1. Run `notebooks/customer_churn_data_cleaning.ipynb`. The original notebook reads the source CSV from its current working directory and writes `churn_clean.csv` to that same directory. The committed processed file was recreated using the same cleaning and feature-engineering steps.
2. Load `data/processed/churn_clean.csv` into SQL Server as `churn_clean` and run `sql/customer_churn_analysis.sql`.
3. Open `reports/customer_churn_dashboard.pbix` in Power BI Desktop. The report package references churn, revenue, customer-count, average-spend, and average-tenure measures, along with segment visuals and slicers for age group, gender, and subscription type.
4. Review `reports/customer_churn_analysis.pptx` for the team's SQL walkthrough and summarized findings.

## Power BI Report Contents

The report package contains two report pages named `Page 1` and `Page 2`, each marked as a tooltip page in the embedded report definition. The visuals reference churn rates, customer counts, revenue, spending, tenure, contract length, support-call groups, payment-delay groups, and inactivity groups. The presentation describes three dashboard views (`Overview`, `Risk Drivers`, and `Weak Factors`), so the page structure should be confirmed in Power BI Desktop before describing it as a three-page dashboard.

DAX measure names are visible in the report metadata, but their formulas could not be extracted from the supplied package. The report archive passed an integrity check; it was not opened in Power BI Desktop in this environment.

## Verified Findings

These figures were recalculated from the full original CSV, not from the truncated cleaned CSV that was supplied.

- **Overall churn:** 249,999 of 440,832 customers, or **56.71%**.
- **Contract length:** all 87,104 monthly-contract records are marked churned (**100%**); annual and quarterly contract churn rates are **46.08%** and **46.03%**.
- **Subscription type:** Basic is **58.18%**, Standard **56.07%**, and Premium **55.94%**.
- **Gender segment:** Female records show **66.67%** churn and male records **49.13%**. This is a descriptive association in the supplied dataset, not evidence that gender causes churn.
- **Average behavior among churned vs. retained records:** support calls **5.14 vs. 1.59**; payment delay **15.22 vs. 10.02 days**; total spend **541.29 vs. 749.95**; days since last interaction **15.60 vs. 13.01**.

These comparisons are descriptive and do not establish causation.

## Project Files

- `data/raw/customer_churn_dataset-training-master.csv` — original dataset
- `data/processed/churn_clean.csv` — full 440,832-row cleaned dataset regenerated using the supplied notebook logic
- `notebooks/customer_churn_data_cleaning.ipynb` — data cleaning and feature engineering
- `sql/customer_churn_analysis.sql` — SQL Server table definition and analysis queries
- `reports/customer_churn_dashboard.pbix` — Power BI report package
- `reports/customer_churn_analysis.pptx` — project presentation

## Team Project and My Contribution

**Team project:** completed by a team of five.

**My contribution:** I contributed to multiple phases of the project as part of the team.

## Artifact Notes

- The SQL file contains 14 numbered analysis sections, while the presentation describes 15 business questions. The presentation's risk rule also differs from the SQL script's rule; use the SQL file as the source for its query logic.
- The originally supplied `churn_clean.csv` contains 222,462 rows and matches the first 222,462 records of the original dataset, rather than the 440,832 rows reported by the notebook. Since churn records are concentrated near the start of this ordered dataset, that partial file overstates churn at about 98.4%. It is not included here; the processed CSV was recreated from the original source using the supplied notebook's cleaning and feature-engineering steps.
- The provided cover graphic includes labels such as “Monthly Charges” and “Payment Method,” which are not columns in the supplied dataset. It is not included as a dashboard preview. The additional screenshot supplied shows the SQL editor, not the Power BI dashboard.
