chal = read.csv("challenges.csv", stringsAsFactors = TRUE)
sub = read.csv("submissions.csv", stringsAsFactors = TRUE)

sub$created_at = NULL
sub$language = NULL
agg_sub = aggregate(solved ~ hacker_id + challenge_id + contest_id, data = sub, FUN = max)

df = merge(agg_sub, chal, by = c("contest_id", "challenge_id"), all.x = TRUE)
# df$z = 0
# df$o = 0
# df$t = 0
# df$th = 0
# df$fo = 0
# df$fi = 0
# df$s = 0
# df$se = 0
# df$e = 0
# df$n = 0
# 
# df$z[df$difficulty > 0 & df$difficulty <= 0.1] = 1
# df$o[df$difficulty > 0.1 & df$difficulty <= 0.2] = 1
# df$t[df$difficulty > 0.2 & df$difficulty <= 0.3] = 1
# df$th[df$difficulty > 0.3 & df$difficulty <= 0.4] = 1
# df$fo[df$difficulty > 0.4 & df$difficulty <= 0.5] = 1
# df$fi[df$difficulty > 0.5 & df$difficulty <= 0.6] = 1
# df$s[df$difficulty > 0.6 & df$difficulty <= 0.7] = 1
# df$se[df$difficulty > 0.7 & df$difficulty <= 0.8] = 1
# df$e[df$difficulty > 0.8 & df$difficulty <= 0.9] = 1
# df$n[df$difficulty > 0.9 & df$difficulty <= 1] = 1
#df$percent_solved = df$solved_submission_count/df$total_submissions_count

yo = unique(with(df, data.frame( challenge_id, contest_id,  model.matrix(~domain+subdomain-1, df))))
yo = yo[!yo$domain == 1,]
yo$domain = NULL
yo$contest_id = NULL

write.csv(yo, "yo.csv", row.names = F, col.names = F)
write.csv(df, "df.csv", row.names = F, col.names = FALSE)
