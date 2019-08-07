/ Python utils
wcloud:.p.import[`wordcloud]`:WordCloud
plt:.p.import[`matplotlib.pyplot]

// Target encoding functionality, this function and the following dictionaries
//  are used to encode targets appropriately from disparate datasets

encodetgt:{[x;y]
 cnames:`choose_one_category`typ,`$"Information Type";        // These are the possible target column names
 cgt:(l p:where not{x~`long$()}@/:l:{x y}[x]@/:cnames)0;      // Get relevant targets from table
 loc:{where x}each{sum each x}each{value[y]in x}[;y]each cgt; // What is the relevant target index
 tb :cnames[p]_flip x;                                        // remove the old "target" column from table
 select tweet_text,target from flip tb,(`target,())!enlist raze[key[y]@loc]}  

encodemulti:{dd:(0#`)!();
 select
  not_applicable:(`$"Not applicable";`$"not_related_or_irrelevant"),
  affected_individuals    :(`$"Affected individuals";`$"injured_or_dead_people";
                           `$"missing_trapped_or_found_people";`$"displaced_people_and_evacuations"),
  donations_volunteering  :(`$"Donations and volunteering";`$"donation_needs_or_offers_or_volunteering_services"),
  infrastructure_utilities:(`$"Infrastructure and utilities";`$"infrastructure_and_utilities_damage"),
  sympathy_prayers        :(`$"Sympathy and support";`$"sympathy_and_emotional_support"),
  caution_advice          :(`$"Caution and advice";`$"caution_and_advice"),
  other_useful_info       :(`$"Other Useful Information";`$"other_useful_information"),
  not_labeled             :(`$"";`$"Not labeled")
 from dd}[]

encodebin:{dd:(0#`)!();
 select
  not_applicable:(`$"Not applicable";`$"not_related_or_irrelevant";
                 `$"Sympathy and support";`$"sympathy_and_emotional_support"),
  affected_individuals :(`$"Affected individuals";`$"injured_or_dead_people";
                        `$"missing_trapped_or_found_people";`$"displaced_people_and_evacuations";
                        `$"Donations and volunteering";`$"donation_needs_or_offers_or_volunteering_services";
                        `$"Infrastructure and utilities";`$"infrastructure_and_utilities_damage";
                        `$"Caution and advice";`$"caution_and_advice";
                        `$"Other Useful Information";`$"other_useful_information"),
  not_labeled :(`$"";`$"Not labeled")
 from dd}[]


// Function used to produce a word cloud for the tweet classes
/ x = table, y = target name
args:`background_color`collocations`min_font_size`max_font_size
vals:(`white;0b;10;90)
wordcloudfn:{
 cloud:z[`:generate]raze(?[x;enlist(=;`target;enlist y);();`tweet_text]),'" ";
 plt[`:figure][`figsize pykw (10;20)];
 plt[`:title]["keywords regarding ", string y];
 plt[`:imshow][cloud;`interpolation pykw `bilinear];
 plt[`:axis]["off"];
 plt[`:show][];}[;;wcloud[pykwargs args!vals]]


// Master scoring function for classification metrics used within the Jupyter notebook
/ x = x-test; y = y-test; z = mdl; k = one-hot-encoded targets
class_scoring:{[x;y;z;k]
 p :key[k]raze{where x=max x}each pred:z[`:predict][npa x]`;
 r :key[k]raze where each 1=y;

 -1"\nThe following is the integer mapping between class integer representation and real class value:\n";
 show key[k]!til count k;
 pred :first each idesc each pred;
 class:first each where each 1=y;

 -1"\nActual Class vs prediction\n";
 show 5#res:update Hit:Class=Prediction from([]Class:class;Prediction:pred);
 
 -1"\nDisplaying percentage of Correct prediction vs misses per class:\n";
 tot:select avg Hit by`$string Class from res;
 upd_tot:update Class:`TOTAL from select avg Hit from res;
 show update Miss:1-Hit from tot upsert upd_tot;
 
 -1"\nDisplaying predicted vs actual class assignment matrix:\n";
 cpnum:select num:count i by Class,Prediction from res;
 ctab :update pcnt:100*num%sum num by Class from cpnum;
 cpred:flip cross[exec distinct Class from ctab;exec distinct Prediction from ctab]; 
 ctab :0^(asc flip`Class`Prediction!cpred)#ctab;
 ctab :0!update p:{`$"Pred_",string x}each Prediction from ctab;
 show exec(p!num)by Class:Class from ctab;

 -1"\nClassification report showing precision, recall and f1-score for each class:\n";
 .ml.classreport[p;r]
 }


// Rename columns appropriately
rename:{xcol[y;x]}
names:`tweet_id`tweet_text`source`typ`informativeness


// Remove specific aspects of the text of the tweets
rmv_ascii  :{x where x within (0;127)}
rmv_custom :{rtrim raze(l where{not(max ,'/)x like/:y}[;y]each l:" "vs x),'" "}
rmv_master :{{x:ssr[x;y;z];x}[;;z]/[x;y]}
