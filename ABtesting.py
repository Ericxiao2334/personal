from scipy import stats	
import numpy as np	
import seaborn as sns	
 
# 独立双样本t检验	
A = np.array([ 1, 4, 2, 3, 5, 5, 5, 7, 8, 9,10,18])	
B = np.array([ 1, 2, 5, 6, 8, 10, 13, 14, 17, 20,13,8])	
print('策略A的均值是：',np.mean(A))	
print('策略B的均值是：',np.mean(B))

output = stats.ttest_ind(B,A,equal_var= False)
print(output)



