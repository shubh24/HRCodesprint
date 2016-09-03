import csv

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

for i in cf_arr:
    loc = cf_arr[i]
    val = ("").join(loc)
    similar_hackers = inv_cf_arr[val]

    selected_chals = {}

    for similar_hacker in similar_hackers:
        
        chals = hacker_hash[similar_hacker]
        my_chals = hacker_hash[i]

        for c in chals:
            if c in my_chals or c not in yo_arr:
                continue

            else:
                if c not in selected_chals:
                    selected_chals[c] = 1
                else:
                    selected_chals[c] += 1

    selected_chals = sorted(selected_chals, key = lambda x: selected_chals[x], reverse = True)

    