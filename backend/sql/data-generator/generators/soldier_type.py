import random
import pandas as pd

class SoldierType:
    def __init__(self, name, weapon_bonus, armor_bonus, magic_bonus):
        self.type = name
        self.weapon_bonus = weapon_bonus
        self.armor_bonus = armor_bonus
        self.magic_bonus = magic_bonus

        def __repr__(self):
            return f"{self.name},{self.weapon_bonus},{self.armor_bonus},{self.magic_bonus}"


def generate():
    df = pd.read_csv("backend/sql/data-generator/data/H3Units.csv")["Unit_name", "Attack", "Defense"]
    return [SoldierType(row["Unit_name"], row["Attack"], row["Defence"], random.randint(0, 5)) for _, row in df.iterrows()]

    