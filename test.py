import pandas as pd

dates = pd.date_range("2016-01-01", "2019-12-31")

dim_date = pd.DataFrame({
    "full_date": dates
})

dim_date["date_key"] = dim_date["full_date"].dt.strftime("%Y%m%d").astype(int)
dim_date["year"] = dim_date["full_date"].dt.year
dim_date["quarter"] = dim_date["full_date"].dt.quarter
dim_date["month"] = dim_date["full_date"].dt.month
dim_date["month_name"] = dim_date["full_date"].dt.month_name()
dim_date["day"] = dim_date["full_date"].dt.day
dim_date["day_name"] = dim_date["full_date"].dt.day_name()
dim_date["week"] = dim_date["full_date"].dt.isocalendar().week
dim_date["day_of_week"] = dim_date["full_date"].dt.dayofweek + 1
dim_date["is_weekend"] = dim_date["day_of_week"].isin([6, 7])

