import random


def headers():
    return "ИД,ЧЛВК_ИД,ТИП_ЗАПРОСА,ЦЕЛЬ_ЧЛВК_ИД,ЦЕЛЬ_ПРЕДМЕТ_ИД,СТАТУС_ОДОБРЕНИЯ,ТИП_ВОИНА"


class Application:
    def __init__(self, id, human_id, request_type, target_human_id, target_subject_id, status, warrior_type):
        self.id = id
        self.human_id = human_id
        self.request_type = request_type
        self.target_human_id = target_human_id
        self.target_subject_id = target_subject_id
        self.status = status
        self.warrior_type = warrior_type

    def __repr__(self):
        return f"{self.id},{self.human_id},{self.request_type},{self.target_human_id},{self.target_subject_id},{self.status},{self.warrior_type}"


def generate(humans, request_types, subjects):
    applications = []
    rich_humans = list(filter(lambda h: h.money >= 10 ** 7, humans))
    other_humans = random.sample(humans, int(len(humans) ** 0.5))
    id = 0
    for human in random.sample(rich_humans, len(rich_humans) // 100 + 1):
        for requests in range(random.randint(0, 2)):
            status = random.randint(0, 2)
            request_type = random.choice(request_types).id
            target_human_id = random.choice(other_humans).id
            target_subject_id = random.choice(list(filter(lambda sub: sub.human_id == target_human_id, subjects))).id
            wtype = random.randint(1, 2)
            applications.append(Application(id, human.id, request_type, target_human_id, target_subject_id, status, wtype))
            id += 1
    return applications
