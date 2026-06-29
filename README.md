[7.md](https://github.com/user-attachments/files/29463157/7.md)
# 📊 Superstore Sales Intelligence — End-to-End Data Analytics Project

A complete, portfolio-grade **retail sales analytics solution** built on the popular Superstore dataset. The project takes raw transactional data through a full analytics lifecycle — **cleaning, exploration, SQL business intelligence, visual storytelling, and an interactive Streamlit dashboard** — to surface the kind of insights an actual operations or revenue team would act on.

It is designed as a reference implementation for aspiring **Data Analysts, Analytics Engineers, and BI Developers** who want to demonstrate strong fundamentals across **Python, SQL, Pandas, Plotly, and Streamlit** in one cohesive repository.

Built with a strong emphasis on reproducibility, this project ships with the raw dataset, the cleaning pipeline, the SQL workbooks, the Jupyter notebooks, and a deployable dashboard — so anyone can clone the repo and reproduce every chart, KPI, and recommendation end-to-end.

---

## 🧭 Overview

The **Superstore Sales Intelligence** project converts a raw, messy retail order log into a curated analytics product. The goal is to answer the questions a real CFO, Sales Director, or Category Manager would ask — and to back every answer with a query, a chart, and a recommendation.

**Purpose**
- Provide a reproducible blueprint for transforming raw CSV transactions into trustworthy KPIs.
- Demonstrate the modern Analytics workflow: *clean → explore → model → visualize → narrate*.

**Business Value**
- Identifies which **regions, categories, and customer segments** drive revenue vs. losses.
- Quantifies **discount cannibalisation** on margin.
- Surfaces **top customers**, **shipping inefficiencies**, and **product-mix risks**.

**User Benefits**
- Analysts get reusable SQL and Python templates.
- Stakeholders get a live, filterable dashboard instead of static slides.
- Recruiters get a clear, structured demonstration of analytical depth.

**Main Functionality**
- Automated data-cleaning pipeline (`clean_pipeline.py`)
- 30+ business SQL queries with embedded insights and recommendations
- EDA + Visualisation notebooks
- Interactive **Streamlit dashboard** with KPI cards, filters, geo maps, and auto-generated narrative insights

---

## ✨ Features

### Core Features
- ✅ End-to-end ETL pipeline (raw → cleaned → analytics-ready)
- ✅ Reusable Python cleaning module with column normalisation & type coercion
- ✅ 30+ business-driven SQL queries (revenue, profit, churn, RFM, segmentation)
- ✅ Exploratory Data Analysis notebook with statistical summaries
- ✅ Visualisation notebook with publication-grade charts

### User Features
- ✅ Upload your own CSV or use the bundled cleaned dataset
- ✅ KPI cards: Revenue, Profit, Orders, Customers, AOV, Margin
- ✅ Filters: Date range, Region, Category, Segment
- ✅ Geo choropleth (US state-level revenue map)
- ✅ Downloadable filtered data + auto-generated insight report

### Admin / Analyst Features
- ✅ Configurable cleaning thresholds and rules
- ✅ SQL workbook structure ready to be ported to dbt models
- ✅ Notebook-to-dashboard parity so insights stay in sync

### Advanced Features
- ✅ Correlation heatmap across numeric fields
- ✅ Top performer analysis (customers, products, sub-categories)
- ✅ Dynamic narrative engine — the dashboard *writes the insight*, not just plots it
- ✅ Cohort/seasonality views via time-series resampling

### Security Features
- ✅ No PII stored — dataset is anonymised retail transactions
- ✅ Secrets handled via `.env` (never hardcoded)
- ✅ Read-only data layer for dashboard (no destructive SQL exposed)
- ✅ Input validation on uploaded CSVs (schema + dtype checks)

---
## 🛠️ Tech Stack

### Frontend / Visualization
- Streamlit (interactive dashboard UI)
- Plotly Express (interactive charts & choropleth)
- Matplotlib & Seaborn (notebook-grade statistical plots)

### Backend / Processing
- Python 3.10+
- Pandas (data manipulation)
- NumPy (numerical computation)

### Database
- MySQL / PostgreSQL (SQL workbook portable to both)
- SQLite (local prototyping)

### Data Analytics
- Jupyter Notebooks (EDA, visualisation)
- Kaleido (static chart export)
- openpyxl (Excel export)

### DevOps & Deployment
- Streamlit Community Cloud
- Docker (optional containerisation)
- GitHub Actions (CI for linting + notebook execution)

### Development Tools
- VS Code / PyCharm
- JupyterLab
- Git & GitHub
- pytest (unit tests for the cleaning pipeline)

---

## 🏗️ Architecture

The project follows a classic **medallion-style analytics architecture**:

```
        ┌────────────────┐
        │  Raw_Data.csv  │  (Bronze)
        └───────┬────────┘
                │  clean_pipeline.py
                ▼
        ┌────────────────┐
        │ Cleaned_Data.  │  (Silver)
        │     csv        │
        └───────┬────────┘
                │
     ┌──────────┼─────────────┐
     ▼          ▼             ▼
┌─────────┐ ┌─────────┐  ┌──────────────┐
│   SQL   │ │   EDA   │  │ Visualization│   (Gold)
│ Queries │ │Notebook │  │   Notebook   │
└────┬────┘ └────┬────┘  └──────┬───────┘
     └───────────┼──────────────┘
                 ▼
        ┌────────────────┐
        │ Streamlit App  │  ←  end users / stakeholders
        └────────────────┘
```

**Client–Server Communication**
- Streamlit serves the UI over HTTP; user filter events trigger Python callbacks that re-aggregate cached Pandas frames (`@st.cache_data`).

**Database Relationships**
- The SQL layer models a single denormalised `superstore` table, but queries demonstrate how to derive `customers`, `products`, and `orders` dimensions for a future star schema.

---

## 📁 Project Structure

```
superstore-sales-intelligence/
│
├── Data-Analytics-Project/
│   ├── Dataset/
│   │   ├── Raw_Data.csv           # Source transactions
│   │   └── Cleaned_Data.csv       # Analytics-ready dataset
│   │
│   ├── Python/
│   │   ├── clean_pipeline.py      # ETL / cleaning script
│   │   ├── Dashboard.py           # Streamlit dashboard
│   │   ├── Data_Cleaning.ipynb    # Cleaning walkthrough
│   │   ├── EDA.ipynb              # Exploratory analysis
│   │   ├── Data_Visualization.ipynb
│   │   └── Requirements.txt
│   │
│   └── SQL/
│       ├── Data_Cleaning.sql      # Server-side cleaning
│       ├── EDA.sql                # Exploratory SQL
│       └── Business_Queries.sql   # 30+ business questions
│
├── docs/
│   └── screenshots/               # README images
│
├── tests/                         # pytest suite (cleaning + utils)
├── scripts/                       # helper scripts (export, deploy)
├── config/                        # config files / dashboard theme
└── README.md
```

**Folder roles**
- `Dataset/` — versioned raw + cleaned data.
- `Python/` — pipeline, notebooks, dashboard app.
- `SQL/` — portable SQL workbooks (MySQL / PostgreSQL).
- `docs/` — screenshots and supplementary documentation.
- `tests/` — unit tests for the cleaning pipeline.
- `scripts/` — automation helpers (export charts, deploy app).
- `config/` — environment and theme configuration.

---

## ⚙️ Installation

### Prerequisites
- Python **3.10+**
- pip / virtualenv
- Git
- (Optional) MySQL or PostgreSQL for SQL workbooks

### Clone the Repository
```bash
git clone https://github.com/haribabux7/superstore-sales-intelligence.git
cd superstore-sales-intelligence/Data-Analytics-Project
```

### Create Virtual Environment
```bash
python -m venv .venv
source .venv/bin/activate     # macOS / Linux
.venv\Scripts\activate        # Windows
```

### Install Dependencies
```bash
pip install -r Python/Requirements.txt
```

### Configure Environment Variables
Create a `.env` file in the project root (see the [Environment Variables](#-environment-variables) section).

### Start the Dashboard
```bash
streamlit run Python/Dashboard.py
```

The app will be available at **http://localhost:8501**.

---

## 🔐 Environment Variables

Create a `.env` file:

```env
PORT=8501
DATABASE_URL=postgresql://user:password@localhost:5432/superstore
MONGO_URI=mongodb://localhost:27017/superstore
JWT_SECRET=replace-with-a-long-random-string
API_KEY=your-internal-api-key
EMAIL_HOST=smtp.gmail.com
EMAIL_USER=your-email@example.com
EMAIL_PASSWORD=your-app-password
```

| Variable | Description |
|---|---|
| `PORT` | Port for the Streamlit server |
| `DATABASE_URL` | Connection string for PostgreSQL/MySQL |
| `MONGO_URI` | Optional MongoDB connection (future use) |
| `JWT_SECRET` | Secret for any auth-protected extension |
| `API_KEY` | Internal API key for scheduled jobs |
| `EMAIL_*` | SMTP credentials for emailing reports |

---

## 🚀 Usage

**Typical workflow**
1. Drop a new monthly extract into `Dataset/Raw_Data.csv`.
2. Run `python Python/clean_pipeline.py` to regenerate `Cleaned_Data.csv`.
3. Open `EDA.ipynb` to review distributional changes.
4. Refresh `streamlit run Python/Dashboard.py` to publish updated KPIs.
5. Share filtered CSVs or auto-generated insight reports with stakeholders.

**Example scenarios**
- *Category Manager:* identify which sub-categories produced negative profit last quarter.
- *Sales Director:* compare regional growth rates and segment contribution.
- *Operations:* analyse shipping mode efficiency vs. delivery delay.

**Best practices**
- Treat `Raw_Data.csv` as immutable.
- Re-run the pipeline whenever upstream schema changes.
- Pin notebook outputs in PRs to make analytical diffs reviewable.

---

## 🔌 API Documentation

The dashboard exposes a thin internal API surface for automation:

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/kpis` | Returns current KPI snapshot |
| GET | `/api/insights` | Returns auto-generated narrative insights |
| POST | `/api/upload` | Upload a new CSV for analysis |
| PUT | `/api/filters` | Update active filter context |
| DELETE | `/api/cache` | Invalidate Streamlit data cache |

**Example request**
```bash
curl -X GET http://localhost:8501/api/kpis
```

**Example response**
```json
{
  "revenue": 2297200.86,
  "profit": 286397.02,
  "orders": 5009,
  "customers": 793,
  "aov": 458.62,
  "margin_pct": 12.47
}
```

---

## 🗄️ Database Schema

**Main table — `superstore`**

| Column | Type | Description |
|---|---|---|
| `row_id` | INT | Surrogate key |
| `order_id` | VARCHAR | Business order identifier |
| `order_date`, `ship_date` | DATE | Order lifecycle dates |
| `ship_mode` | VARCHAR | Shipping class |
| `customer_id`, `customer_name`, `segment` | VARCHAR | Customer dimension |
| `country`, `city`, `state`, `postal_code`, `region` | VARCHAR | Geographic dimension |
| `product_id`, `category`, `sub_category`, `product_name` | VARCHAR | Product dimension |
| `sales`, `quantity`, `discount`, `profit` | NUMERIC | Measures |

**Relationships (future star-schema split)**
- `fact_orders` → `dim_customers`, `dim_products`, `dim_geography`, `dim_date`

---

## 🧪 Testing

### Unit Testing
```bash
pytest tests/
```

### Integration Testing
- End-to-end pipeline check: raw CSV → cleaned CSV → KPI parity vs. expected snapshot.

### End-to-End Testing
- Streamlit UI smoke tests via `streamlit testing` framework.

**Tools used:** `pytest`, `pandas.testing`, `nbval` (for notebook validation).

---

## ⚡ Performance Optimizations

- **Caching:** `@st.cache_data` on data loads and aggregations.
- **Lazy Loading:** charts render only for the active tab/filter.
- **Pagination:** top-N tables capped server-side.
- **Query Optimization:** indexed `order_date`, `region`, `category` in SQL.
- **Code Splitting:** dashboard layout split into pure functions.
- **Compression:** CSV exports gzip-compressed where supported.

---

## 🛡️ Security Features

- **Authentication:** optional Streamlit-Auth / OAuth integration.
- **Authorization:** role-aware filter scopes (analyst vs. viewer).
- **Password Encryption:** bcrypt for any auth extensions.
- **JWT Security:** short-lived tokens with rotating secrets.
- **Input Validation:** strict schema + dtype validation on CSV uploads.
- **Rate Limiting:** per-IP throttling on upload endpoints.
- **CSRF Protection:** enabled on form submissions.
- **Secure API Practices:** parameterised SQL, no string concatenation.

---

## ☁️ Deployment

This project is portable across major platforms:

- **Streamlit Community Cloud** — push to GitHub, link the repo, set entrypoint to `Python/Dashboard.py`.
- **Vercel / Netlify** — for static notebook exports (`nbconvert --to html`).
- **Render / Railway** — Dockerized deployment of the Streamlit app.
- **AWS** — ECS Fargate + ALB, or EC2 with Nginx reverse proxy.
- **Azure** — Azure App Service (Linux, Python runtime).

**CI/CD overview**
- GitHub Actions runs lint (`ruff`), tests (`pytest`), and notebook execution on every PR.
- A successful merge to `main` triggers a redeploy to Streamlit Cloud.

---

## 🧩 Challenges & Solutions

- **Inconsistent column naming in raw data** — Solved by introducing a normalisation step in `clean_pipeline.py` that lower-cases and snake-cases all columns before any downstream code runs.
- **Date parsing failures across locales** — Solved by coercing with `errors="coerce"` and quarantining unparseable rows for review instead of silently dropping them.
- **Negative-profit SKUs distorting margin charts** — Solved by adding a dedicated *unprofitable sub-categories* view rather than hiding them, so the insight is visible, not masked.
- **Notebook ↔ dashboard drift** — Solved by extracting shared aggregations into a single Python module imported by both the notebooks and the Streamlit app.
- **Slow re-renders on large CSV uploads** — Solved with `@st.cache_data` + early `dtype` downcasting to reduce memory pressure.

---

## 🔮 Future Improvements

1. Migrate the SQL workbook into a **dbt** project with tests & docs.
2. Add a **forecasting** module (Prophet / statsforecast) for revenue projection.
3. Layer **RFM customer segmentation** with cohort retention curves.
4. Plug in **OpenAI / Gemini** to turn the narrative engine into a true Q&A copilot.
5. Add **role-based access control** for multi-team dashboards.
6. Ship a **Dockerfile + docker-compose** stack (app + Postgres + pgAdmin).
7. Introduce **Great Expectations** data quality gates in CI.
8. Add an **anomaly detection** view for sudden margin or volume swings.
9. Build a **PDF executive report** generator from the current filter context.
10. Expand geographic analysis to **country-level** beyond the US.
11. Add **A/B test analysis templates** for marketing campaigns.
12. Implement **scheduled email digests** of weekly KPI deltas.

---

## 🤝 Contributing

Contributions are welcome and encouraged!

1. **Fork** the repository
2. Create a **feature branch**: `git checkout -b feat/your-feature`
3. **Commit** your changes: `git commit -m "feat: add your feature"`
4. **Push** the branch: `git push origin feat/your-feature`
5. Open a **Pull Request**

**Coding standards**
- Follow **PEP 8** and run `ruff` before pushing.
- Keep notebooks **clean of outputs** unless they document a result.
- Write a **unit test** for every cleaning or transformation change.
- Use **conventional commits** (`feat:`, `fix:`, `docs:`, `refactor:`...).

---

## ❓ FAQ

**Q: Do I need a database to run this project?**
A: No — the Streamlit dashboard and notebooks run entirely off the bundled CSVs. The SQL workbook is optional and educational.

**Q: Can I plug in my own dataset?**
A: Yes. Any CSV with the same column contract will work; otherwise extend `clean_pipeline.py` with a new mapper.

**Q: Why Streamlit instead of Power BI / Tableau?**
A: Streamlit keeps everything in code, version-controlled and reproducible — ideal for an engineering-grade analytics portfolio.

**Q: Is the data real?**
A: It's the public **Superstore** sample dataset — synthetic but realistic.

**Q: Can I deploy this for free?**
A: Yes, **Streamlit Community Cloud** offers a free tier suitable for this project.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**HARI BABU C H**

- **Role:** Frontend Developer | Data Analyst
- **GitHub:** [github.com/haribabux7](https://github.com/haribabux7)
- **LinkedIn:** [linkedin.com/in/haribabux7](https://www.linkedin.com/in/haribabux7)
- **Portfolio:** [haribabu.me](https://www.haribabu.me)
- **Email:** [haribabuc458@gmail.com](mailto:haribabuc458@gmail.com)

---

## 🙏 Acknowledgements

- **Open Source Libraries:** Pandas, NumPy, Plotly, Streamlit, Seaborn, Matplotlib, Jupyter.
- **Dataset:** Tableau's public *Superstore* sample dataset.
- **Learning Resources:** Kaggle community notebooks, Mode Analytics SQL tutorials, the official Streamlit gallery.
- **Inspiration:** Real-world BI dashboards used in retail and e-commerce operations.
- **Contributors:** Everyone who has opened an issue or sent a PR — thank you.

---

## 📌 Project Information

| Field | Value |
|---|---|
| Version | 1.0.0 |
| Designed Date | November 2025 |
| Author | Hari Babu C H |
| License | MIT |
| Status | Active |

