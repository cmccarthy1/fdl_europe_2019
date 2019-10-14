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
>conda install --file requirements.txt
```

In addition to this both [EmbedPy](https://github.com/kxsystems/embedpy) and [JupyterQ](https://github.com/kxsystems/jupyterq) are required. The Kx [NLP](https://github.com/kxsystems/nlp) and Kx [ML toolkit](https://github.com/kxsystems/ml) libraries should also be installed in `$QHOME`

## Code

The code in this white paper is split into two distinct sections and should be run as follow;

1.  The jupyter notebook should be run in order to ensure all variables are correctly populated.

2.  The 'live' system should be run as follows

```
// initialize tickerplant process
$ q tick.q sym ./log/

For the purposes of this example -p must be set to 5140, setting port accordingly

q)


// Initialize Feedhandler process (set to publist to port 5140)
$ q feed.q

/ Publish tweets every 100ms to the tickerplant 
q)\t 100
The following are the number of tweets in each class for 50 processed tweets
affected_individuals    | 23
caution_advice          | 2
donations_volunteering  | 8
sympathy_prayers        | 1
other_useful_info       | 12
infrastructure_utilities| 1
useless_info            | 3


// Initialize Real time database to handle tables during the day
$ q tick/r.q -p 5011

q)caution_advice
time                 sym            tweet                                    ..
-----------------------------------------------------------------------------..
0D13:19:27.402944000 caution_advice "abcnews follow our live blog for the lat..
0D13:19:28.898058000 caution_advice "davidcurnowabc toowoomba not spared wind..
0D13:19:31.498798000 caution_advice "acpmh check out beyondblue looking after..
0D13:19:33.797604000 caution_advice "ancalerts pagasa advisory red warning fo..
0D13:19:34.798857000 caution_advice "flood warning for the dawson and fitzroy..
q)donations_volunteering
time                 sym                    tweet                            ..
-----------------------------------------------------------------------------..
0D13:19:27.300326000 donations_volunteering "rancyamor annecurtissmith please..
0D13:19:27.601642000 donations_volunteering "arvindkejriwal all aap mlas to d..
0D13:19:28.198921000 donations_volunteering "truevirathindu manmohan singh so..
0D13:19:29.001481000 donations_volunteering "bpincott collecting donations in..
0D13:19:30.297868000 donations_volunteering "vailresorts vail resorts gives p..
``` 

> **Warning**: 
>
> It should be noted here that the 'live system' should be seen as a template for such systems with a number of caveats.
>
> 1.  The corpus of tweets used is not from the live twitter api but are recycled from the notebook, this allows the proposed workflow to be shown.
>
> 2.  Given restrictions in the volume of labelled data the tokenizer used for data encoding is recycled from the notebook, in reality a larger corpus including a larger portion of the English language would allow for truely live training. However the method outlined here was seen as a comprimising step given the size of the dataset.
