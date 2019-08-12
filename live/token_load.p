import pickle

def load_pickle():
        with open('tokenizer.pickle', 'rb') as handle:
                tokenizer = pickle.load(handle)
        return(tokenizer);
