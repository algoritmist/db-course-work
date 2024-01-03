import random


def headers():
    return "ИД,ЧЛКВ_ИД,тип_запроса,статус_одобрения"


class Application:
    def __init__(self, id, human_id, request_type, status):
        self.id = id
        self.human_id = human_id
        self.request_type = request_type
        self.status = status

    def __repr__(self):
        return f"{self.id},{self.human_id},{self.request_type},{self.status}"


def generate(humans, request_types):
    applications = []
    rich_humans = list(filter(lambda h: h.money >= 10 ** 7, humans))
    id = 0
    for human in rich_humans:
        for requests in range(random.randint(0, 2)):
            status = random.randint(0, 1)
            request_type = random.choice(request_types).id
            applications.append(Application(id, human.id, request_type, status))
            id += 1
    return applications
