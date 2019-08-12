import pickle

def load_pickle():
        with open('saved_info/tokenizer.pickle', 'rb') as handle:
                tokenizer = pickle.load(handle)
        return(tokenizer);
