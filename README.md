# FDL Europe 2019, Disaster Prevention, Progress and Response(Floods)

This repository contains code relating to the application of machine learning to tweet classifications relating to disaster management. This work primarily concerns the application of LSTM artificial recurrent neural networks to data from the [Crisis NLP](https://crisisnlp.qcri.org/) dataset.


This work is broken into two sections:

1. The loading/analysis of the Crisis NLP dataset in kdb+ and the production/testing of an LSTM model to both complete binary and multi-class classification of the tweets
2. The creation of a template for the 'live' classification of tweets using the model created in objective 1 which can be used as a base framework for similar work in Natural Language processing within the a kdb+ architecture

## Requirements

The python packages needed to run the examples within the code presented here can be installed using either of the following commands

pip:

```
>pip install -r requirements.txt
```

or via conda:

```
> conda install --file requirements.txt
```

In addition to this both [EmbedPy](https://github.com/kxsystems/embedpy) and [JupyterQ](https://github.com/kxsystems/jupyterq) are required. The Kx [NLP](https://github.com/kxsystems/nlp) and Kx [ML toolkit](https://github.com/kxsystems/ml) libraries should also be installed in `$QHOME`

## Code

The code in this white paper is split into two distinct sections and should be run as follow;

1.  The jupyter notebook should be run in order to ensure all variables are correctly populated.

2.  The 'live' system should be run as follows

```
// tickerplant process
$ q tick.q -p 5000
q)

// Feedhandler process
$ q feed.q
/ Publish tweets every 100ms to each of the tables
q)\t 100
The following are the number of tweets in each class for 50 processed tweets
affected_individuals    | 23
caution_advice          | 2
donations_volunteering  | 8
sympathy_prayers        | 1
other_useful_info       | 12
infrastructure_utilities| 1
useless_info            | 3

// tickerplant process
q)affected_individuals
recv_time            tweet                                                   ..
-----------------------------------------------------------------------------..
0D22:20:30.624629000 "rescueph please help us seek rescue for our friend( jaj..
0D22:20:30.982261000 "scores killed in flooding in nepal and india nyt world"..
0D22:20:31.260477000 "more than houses and ppl have died in flood in pakistan..
0D22:20:31.787175000 "many dead in nepal and india floods via (harradox)"    ..
0D22:20:31.986113000 "globalcalgary maps evacuated areas in the city of calga..
``` 

> **Warning**: 
>
> It should be noted here that the 'live system' should be seen as a template for such systems with a number of caveats.
>
> 1.  The corpus of tweets used is not from the live twitter api but are recycled from the notebook, this allows the proposed workflow to be shown.
>
> 2.  Given restrictions in the volume of labelled data the tokenizer used for data encoding is recycled from the notebook, in reality a larger corpus including a larger portion of the English language would allow for truely live training. However the method outlined here was seen as a comprimising step given the size of the dataset.
