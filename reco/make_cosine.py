import csv
import math

def get_cosine(v1, v2):
    v1 = [int(i) for i in v1]
    v2 = [int(i) for i in v2]

    sumxx, sumxy, sumyy = 0, 0, 0
    
    for i in range(len(v1)):
        x = v1[i]; y = v2[i]
        sumxx += x*x
        sumyy += y*y
        sumxy += x*y
    
    if sumxx == 0 or sumyy == 0: 
        return 0
    else:      
        return sumxy/math.sqrt(sumxx*sumyy)

yo = open("yo.csv", "r")
yo_reader = csv.reader(yo)


df = open("df.csv", "r")
df_reader = csv.reader(df)

hacker_hash = {}

for i in df_reader:
    hacker = i[2]
    if hacker not in hacker_hash:
        hacker_hash[hacker] = {i[1]:i[3]}
    else:
        hacker_hash[hacker][i[1]] = i[3]

yo_arr = {}
for i in yo_reader:

    chal = i[0]
    if chal not in yo_arr:
        yo_arr[chal] = []

        for j in range(1, 137):
            yo_arr[chal].append(i[j])
    else:
        for j in range(1, 137):
            yo_arr[chal][j-1] = str(int(yo_arr[chal][j-1])|int(i[j]))

import pickle

cos_dict = {i:{} for i in yo_arr}

for chal1 in yo_arr:
    for chal2 in yo_arr:

        cos_val = get_cosine(yo_arr[chal1], yo_arr[chal2])
        if cos_val > 0:
            cos_dict[chal1][chal2] = cos_val

with open('cos_dict.pickle', 'wb') as handle:
    pickle.dump(cos_dict, handle)
