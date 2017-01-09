# Exercises on Machine Learning
# Using quandl stock data to predict stocks into the future

import pandas as pd
import quandl
import math

df = quandl.get('WIKI/GOOGL')
df = df[['Adj. Open', 'Adj. High', 'Adj. Low', 'Adj. Close', 'Adj. Volume']]

df['HL_PCT'] = (df['Adj. High'] - df['Adj. Low']) / df['Adj. Low'] * 100.0
df['PCT_CHANGE'] = (df['Adj. Close'] - df['Adj. Open']) / df['Adj. Open'] * 100.0

df = df[['Adj. Close', 'HL_PCT', 'PCT_CHANGE', 'Adj. Volume']]

forecast_col = 'Adj. Close'
df.fillna(-99999, inplace=True)

forecast_out = int(math.ceil(0.01*len(df)))

# shift the data by a certain number of days in order to build predictions
# so the next days stock price (adj close) becomes the prediction for that day
df['label'] = df[forecast_col].shift(-forecast_out)
df.dropna(inplace=True)
print(df.head())

# tbc on part 4: https://www.youtube.com/watch?v=r4mwkS2T9aI&index=4&list=PLQVvvaa0QuDfKTOs3Keq_kaG2P55YRn5v
