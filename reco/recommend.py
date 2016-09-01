from recsys.algorithm.factorize import SVD
from recsys.datamodel.data import Data
import csv

data = Data()
data.load("cf.csv", sep=',', format={'col':0, 'row':1, 'value':2, 'ids':str})

K=100
svd = SVD()
svd.set_data(data)
svd.compute(k=K, min_values=10, pre_normalize=None, mean_center=True, post_normalize=True)

cf = open("cf.csv", "r")
reader = csv.reader(cf)

f = open("recommendation.csv", "w")
writer = csv.writer(f)

c = 0
hackers = []

for i in reader:
	hacker = i[0]
	hackers.append(hacker)

hackers = list(set(hackers))

for hacker in hackers:

	try:
		preds = svd.recommend(hacker, is_row = False)

		line = [hacker]
		for p in preds:
			line.append(p[0])

		writer.writerow(line)
		c+=1
	except:
		pass

cf.close()
f.close()
