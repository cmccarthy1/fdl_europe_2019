\l nlp/init.q
\l ml/ml.q
.ml.loadfile`:init.q

\l ../code/fdl_disasters.q
\l mdls/token_load.p

// open connection to tick process
h:neg hopen`:localhost:5140

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

// get correct classication targets from saved down datasets.
targets:`$1_ last each corpus
ohe:.ml.i.onehot1 targets
classes:key[ohe]

tweets:neg[count t]?t:1_ first each corpus            // shuffle tweets

// Load required models and tokenizer for use in live system
load_token:.p.get[`load_pickle];
tokenizer:load_token[];
svd_mdl:.p.import[`keras.models][`:load_model]["mdls/multiclass_mdl.h5"];

// Classes
c:`affected_individuals`caution_advice`donations_volunteering`sympathy_prayers
c,:`other_useful_info`infrastructure_utilities`useless_info
// Create a dictionary showing rolling number of tweets per class
processed_data:c!count[c]#0

// Function to update the appropriate tables on the tickerplant
// update the number of values classified in each class
upd_vals:{(h(".u.upd";x;y);processed_data[x]+:1)}

// Function for live data streaming example
.z.ts:{
 if[(0=n mod 50)and n>1;
    -1"\nThe following are the number of tweets in each class for ",string[n]," processed tweets";
    show processed_data];
 clean_tweet:(rmv_ascii rmv_custom[;rmv_list] rmv_hashtag rmv_single@) tweets[n];
 X:pad[tokenizer[`:texts_to_sequences]enlist clean_tweet;`maxlen pykw 50];
 pred:key[ohe]raze{where x=max x}(svd_mdl[`:predict][X]`)0;
 pkg:(.z.N;pred[0];clean_tweet);
 upd_vals[;pkg] c(count[c]-1)&c?first pred;
 n+:1;}
