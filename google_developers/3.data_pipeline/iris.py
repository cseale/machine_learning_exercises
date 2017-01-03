#import dataset
from sklearn import datasets
iris = datasets.load_iris()

X = iris.data
y = iris.target

# set up test and training data for cross_validation
from sklearn.cross_validation import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.5)

# train classifier
from sklearn import tree
clf = tree.DecisionTreeClassifier() # or KNeighborsClassifier
clf.fit(X_train, y_train)

# predict
predictions = clf.predict(X_test)

# how accurate was the predictions
from sklearn.metrics import accuracy_score
print accuracy_score(y_test, predictions)
