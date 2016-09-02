import csv

yo = open("yo.csv", "r")
yo_reader = csv.reader(yo)

select = open("select.csv", "r")
select_reader = csv.reader(select)

df = open("df.csv", "r")
df_reader = csv.reader(df)

hacker_hash = {}

for i in df_reader:
	hacker = i[2]
	if hacker not in hacker_hash:
		hacker_hash[hacker] = {i[1]:i[3]}
	else:
		hacker_hash[hacker][i[1]] = i[3]

select_arr = {}
for i in select_reader:
	chal = i[0]
	select_arr[chal] = []

	for j in range(1, 114):
		select_arr[chal].append(i[j])

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

print len(yo_arr)