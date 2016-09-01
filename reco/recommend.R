chal = read.csv("challenges.csv", stringsAsFactors = TRUE)
sub = read.csv("submissions.csv", stringsAsFactors = TRUE)

sub$created_at = NULL
sub$language = NULL
sub$contest_id = NULL

agg_sub = aggregate(solved ~ hacker_id + challenge_id, data = sub, FUN = length)
names(agg_sub)[names(agg_sub) == "solved"] = "count"

write.csv(agg_sub, "cf.csv", row.names = F, col.names = F)
