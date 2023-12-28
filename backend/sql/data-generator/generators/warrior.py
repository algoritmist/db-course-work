import random

from status import *


class Warrior:
    def __init__(self, human_id, warrior_type, leader_id, health, armor_health, weapon_health):
        self.human_id = human_id
        self.warrior_type = warrior_type
        self.leader_id = leader_id
        self.health = health
        self.armor_health = armor_health
        self.weapon_health = weapon_health

    def __repr__(self):
        return f"{self.human_id},{self.warrior_type},{self.health},{self.armor_health},{self.weapon_health}"


def generate(humans, warrior_types):
    emperors = list(filter(lambda h: h.status_id == Status.ИМПЕРАТОР, humans))
    generals = list(filter(lambda h: h.status_id == Status.ПОЛКОВОДЕЦ, humans))
    soldiers = list(filter(lambda h: h.status_id == Status.СОЛДАТ, humans))

    emperor_warriors = \
        [
            Warrior
                (
                human.id,
                random.choice(warrior_types),
                None,
                random.randint(1, 100),
                random.randint(1, 100),
                random.randint(1, 100)
            )
            for human in emperors
        ]
    general_warriors = \
        [
            Warrior
                (
                human.id,
                random.choice(warrior_types),
                random.choice(emperors),
                random.randint(1, 100),
                random.randint(1, 100),
                random.randint(1, 100)
            )
            for human in generals
        ]

    soldier_warriors = \
        [
            Warrior
                (
                human.id,
                random.choice(warrior_types),
                random.choice(generals),
                random.randint(1, 100),
                random.randint(1, 100),
                random.randint(1, 100)
            )
            for human in soldiers
        ]
    return emperor_warriors + general_warriors + soldier_warriors
