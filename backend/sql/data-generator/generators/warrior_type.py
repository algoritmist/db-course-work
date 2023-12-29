import random
import pandas as pd

def headers():
   return "Название,Атака,Защита,Бонус_к_магии"
class WarriorType:
    def __init__(self, name, attack, defence, magic_bonus):
        self.name = name
        self.attack = attack
        self.defence = defence
        self.magic_bonus = magic_bonus

    def __repr__(self):
        return f"{self.name},{self.attack},{self.defence},{self.magic_bonus}"


def generate():
    df = pd.read_csv("../data/H3Units.csv")
    return [WarriorType(row["Unit_name"], row["Attack"], row["Defence"], random.randint(0, 5)) for _, row in df.iterrows()]

    