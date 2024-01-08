import random


def headers():
    return "ИД,ЗАЯВКА_ИД,СТАТУС_ВЫПОЛНЕНИЯ"


class Contract:
    def __init__(self, id, application_id, status):
        self.id = id
        self.application_id = application_id
        self.status = status

    def __repr__(self):
        return f"{self.id},{self.application_id},{self.status}"


def generate(applications):
    success_applications = list(filter(lambda a: a.status == 1, applications))
    return [Contract(id, application.id, random.randint(0, 1)) for id, application in enumerate(success_applications)]
