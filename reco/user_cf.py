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
    print len(inv_cf_arr[val])