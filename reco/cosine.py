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

cf = open("cf_vec.csv", "r")
cf_reader = csv.reader(cf)

cf_arr = {}
inv_cf_arr = {}

for i in cf_reader:

    hacker = i[0]
    
    cf_arr[hacker] = i[1:301]

    val = ("").join(i[1:301])
    if val not in inv_cf_arr:
        inv_cf_arr[val] = [hacker]

    else:
        inv_cf_arr[val].append(hacker)

import pickle

with open('cos_dict.pickle', 'rb') as handle:
    cos_dict = pickle.load(handle)

hacker_count = 0
for hacker in hacker_hash:
    print hacker_count
    hacker_count += 1
    #Content-based here!    
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

    #Collabarative starts here!
    local_arr = cf_arr[hacker]
    val = ("").join(local_arr)
    similar_hackers = inv_cf_arr[val]

    selected_chals = {}

    for similar_hacker in similar_hackers:
        
        similar_chals = hacker_hash[similar_hacker]

        for c in similar_chals:
            if c in chals or c not in yo_arr:
                continue

            else:
                if c not in selected_chals:
                    selected_chals[c] = 1
                else:
                    selected_chals[c] += 1

    selected_chals = sorted(selected_chals, key = lambda x: selected_chals[x], reverse = True)

    for sc in selected_chals:
        if sc not in final:
            final.append(sc)

        if len(final) == 4:
            break

    if len(final) < 11:
        for r in res:
            if r[0] not in chals and r[0] not in final:
                final.append(r[0])

            if len(final) == 11:
                break

    if len(final) < 11:
        for sc in selected_chals:
            if sc not in final:
                final.append(sc)

            if len(final) == 11:
                break

    writer.writerow(final)

f.close()
