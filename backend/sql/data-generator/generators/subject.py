import random


def headers():
    return "ИД,НАЗВАНИЕ,ЧЛВК_ИД,ЦЕНА"


class Subject:
    def __init__(self, id, name, human_id, price):
        self.id = id
        self.name = name
        self.human_id = human_id
        self.price = price

    def __repr__(self):
        return f"{self.id},{self.name},{self.human_id},{self.price}"


def generate(humans):
    subjects = []
    _id = 0
    with open("../data/subjects.csv") as f:
        for id, line in enumerate(f):
            if id == 0:
                continue
            name = line.strip()
            if id == 1:
                for human in humans:
                    subjects.append(Subject(_id, name, human.id, random.randint(0, 10 ** 5)))
                    _id += 1
                continue
            for human in list(random.sample(humans, len(humans) // 10)):
                if random.randint(0, 10) == 10:
                    subjects.append(Subject(_id, name, human.id, random.randint(0, 10 ** 5)))
                    _id += 1
    return subjects
