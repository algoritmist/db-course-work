import random


def headers():
    return "ЧЛВК_ИД,ОТДЕЛ_ИД,ЗАНЯТОСТЬ"


class Worker:
    def __init__(self, human_id, group_id, is_working):
        self.human_id = human_id
        self.group_id = group_id
        self.is_working = is_working

    def __repr__(self):
        return f"{self.human_id},{self.group_id},{self.is_working}"


def generate(humans, departments, worker_fraction=0.1):
    workers = random.sample(humans, int(1 + len(humans) * worker_fraction))
    return [Worker(worker.id, random.choice(departments).id, False) for worker in workers]
