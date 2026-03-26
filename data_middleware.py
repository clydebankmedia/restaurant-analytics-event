from pathlib import Path
import sqlite3
import pandas as pd

data_path = Path("db_data")
db_file = data_path / "restaurant_analytics.sqlite"

# Query function
def query(sql):
    with sqlite3.connect(db_file) as conn:
        df = pd.read_sql_query(sql, conn)
        return df

# Execute query
df_query_result = query("""
SELECT 
	DATE(order_timestamp) AS day,
	ROUND(SUM(total), 2) AS revenue,
	COUNT(*) AS num_orders
FROM orders
GROUP BY day
ORDER BY day;
""")

# Print the head to check the result
print(df_query_result.head())

# Save the full result to file
df_query_result.to_csv("daily_revenue.csv", index=False)


#------------------------------------------------
# PART 2

df_query_result = query("""
    SELECT
      strftime('%w', order_timestamp) AS dow_num,
      strftime('%H', order_timestamp) AS hour,
      COUNT(*) AS orders
    FROM orders
    GROUP BY dow_num, hour
    ORDER BY dow_num, hour;
""")
print(df_query_result.head())

day_map = {
    "0": "Sun",
    "1": "Mon",
    "2": "Tue",
    "3": "Wed",
    "4": "Thu",
    "5": "Fri",
    "6": "Sat"
}

df_query_result["dow_num"] = df_query_result["dow_num"].astype(str)
df_query_result["hour"] = df_query_result["hour"].astype(int)
df_query_result["day"] = df_query_result["dow_num"].map(day_map)

heatmap_df = pd.pivot_table(
    df_query_result,
    index="day",
    columns="hour",
    values="orders",
    aggfunc="sum",
    fill_value=0
).reindex(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"])

print(heatmap_df.head())

heatmap_df.to_csv("hourly_volume.csv")