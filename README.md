# FinFlow SaaS Revenue Analysis

> A self-directed data analysis project where no problem statement was given — just raw data. The goal was to explore a SaaS company's revenue database, find real business problems independently, and deliver actionable recommendations. This is how real analysts work.

---

## Project Structure

```
finflow-saas-analysis/
├── data/
│   └── finflow.db              # SQLite database (600 customers, 4 tables)
├── queries/
│   ├── 01_churn_analysis.sql        # Churn trend and sales rep investigation
│   ├── 02_payment_failure_analysis.sql  # Payment failure by plan, country, method
│   └── 03_revenue_patterns.sql      # Monthly revenue pattern analysis
├── charts/
│   ├── 01_churn_rate_by_year.png
│   ├── 02_churn_by_sales_rep.png
│   ├── 03_payment_failure_by_plan.png
│   └── 04_monthly_revenue_trend.png
├── finflow_analysis.ipynb      # Python visualizations
├── journey.txt                 # Raw thought process and findings log
└── README.md
```

---

## Database Schema

| Table | Key Columns |
|---|---|
| `customers` | customer_id, company_name, industry, country, signup_date, sales_rep |
| `subscriptions` | subscription_id, customer_id, plan, mrr, start_date, end_date, status |
| `payments` | payment_id, customer_id, subscription_id, amount, payment_date, status, payment_method |
| `cancellations` | cancellation_id, customer_id, subscription_id, cancellation_date, reason |

---

## What I Found

### Problem 1 — Churn Rate is Accelerating
Starting with no direction, I looked at the overall cancellation numbers: 169 out of 600 customers churned (~28%). But raw numbers are misleading — normalizing by customer count per year revealed the real story.

| Year | Customers | Churned | Churn Rate |
|---|---|---|---|
| 2022 | 238 | 31 | 13% |
| 2023 | 237 | 84 | 35% |
| 2024 | 125 | 54 | 43% |

Churn rate nearly tripled in two years. I then ruled out plan type as a cause — Starter (28.6%), Growth (28%), and Enterprise (26%) all churn at almost identical rates. The problem had to be somewhere else.

**Drilling into sales reps revealed the real issue:**

| Sales Rep | Customers | Churned | Churn Rate |
|---|---|---|---|
| Omar N. | 128 | 55 | **43%** |
| Priya M. | 125 | 37 | 29.6% |
| James T. | 114 | 27 | 23.7% |
| Linda W. | 111 | 26 | 23.4% |
| Sarah K. | 122 | 24 | **19.7%** |

Omar's churn rate is more than double Sarah's. Before concluding Omar is the problem, I validated whether his customers were harder to retain by nature — his industry distribution was perfectly even across all 6 industries, ruling out bad lead quality.

Cancellation reasons confirmed the finding: Omar's customers actively leave citing "Switching to competitor" (13), "Poor support" (13), and "Too expensive" (11). Sarah's customers leave passively due to "Business closed" and "Not using it enough" — nothing to do with FinFlow.

**Recommendation:** Management should review Omar's sales and onboarding process, gather direct feedback from his accounts, and investigate whether his customers' concerns about support quality and pricing reflect a broader competitive risk worth monitoring.

---

### Problem 2 — Enterprise Payment Failures Are Leaking Revenue
Overall payment failure rate is 5.2% — not alarming on its own. After ruling out country (max 1.2% difference across countries) and payment method (max 0.8% difference), the issue traced directly to plan type.

| Plan | Total Payments | Failed | Failure Rate | Revenue Lost |
|---|---|---|---|---|
| Enterprise | 762 | 127 | **16.7%** | **$101,336** |
| Starter | 3,856 | 155 | 4.0% | $15,317 |
| Growth | 2,747 | 100 | 3.6% | $29,803 |

Enterprise fails at 4x the rate of other plans, accounting for $101,336 of the $146,456 total revenue lost to failed payments. Enterprise customers likely pay via corporate accounts with internal approval processes — the failures are probably originating on their end, not FinFlow's.

**Recommendation:** Proactively reach out to Enterprise accounts with failed payments, offer dedicated billing support, and implement automatic payment retry logic and direct invoicing as alternative collection methods.

---

### Problem 3 — February Revenue Dip Repeats Every Year
Monthly revenue shows a strong overall growth trend from $4,455 in January 2022 to $99,243 in June 2024. However, February consistently breaks the pattern every year.

| Period | January | February | March | Feb Change |
|---|---|---|---|---|
| 2022 | $4,455 | $7,347 | $15,030 | +$2,892 (slowest growth) |
| 2023 | $50,936 | $51,238 | $60,111 | +$302 (nearly flat) |
| 2024 | $87,432 | $77,079 | $88,988 | **-$10,353 (actual drop)** |

The dip worsens each year in absolute terms. February's shorter billing cycle means some monthly subscriptions miss their payment window entirely. This is a systems issue, not a customer behavior issue.

**Recommendation:** Engineering should implement payment retry logic that accounts for shorter months, and billing cycles should be reviewed to ensure no subscription payment windows fall outside the month.

---

## Tools Used
- **SQLite** — data storage and querying
- **DB Browser for SQLite** — SQL execution
- **Python** — pandas, matplotlib, seaborn
- **Jupyter Notebook** — analysis and visualization
- **Git + GitHub** — version control

---

## Key Takeaway
This project was built without a pre-defined problem statement — just raw data and a blank slate. Every finding came from free exploration, hypothesis testing, and ruling out alternative explanations before drawing conclusions. That process is the actual work of a data analyst.
