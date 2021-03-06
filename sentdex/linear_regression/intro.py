# Exercises on Machine Learning
# Using quandl stock data to predict stocks into the future

import pandas as pd
import quandl
import math
import datetime
import numpy as np
from sklearn import preprocessing, cross_validation, svm
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from matplotlib import style
import pickle

style.use('ggplot')

df = quandl.get('WIKI/GOOGL')
df = df[['Adj. Open', 'Adj. High', 'Adj. Low', 'Adj. Close', 'Adj. Volume']]
# get the percentage diff between the high and low for the day
df['HL_PCT'] = (df['Adj. High'] - df['Adj. Low']) / df['Adj. Low'] * 100.0
# get the percentage between the open and close of the day
df['PCT_CHANGE'] = (df['Adj. Close'] - df['Adj. Open']) / df['Adj. Open'] * 100.0

df = df[['Adj. Close', 'HL_PCT', 'PCT_CHANGE', 'Adj. Volume']]
# lets predict the price at close of day in the future
forecast_col = 'Adj. Close'
df.fillna(-99999, inplace=True)

forecast_out = int(math.ceil(0.1*len(df)))
print('Number of Days in Advance: ' + str(forecast_out))

# shift the data by a certain number of days in order to build predictions
# so the next days stock price (adj close) becomes the prediction for that day
df['label'] = df[forecast_col].shift(-forecast_out)


X = np.array(df.drop(['label'], 1))
X = preprocessing.scale(X)
X_lately = X[-forecast_out:]
X = X[:-forecast_out]

df.dropna(inplace=True)
y = np.array(df['label'])
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y, test_size = 0.2)

# use linear regression
# sklearn.linear_model.LinearRegression
clf = LinearRegression(n_jobs=-1)
clf.fit(X_train, y_train)

# save your classifier model for future use
with open('linearregression', 'wb') as f:
    pickle.dump(clf, f)

# opening the classifier and deserializing from file
pickle_in = open('linearregression', 'rb')
clf = pickle.load(pickle_in)

accuracy = clf.score(X_test, y_test)

forecast_set = clf.predict(X_lately);

print (forecast_set, accuracy, forecast_out)

df['Forecast'] = np.nan

# create dates from graph
last_date = df.iloc[-1].name
last_unix = last_date.timestamp()
one_day = 86400
next_unix = last_unix + one_day

for i in forecast_set:
    next_date = datetime.datetime.fromtimestamp(next_unix)
    next_unix += one_day
    df.loc[next_date] = [np.nan for _ in range(len(df.columns)-1)] + [i]

df['Adj. Close'].plot()
df['Forecast'].plot()
plt.legend(loc=4)
plt.xlabel('Date')
plt.ylabel('Price')
plt.show()
