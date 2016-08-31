train = read.csv("training_dataset.csv", stringsAsFactors = TRUE)
test = read.csv("test_dataset.csv", stringsAsFactors = TRUE)

train$train = 1
test$train = 0

train$unsubscribe_time[is.na(train$unsubscribe_time)] = -1

test$click_time = -1
test$clicked = "false"
test$open_time = -1
test$opened = "false"
test$unsubscribe_time = -1
test$unsubscribed = "false"

df = rbind(train, test)
agg_df = aggregate(unsubscribed ~ user_id, data = df, FUN = function(x) length(unique(x)))
agg_df$unsubscribed[agg_df$unsubscribed == 1] = "false"
agg_df$unsubscribed[agg_df$unsubscribed == 2] = "true"
agg_df$unsubscribed = as.factor(agg_df$unsubscribed)
df = merge(df, agg_df, by = "user_id", all.x = TRUE)
df$unsubscribed.x = NULL
names(df)[names(df) == "unsubscribed.y"] = "unsubscribed"

agg_df = aggregate(unsubscribe_time ~ user_id, data = df, FUN = function(x) max(x))
df = merge(df, agg_df, by = "user_id", all.x = TRUE)
df$unsubscribe_time.x = NULL
names(df)[names(df) == "unsubscribe_time.y"] = "unsubscribe_time"

df$time_since_creation = df$sent_time - df$hacker_created_at
df$time_since_online = df$sent_time - df$last_online

df$time_since_unsubscribe[df$unsubscribe_time > 0] = df$sent_time[df$unsubscribe_time > 0] - df$unsubscribe_time[df$unsubscribe_time > 0]
df$time_since_unsubscribe[df$unsubscribe_time <= 0] = -1 #doubtful -- figure out!

#Removing all time-related factors
df$sent_time = NULL
df$open_time = NULL
df$click_time = NULL
df$unsubscribe_time = NULL
df$hacker_timezone = NULL
df$hacker_created_at = NULL
df$last_online = NULL

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
feature.names <- feature.names[! feature.names %in% c('user_id', 'mail_id', 'opened', 'clicked', 'unsubscribed')]

#rf = h2o.randomForest(x = feature.names, y = 'opened', training_frame = train.hex, ntrees = 50, max_depth = 20, nfolds = 10)
rf = h2o.randomForest(x = feature.names, y = 'opened', training_frame = train.hex, ntrees = 50, max_depth = 20)
preds = h2o.predict(rf, test.hex)

preds = as.data.frame(preds)$predict
write.table(as.vector(as.numeric(preds) - 1), './h2o_rf_3.csv',quote=F,sep=',',row.names=F, col.names = F)