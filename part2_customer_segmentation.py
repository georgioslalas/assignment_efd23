# -*- coding: utf-8 -*-
"""
Created on Sat Feb 18 20:30:08 2023

@author: G. Lalas for the efood Insights Analyst Assignment FEB23
"""

# Import libraries
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

# Read the CSV
df = pd.read_csv(r'C:\Users\user\Desktop\efood Insights Analyst FEB23\Assessment exercise dataset - orders.csv', sep=',', encoding='utf-8')

# Get a glimpse through a sample
sample = df.head(1000)

# Group by user_id to get average order amount and frequency of orders per user 
df_per_user = df.groupby('user_id').agg({'amount': 'mean', 'order_id': 'count'}).reset_index()

# Plot the data
x = df_per_user['order_id']
y = df_per_user['amount']

plt.scatter(x, y)
plt.show() 

# Get rid of the "outliers"
df_per_user_v2 = df_per_user[(df_per_user['amount'] < 50) | (df_per_user['user_id'] < 40)]
x = df_per_user_v2['order_id']
y = df_per_user_v2['amount']

# We will use the k-means clustering algorithm

# First step: Determine the optimal number of clusters
data = list(zip(x, y))
inertias = []

for i in range(1,11):
    kmeans = KMeans(n_clusters=i)
    kmeans.fit(data)
    inertias.append(kmeans.inertia_)

plt.clf()
plt.plot(range(1,11), inertias, marker='o')
plt.xlabel('No of clusters')
plt.ylabel('Inertia')
plt.show() 


# 5 clusters
kmeans = KMeans(n_clusters=5)
kmeans.fit(data)

plt.clf()
plt.scatter(x, y, c=kmeans.labels_)
plt.show()

# Repeat for 4 clusters
kmeans = KMeans(n_clusters=4)
kmeans.fit(data)

plt.clf()
plt.scatter(x, y, c=kmeans.labels_)
plt.show() 

