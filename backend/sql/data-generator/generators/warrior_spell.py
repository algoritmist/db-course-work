import random


class WarriorSpell:
    def __init__(self, warrior_id, spell_name, duration):
        self.warrior_id = warrior_id
        self.spell_name = spell_name
        self.duration = duration

    def __repr__(self):
        return f"{self.warrior_id},{self.spell_name},{self.duration}"


def generate(warriors, spells):
    warrior_spells = []
    for warrior in warriors:
        for spell in random.sample(spells, random.randint(0, 10)):
            warrior_spells.append(WarriorSpell(warrior.id, spell.name, random.randint(0, 5)))
