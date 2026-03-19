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



