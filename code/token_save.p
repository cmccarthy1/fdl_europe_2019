import pickle

def save_token(x):
        with open('tokenizer.pickle', 'wb') as handle:
                pickle.dump(x, handle, protocol=pickle.HIGHEST_PROTOCOL)
