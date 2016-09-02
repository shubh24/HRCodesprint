chal = read.csv("challenges.csv", stringsAsFactors = TRUE)
sub = read.csv("submissions.csv", stringsAsFactors = TRUE)

sub$created_at = NULL
sub$language = NULL
agg_sub = aggregate(solved ~ hacker_id + challenge_id + contest_id, data = sub, FUN = max)

df = merge(agg_sub, chal, by = c("contest_id", "challenge_id"), all.x = TRUE)

#df$solved = as.factor(df$solved)
#df$percent_solved = df$solved_submission_count/df$total_submissions_count

yo = unique(with(df, data.frame( challenge_id, contest_id, model.matrix(~domain+subdomain-1, df))))
yo$domain = NULL

select = subset(yo, yo$contest_id == "c8ff662c97d345d2")
select$contest_id = NULL
yo$contest_id = NULL

#PLAN
#If challenge in hacker's profile, but not solved, and it exists in select ==> put it in!
#Go through all challenges in hacker's profile ==> cos against select data frame ==> if greater than 0, put it in! (check he hasn't solved it)

write.csv(yo, "yo.csv", row.names = F)
write.csv(select, "select.csv", row.names = F)
write.csv(df, "df.csv", row.names = F)
