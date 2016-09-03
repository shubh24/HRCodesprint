chal = read.csv("challenges.csv", stringsAsFactors = TRUE)
sub = read.csv("submissions.csv", stringsAsFactors = TRUE)

cf_vec = unique(with(sub, data.frame(hacker_id, model.matrix(~contest_id+language-1, sub))))
cf_vec = aggregate(.~hacker_id, cf_vec, FUN = max)
write.table(cf_vec, "cf_vec.csv", sep = ",", row.names = F, col.names = FALSE)

sub$created_at = NULL
sub$language = NULL
agg_sub = aggregate(solved ~ hacker_id + challenge_id + contest_id, data = sub, FUN = max)

df = merge(agg_sub, chal, by = c("contest_id", "challenge_id"), all.x = TRUE)

df$z = 0
df$o = 0
df$t = 0
df$th = 0
df$fo = 0
df$fi = 0
df$s = 0
df$se = 0
df$e = 0
df$n = 0
df$z[df$difficulty > 0 & df$difficulty <= 0.1] = 1
df$o[df$difficulty > 0.1 & df$difficulty <= 0.2] = 1
df$t[df$difficulty > 0.2 & df$difficulty <= 0.3] = 1
df$th[df$difficulty > 0.3 & df$difficulty <= 0.4] = 1
df$fo[df$difficulty > 0.4 & df$difficulty <= 0.5] = 1
df$fi[df$difficulty > 0.5 & df$difficulty <= 0.6] = 1
df$s[df$difficulty > 0.6 & df$difficulty <= 0.7] = 1
df$se[df$difficulty > 0.7 & df$difficulty <= 0.8] = 1
df$e[df$difficulty > 0.8 & df$difficulty <= 0.9] = 1
df$n[df$difficulty > 0.9 & df$difficulty <= 1] = 1

df$tot_z = 0
df$tot_o = 0
df$tot_t = 0
df$tot_th = 0
df$tot_fo = 0
df$tot_fi = 0
df$tot_s = 0
df$tot_se = 0
df$tot_z[df$total_submissions_count == 0] = 1
df$tot_o[df$total_submissions_count > 0 &df$total_submissions_count <= 1000] = 1
df$tot_t[df$total_submissions_count > 1000 &df$total_submissions_count <= 2000] = 1
df$tot_th[df$total_submissions_count > 2000 &df$total_submissions_count <= 3000] = 1
df$tot_fo[df$total_submissions_count > 3000 &df$total_submissions_count <= 4000] = 1
df$tot_fi[df$total_submissions_count > 4000 &df$total_submissions_count <= 5000] = 1
df$tot_s[df$total_submissions_count > 5000 &df$total_submissions_count <= 6000] = 1
df$tot_se[df$total_submissions_count > 6000 &df$total_submissions_count <= 7000] = 1

df$sol_z = 0
df$sol_o = 0
df$sol_t = 0
df$sol_th = 0
df$sol_f = 0
df$sol_z[df$solved_submission_count == 0] = 1
df$sol_o[df$solved_submission_count > 0 &df$solved_submission_count <= 1000] = 1
df$sol_t[df$solved_submission_count > 1000 &df$solved_submission_count <= 2000] = 1
df$sol_th[df$solved_submission_count > 2000 &df$solved_submission_count <= 3000] = 1
df$sol_f[df$solved_submission_count > 3000] = 1

#df$percent_solved = df$solved_submission_count/df$total_submissions_count

yo = unique(with(df, data.frame( challenge_id, contest_id, z, o, t, th, fo, fi, s, se, e, n, tot_z, tot_o, tot_t,tot_th,tot_fo,tot_fi,tot_s,tot_se, sol_z, sol_o, sol_t, sol_th,sol_f,model.matrix(~domain+subdomain-1, df))))
yo = yo[!yo$domain == 1,]
yo$domain = NULL
yo$contest_id = NULL

write.table(yo, "yo.csv", sep = ",", row.names = F, col.names = FALSE)
write.table(df, "df.csv", sep = ",", row.names = F, col.names = FALSE)


