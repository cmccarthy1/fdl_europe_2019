h:neg hopen`:localhost:5000

\l nlp/init.q
\l ml/ml.q
.ml.loadfile`:init.q

\l ../code/fdl_disasters.q
\l token_load.p

// Python functionality
pad:.p.import[`keras.preprocessing.sequence]`:pad_sequences

// initialized to allow 'iteration through tweets'
n:0

// set up information for removal of regex from tables
rmv_list   :("http*";"rt";"@*";"*,";"*&*";"*[0-9]*")
rmv_single :rmv_master[;",.:?!/_@'";""]
rmv_hashtag:rmv_master[;"#";""]

tweet_corpus:read0`$":../notebook/tweets.txt"         // load tweets
corpus:{"\t" vs x} each tweet_corpus

targets:`$1_ last each corpus
ohe:.ml.i.onehot1 targets
classes:key[ohe]

tweets:neg[count t]?t:1_ first each corpus            // shuffle tweets

load_token:.p.get[`load_pickle];
tokenizer:load_token[];
svd_mdl:.p.import[`keras.models][`:load_model]["multiclass_mdl.h5"];

processed_data:{dd:(0#`)!();
 select
  affected_individuals:0,
  caution_advice:0,
  donations_volunteering:0,
  sympathy_prayers:0,
  other_useful_info:0,
  infrastructure_utilities:0,
  useless_info:0
 from dd}[]

upd_vals:{(h(".u.upd";x;y);processed_data[x]+:1)}

.z.ts:{
 if[(0=n mod 20)and n>1;
    -1"\nThe following are the number of tweets in each class:";show processed_data;];
 clean_tweet:(rmv_ascii rmv_custom[;rmv_list] rmv_hashtag rmv_single@)tweets[n];
 X:pad[tokenizer[`:texts_to_sequences]enlist clean_tweet;`maxlen pykw 50];
 pred:key[ohe]raze{where x=max x}(svd_mdl[`:predict][X]`)0;
 pkg:(.z.N;clean_tweet);
 $[pred[0]=`affected_individuals;
   upd_vals[`affected_individuals;pkg];
   pred[0]=`caution_advice;
   upd_vals[`caution_advice;pkg];
   pred[0]=`donations_volunteering;
   upd_vals[`donations_volunteering;pkg];
   pred[0]=`sympathy_prayers;
   upd_vals[`sympathy_prayers;pkg];
   pred[0]=`other_useful_info;
   upd_vals[`other_useful_info;pkg];
   pred[0]=`infrastructure_utilities;
   upd_vals[`infrastructure_utilities;pkg];
   upd_vals[`useless_info;pkg]]
 n+:1;}
