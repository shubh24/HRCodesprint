import csv
import math

f = open("recommendation.csv", "w")
writer = csv.writer(f)

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

        for j in range(1, 114):
            yo_arr[chal].append(i[j])
    else:
        for j in range(1, 114):
            yo_arr[chal][j-1] = str(int(yo_arr[chal][j-1])|int(i[j]))

import pickle

with open('cos_dict.pickle', 'rb') as handle:
    cos_dict = pickle.load(handle)

hacker_count = 0

for hacker in hacker_hash:

    hacker_count += 1

    chals = hacker_hash[hacker]
    final = [hacker]
    res = []

    for chal in chals:

        if chal not in yo_arr:
            continue

        if chals[chal] == "0":
            final.append(chal)

        else:

            for j in cos_dict[chal]:
                res.append((j, cos_dict[chal][j]))

    res = sorted(res, key = lambda x: x[1], reverse = True)

    for r in res:
        
        if r[0] not in chals:
            final.append(r[0])

        if len(final) == 11:
            break

    copy_break = len(final)
    while len(final) > 1 and len(final) < 11:
        for i in range(1, copy_break):
            final.append(final[i])

    writer.writerow(final)

f.close()
