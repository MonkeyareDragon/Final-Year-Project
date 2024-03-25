import numpy as np
import re
import nltk
from nltk.stem import PorterStemmer

def read_csv_data(file_path):
    data = np.genfromtxt(file_path, delimiter=',', skip_header=1)
    return data

def clean_text(text):
    text = re.sub(r'[^\w\s\.-]', '', text)
    text = text.lower()
    return text

def remove_space(L):
    L1 = []
    for i in L:
        L1.append(i.replace(" ",""))
    return L1

ps = PorterStemmer()
def stems(text):
    T = []

    for i in text.split():
        T.append(ps.stem(i))

    return " ".join(T)