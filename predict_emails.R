train = read.csv("training_dataset.csv", stringsAsFactors = TRUE)
test = read.csv("test_dataset.csv", stringsAsFactors = TRUE)

train$train = 1
test$train = 0
test$opened = 0

train$open_time = NULL
train$click_time = NULL
train$unsubscribe_time = NULL
train$unsubscribed = NULL
train$clicked = NULL

df = rbind(train, test)
df$sent_time = NULL
df$last_online = NULL
df$hacker_timezone = NULL
df$hacker_created_at = NULL
df$hacker_confirmation = NULL
 
# df$active_1_days = as.factor(df$contest_login_count_1_days + df$contest_participation_count_1_days + df$ipn_read_1_days + df$submissions_count_1_days + df$submissions_count_contest_1_days + df$submissions_count_master_1_days > 0)
# df$active_7_days = as.factor(df$contest_login_count_7_days + df$contest_participation_count_7_days + df$ipn_read_7_days + df$submissions_count_7_days + df$submissions_count_contest_7_days + df$submissions_count_master_7_days > 0)
# df$active_30_days = as.factor(df$contest_login_count_30_days + df$contest_participation_count_30_days + df$ipn_read_30_days + df$submissions_count_30_days + df$submissions_count_contest_30_days + df$submissions_count_master_30_days > 0)
# df$active_365_days = as.factor(df$contest_login_count_365_days + df$contest_participation_count_365_days + df$ipn_read_365_days + df$submissions_count_365_days + df$submissions_count_contest_365_days + df$submissions_count_master_365_days > 0)

df$contest_participation_count_1_days = NULL 
df$contest_participation_count_7_days = NULL 
df$contest_participation_count_30_days = NULL 
df$contest_participation_count_365_days = NULL 

df$submissions_count_1_days = NULL
df$submissions_count_7_days = NULL 
df$submissions_count_30_days = NULL 
df$submissions_count_365_days = NULL

df$submissions_count_contest_1_days = NULL 
df$submissions_count_contest_7_days = NULL 
df$submissions_count_contest_30_days = NULL 
df$submissions_count_contest_365_days = NULL 

df$submissions_count_master_1_days = NULL 
df$submissions_count_master_7_days = NULL 
df$submissions_count_master_30_days = NULL 
df$submissions_count_master_365_days = NULL 

df$ipn_count_1_days = NULL 
df$ipn_count_7_days = NULL 
df$ipn_count_30_days = NULL 
df$ipn_count_365_days = NULL 

df$ipn_read_1_days = NULL 
df$ipn_read_7_days = NULL 
df$ipn_read_30_days = NULL 
df$ipn_read_365_days = NULL 

df$contest_login_count_1_days = NULL 
df$contest_login_count_7_days = NULL 
df$contest_login_count_30_days = NULL 
df$contest_login_count_365_days = NULL

# df$ipn_ratio = df$ipn_read/df$ipn_count
# df$do_ratio = df$contest_login_count/df$contest_participation_count

df$ipn_read = NULL
df$ipn_count = NULL
df$contest_login_count = NULL
df$contest_participation_count = NULL
df$submissions_count = NULL
df$forum_count = NULL
df$submissions_count_master = NULL
df$submissions_count_contest = NULL
df$forum_expert_count = NULL
df$forum_comments_count = NULL
df$forum_questions_count = NULL

train_mod = subset(df, df$train == 1)
test_mod = subset(df, df$train == 0)
train_mod$train = NULL
test_mod$train = NULL

# train_mod = unique(with(train_mod, data.frame(user_id, opened, model.matrix(~mail_id+mail_category+mail_type-1, train_mod))))
# test_mod = unique(with(test_mod, data.frame(user_id, model.matrix(~mail_id+mail_category+mail_type-1, test_mod))))
# 
# write.table(train_mod, "train_mod.csv", sep = ",", row.names = F, col.names = F)
# write.table(test_mod, "test_mod.csv", sep = ",", row.names = F, col.names = F)

# df$forum_expert_count = as.factor(df$forum_expert_count > 0)
# df$forum_comments_count = as.factor(df$forum_comments_count > 0)
# df$forum_questions_count = as.factor(df$forum_questions_count > 0)

library(h2o)
h2o.init(nthreads = -1)


feature.names = names(train_mod)
feature.names <- feature.names[! feature.names %in% c('user_id', 'opened')]

write.table(train_mod, gzfile('./transformed_train.csv.gz'),quote=F,sep=',',row.names=F)
write.table(test_mod, gzfile('./transformed_test.csv.gz'),quote=F,sep=',',row.names=F)

train.hex <- h2o.uploadFile('./transformed_train.csv.gz', destination_frame='hr_train')
test.hex <- h2o.uploadFile('./transformed_test.csv.gz', destination_frame='hr_test')

nnet = h2o.deeplearning(x = feature.names, y = "opened", training_frame = train.hex)
preds_dl = as.data.frame(h2o.predict(nnet, test.hex))

write.table(as.vector(as.numeric(preds_dl$predict) - 1), './h2o_rf_6.csv',quote=F,sep=',',row.names=F, col.names = F)
