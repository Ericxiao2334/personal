#-*- coding:utf-8 -*-

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as sm
from statsmodels.graphics.tsaplots import acf, pacf, plot_acf, plot_pacf
from statsmodels.tsa.arima_model import ARMA, ARIMA
from statsmodels.tsa.stattools import adfuller, acf, pacf


dff = pd.read_csv("/Users/cirean/Desktop/NTU/Kaggle_predict_future_sales/sales_train.csv")
dff = dff.drop(dff[dff.item_cnt_day < 0].index)
print(dff.head())

df=dff.copy()
df['day']=df['date'].apply(lambda x:x[6:]+'-'+x[3:5]+'-'+x[:2])
print(df.head())


df1 = df.groupby(['day'])['item_cnt_day'].sum()
print(df1.head())
print(df1.describe())
df1.plot(figsize=(12, 8),color='b')
plt.show()

#used to test the stationarity of time series, threshold as 5%, p-value as 0.1 in this case
def testStationarity(timeSer):

    stationarity = False

    dftest = adfuller(timeSer)
    dfoutput = pd.Series(dftest[:4], index=[
                      'Test Statistic', 'p-value', 'lags', 'nobs'])

    for key, value in dftest[4].items():
        dfoutput['Critical values (%s)' % key] = value

    if dfoutput['Test Statistic'] < dfoutput['Critical values (5%)']:
        if dfoutput['p-value'] < 0.1:
            stationarity = True

    return stationarity

print(testStationarity(df1))

#no need to use difference any more, the testStationary is already TRUE
#dff1 = df1.diff(1)
#dff1 = dff1.dropna(how=any)
#dff1.plot(figsize=(12, 8))
#plt.show()
#t = sm.tsa.stattools.adfuller(dff)

#print(testStationarity(dff1))

(p, q) =(sm.tsa.arma_order_select_ic(df1, max_ar=4, max_ma=4, ic='aic')['aic_min_order'])
print(p, q)
# automated searching for maximum p and q, use aic as selection criterion.(p,q) = (4,4)

arma_model = sm.tsa.ARMA(df1, (4, 4)).fit(disp=-1, maxiter=100)
predict_data = arma_model.predict(start=0, end=1033, dynamic=False)
print(predict_data)

predict_sale = pd.Series(np.arange(1034))
predict_sale[0] = 1957

for i in range(1, 1034):
    predict_sale[i] = predict_data[i]
print(predict_sale)


plt.plot(predict_sale, color='r', label='predict_sale', linewidth = 0.5)
plt.plot(df1, color='b', label='actual_sale', linewidth = 0.5)
plt.ylabel('sales cnt summation')
plt.xlabel('day')
plt.legend()
plt.show()

def rmse(predictions, targets):
    """
    root-mean-square error
    :param predictions:
    :param targets:
    :return:
    """
    predictions = np.array(predictions)
    targets = np.array(targets)
    return np.sqrt(((predictions - targets) ** 2).mean())


def mse(predictions, targets):
    """
    mean-square error
    :param predictions:
    :param targets:
    :return:
    """
    predictions = np.array(predictions)
    targets = np.array(targets)
    return ((predictions - targets) ** 2).mean()

rmse1 = rmse(predict_sale, df1)
print(rmse1)






# stacking

from sklearn import datasets
from sklearn.ensemble import RandomForestClassifier, ExtraTreesClassifier, GradientBoostingClassifier
from sklearn.cross_validation import train_test_split
from sklearn.cross_validation import StratifiedKFold
import numpy as np
from sklearn.metrics import roc_auc_score
from sklearn.datasets.samples_generator import make_blobs

# dataset
# data, target = make_blobs(n_samples=50000, centers=2, random_state=0, cluster_std=0.60)
dataset = pd.read_csv('/Users/kaggle/predict-future-sales.csv',header=None)
dataset.rename.(columns={8:'label'},inplace=True)
dataset.head(n=5)

# base models
clfs = [RandomForestClassifier(n_estimators=5, n_jobs=-1, criterion='gini'),
        RandomForestClassifier(n_estimators=5, n_jobs=-1, criterion='entropy'),
        ExtraTreesClassifier(n_estimators=5, n_jobs=-1, criterion='gini'),
        ExtraTreesClassifier(n_estimators=5, n_jobs=-1, criterion='entropy'),
        GradientBoostingClassifier(learning_rate=0.05, subsample=0.5, max_depth=6, n_estimators=5)]

# train test split
X, X_predict, y, y_predict = train_test_split(data, target, test_size=0.33, random_state=2017)

dataset_blend_train = np.zeros((X.shape[0], len(clfs)))
dataset_blend_test = np.zeros((X_predict.shape[0], len(clfs)))

# 5-fold stacking
n_folds = 5
skf = list(StratifiedKFold(y, n_folds))
for j, clf in enumerate(clfs):
    # train each model in sequence
    # print(j, clf)
    dataset_blend_test_j = np.zeros((X_predict.shape[0], len(skf)))
    for i, (train, test) in enumerate(skf):
        # 使用第i个部分作为预测，剩余的部分来训练模型，获得其预测的输出作为第i部分的新特征
        # print("Fold", i)
        X_train, y_train, X_test, y_test = X[train], y[train], X[test], y[test]
        clf.fit(X_train, y_train)
        y_submission = clf.predict_proba(X_test)[:, 1]
        dataset_blend_train[test, j] = y_submission
        dataset_blend_test_j[:, i] = clf.predict_proba(X_predict)[:, 1]
    # 对于测试集，直接用这k个模型的预测值均值作为新的特征
    dataset_blend_test[:, j] = dataset_blend_test_j.mean(1)
    print("val auc Score: %f" % roc_auc_score(y_predict, dataset_blend_test[:, j]))

# clf = GradientBoostingClassifier(learning_rate=0.02, subsample=0.5, max_depth=6, n_estimators=30)
clf = LogisticRegression()
clf.fit(dataset_blend_train, y)
y_submission = clf.predict_proba(dataset_blend_test)[:, 1]

print("Linear stretch of predictions to [0,1]")
y_submission = (y_submission - y_submission.min()) / (y_submission.max() - y_submission.min())
print("blend result")
print("val auc Score: %f" % (roc_auc_score(y_predict, y_submission)))