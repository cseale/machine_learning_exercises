# Exercises on Machine Learning
# Using quandl stock data to predict stocks into the future

import pandas as pd
import quandl
import math
import numpy as np
from sklearn import preprocessing, cross_validation, svm
from sklearn.linear_model import LinearRegression

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

forecast_out = int(math.ceil(0.01*len(df)))
print('Number of Days in Advance: ' + str(forecast_out))

# shift the data by a certain number of days in order to build predictions
# so the next days stock price (adj close) becomes the prediction for that day
df['label'] = df[forecast_col].shift(-forecast_out)
df.dropna(inplace=True)

X = np.array(df.drop(['label'], 1))
y = np.array(df['label'])

X = preprocessing.scale(X)
y = np.array(df['label'])

X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y, test_size = 0.2)

# use linear regression
# sklearn.linear_model.LinearRegression
clf = LinearRegression()
clf.fit(X_train, y_train)
accuracy = clf.score(X_test, y_test)

print('Accuracy of LinearRegression Classifier: ' + str(accuracy))


# use support vector machine
# uses different kernals
clf2 = svm.SVR()
clf2.fit(X_train, y_train)
accuracy2 = clf2.score(X_test, y_test)

print('Accuracy of SVM Classifier: ' + str(accuracy2))
