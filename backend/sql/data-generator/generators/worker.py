import random
from priveleges import Priveleges

class Worker:
    def __init__(self, human_id, group_id, priveleges):
        self.human_id = human_id
        self.group_id = group_id
        self.priveleges = priveleges

    def __repr__(self):
        return f"{self.human_id},{self.group_id},{self.priveleges}"

def generate_privelege():
    r = random.randint(0, 5)
    if r == 5:
        return Priveleges.СОВЕРШЕННО_СЕКРЕТНО
    if r >= 3:
        return Priveleges.СЕКРЕТНО
    return Priveleges.ОСОБЫЙ
def generate(humans, departments, worker_fraction = 0.1):
    workers = random.sample(humans, int(1 + len(humans)*worker_fraction))
    return [Worker(worker.id, random.choice(departments).id, generate_privelege()) for worker in workers]