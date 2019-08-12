# FDL Europe 2019, Disaster Prevention, Progress and Response(Floods)

This repository contains code relating to the application of machine learning to tweet classifications relating to disaster management. This work primarily concerns the application of LSTM artificial recurrent neural networks to data from the [Crisis NLP](https://crisisnlp.qcri.org/) dataset.


This work is broken into two sections:

1. The loading/analysis of the Crisis NLP dataset in kdb+ and the production/testing of an LSTM model to both complete binary and multi-class classification of the tweets
2. The creation of a template for the 'live' classification of tweets using the model created in objective 1 which can be used as a base framework for similar work in Natural Language processing within the a kdb+ architecture

> **Warning**: 
> It should be noted here that the 'live system' should be seen as a template for such systems with a number of caveats.
>
>	1.  The corpus of tweets used is not from the live twitter api but are recycled from the notebook, this allows the proposed workflow to be shown.
>
>       2.  Given restrictions in the volume of labelled data the tokenizer used for data encoding is recycled from the notebook, in reality a larger corpus including a larger portion of the English language would allow for truely live training. However the method outlined here was seen as a comprimising step given the size of the dataset.
