import pandas as pd

df = pd.read_csv("./BrazilianECommerceProject/olist_orders_dataset.csv")
print(df.head())
print(df.info())
print(df.shape)