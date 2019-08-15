import pickle

def load_pickle():
        with open('mdls/tokenizer.pickle', 'rb') as handle:
                tokenizer = pickle.load(handle)
        return(tokenizer);
