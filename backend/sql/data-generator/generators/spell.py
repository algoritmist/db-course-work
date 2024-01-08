import random

import pandas as pd


def headers():
    return "НАЗВАНИЕ,УРОН,ЭФФЕКТ"
class Spell:
    def __init__(self, name, damage, effect):
        self.name = name
        self.damage = damage
        self.effect = effect

    def __repr__(self):
        return f"{self.name},{self.damage},{self.effect}"


def generate():
    df = pd.read_csv("../data/Spells.csv")
    return [Spell(row["Spell Name"], random.randint(0, 100), row["Effect"]) for _, row in df.iterrows()]
