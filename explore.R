train = read.csv("training_dataset.csv", stringsAsFactors = TRUE)
test = read.csv("test_dataset.csv", stringsAsFactors = TRUE)

train$train = 1
test$train = 0

#train$unsubscribe_time[is.na(train$unsubscribe_time)] = -1
#train$opened = as.numeric(train$opened) - 1

test$click_time = -1
test$clicked = "false"
test$open_time = -1
test$opened = "false"
test$unsubscribe_time = -1
test$unsubscribed = "false"

df = rbind(train, test)

#agg_df = aggregate(opened ~ user_id, data = df, FUN = mean)
#names(agg_df)[names(agg_df) == "opened"] = "avg_opened"
#df = merge(df, agg_df, by = "user_id", all.x = TRUE)

#df$opened[df$opened == 1] = "true"
#df$opened[df$opened == 0] = "false"
#df$opened = as.factor(df$opened)


#Played a lot with unsubscribe time -- not fruitful, removing gives higher accuracy!
#agg_df = aggregate(unsubscribed ~ user_id, data = df, FUN = function(x) length(unique(x)))
#agg_df$unsubscribed[agg_df$unsubscribed == 1] = "false"
#agg_df$unsubscribed[agg_df$unsubscribed == 2] = "true"
#agg_df$unsubscribed = as.factor(agg_df$unsubscribed)
#df = merge(df, agg_df, by = "user_id", all.x = TRUE)
#df$unsubscribed.x = NULL
#names(df)[names(df) == "unsubscribed.y"] = "unsubscribed"
#agg_df = aggregate(unsubscribe_time ~ user_id, data = df, FUN = function(x) max(x))
#df = merge(df, agg_df, by = "user_id", all.x = TRUE)
#df$unsubscribe_time.x = NULL
#names(df)[names(df) == "unsubscribe_time.y"] = "unsubscribe_time"

#removing the time offsets gives higher score!
#df$time_since_creation = df$sent_time - df$hacker_created_at
#df$time_since_online = df$sent_time - df$last_online

#df$time_since_unsubscribe[df$unsubscribe_time > 0] = df$sent_time[df$unsubscribe_time > 0] - df$unsubscribe_time[df$unsubscribe_time > 0]
#df$time_since_unsubscribe[df$unsubscribe_time <= 0] = -1 #doubtful -- figure out!

#Removing all time-related factors
df$sent_time = NULL
df$open_time = NULL
df$click_time = NULL
df$unsubscribe_time = NULL
df$hacker_timezone = NULL
df$hacker_created_at = NULL
df$last_online = NULL

df$ipn_ratio = df$ipn_read/df$ipn_count
df$do_ratio = df$contest_login_count/df$contest_participation_count

df$submissions_count = NULL #sub-parts are already present

#Making all NULL, as.factor didn't work. Removing giving higher accuracy!
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

train = subset(df, df$train == 1)
test = subset(df, df$train == 0)

train$train = NULL
test$train = NULL
test$opened = NULL

install.packages("h2o")
library(h2o)
h2o.init(nthreads = -1)

write.table(train, gzfile('./transformed_train.csv.gz'),quote=F,sep=',',row.names=F)
write.table(test, gzfile('./transformed_test.csv.gz'),quote=F,sep=',',row.names=F)

train.hex <- h2o.uploadFile('./transformed_train.csv.gz', destination_frame='hr_train')
test.hex <- h2o.uploadFile('./transformed_test.csv.gz', destination_frame='hr_test')

feature.names = names(train)
feature.names <- feature.names[! feature.names %in% c('user_id', 'opened', 'clicked', 'unsubscribed')]

#rf = h2o.randomForest(x = feature.names, y = 'opened', training_frame = train.hex, ntrees = 50, max_depth = 20, nfolds = 10)
#rf = h2o.randomForest(x = feature.names, y = 'opened', training_frame = train.hex, ntrees = 50, max_depth = 20)
#preds = as.data.frame(h2o.predict(rf, test.hex))
                    
#write.table(as.vector(as.numeric(preds$predict) - 1), './h2o_rf_5.csv',quote=F,sep=',',row.names=F, col.names = F)

#Trying neural nets and ensemble with RF -- lower than RF
nnet = h2o.deeplearning(x = feature.names, y = "opened", training_frame = train.hex)
preds_dl = as.data.frame(h2o.predict(nnet, test.hex))

write.table(as.vector(as.numeric(preds_dl$predict) - 1), './h2o_rf_6.csv',quote=F,sep=',',row.names=F, col.names = F)

#preds_ens = bitwAnd(as.vector(as.numeric(preds$predict) - 1), as.vector(as.numeric(preds_dl$predict) - 1))
#write.table(as.vector(as.numeric(preds_dl$predict) - 1), './h2o_rf_5.csv',quote=F,sep=',',row.names=F, col.names = F)
#write.table(as.vector(preds_ens), './h2o_rf_5.csv',quote=F,sep=',',row.names=F, col.names = F)


