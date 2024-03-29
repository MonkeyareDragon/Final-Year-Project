import numpy as np
import re
import pandas as pd
from nltk.stem import PorterStemmer
import os
import config.settings.base as settings

def clean_text(text):
    text = re.sub(r'[^\w\s\.-]', '', text)
    text = text.lower()
    return text

def remove_space(L):
    L1 = []
    for i in L:
        L1.append(i.replace(" ",""))
    return L1

def stems(text):
    ps = PorterStemmer()
    T = []

    for i in text.split():
        T.append(ps.stem(i))

    return " ".join(T)

def read_csv_data(file_path):
    food_df = pd.read_csv(file_path)
    return food_df

def format_data(food_df):
    #Remove unwanted characters
    food_df['Cooking Difficulty'] = food_df['Cooking Difficulty'].apply(clean_text)
    food_df['Time Required'] = food_df['Time Required'].apply(clean_text)
    food_df['Calories'] = food_df['Calories'].apply(clean_text)
    food_df['Author'] = food_df['Author'].apply(clean_text)
    food_df['Description'] = food_df['Description'].apply(clean_text)
    food_df['Nutrition'] = food_df['Nutrition'].apply(clean_text)
    food_df['Ingredient'] = food_df['Ingredient'].apply(clean_text)
    food_df['Making Steps'] = food_df['Making Steps'].apply(clean_text)

    #Split into each letters
    food_df['Cooking Difficulty'] = food_df['Cooking Difficulty'].apply(lambda x:x.split())
    food_df['Time Required'] = food_df['Time Required'].apply(lambda x:x.split())
    food_df['Calories'] = food_df['Calories'].apply(lambda x:x.split())
    food_df['Author'] = food_df['Author'].apply(lambda x:x.split())
    food_df['Description'] = food_df['Description'].apply(lambda x:x.split())
    food_df['Nutrition'] = food_df['Nutrition'].apply(lambda x:x.split())
    food_df['Ingredient'] = food_df['Ingredient'].apply(lambda x:x.split())
    food_df['Making Steps'] = food_df['Making Steps'].apply(lambda x:x.split())

    #Remove spaces
    food_df['Cooking Difficulty'] = food_df['Cooking Difficulty'].apply(remove_space)
    food_df['Time Required'] = food_df['Time Required'].apply(remove_space)
    food_df['Calories'] = food_df['Calories'].apply(remove_space)
    food_df['Author'] = food_df['Author'].apply(remove_space)
    food_df['Description'] = food_df['Description'].apply(remove_space)
    food_df['Nutrition'] = food_df['Nutrition'].apply(remove_space)
    food_df['Ingredient'] = food_df['Ingredient'].apply(remove_space)
    food_df['Making Steps'] = food_df['Making Steps'].apply(remove_space)
    
    return food_df

def new_data(food_df):
    # Concatinate all
    food_df['tags'] = food_df['Cooking Difficulty'] + food_df['Time Required'] + food_df['Calories'] + food_df['Author'] + food_df['Description'] + food_df['Nutrition'] + food_df['Ingredient'] + food_df['Making Steps']
    final_df = food_df[['ID', 'Name', 'tags']]
    
    # Converting list to str
    final_df['tags'] = final_df['tags'].apply(lambda x: " ".join(x))
    #Convert to lower case
    final_df['tags'] = final_df['tags'].apply(lambda x:x.lower())
    #Convert to stem words (eg. running -> run)
    final_df['tags'] = final_df['tags'].apply(stems)
    
    return final_df

def save_df_to_csv(df, file_path):
    # Check if the directory exists, if not create it
    directory = os.path.dirname(file_path)
    if not os.path.exists(directory):
        os.makedirs(directory)

    # Save DataFrame to CSV file
    df.to_csv(file_path, index=False)