import random

from request_type import RequestType
from faker import Faker

fake = Faker("ru_RU")


def headers():
    return "ИД,КОНТРАКТ_ИД,ПРИМЕЧАНИЯ,ОТДЕЛ_ИД,ДАТА_ЗАПРОСА,ДАТА_ВЫПОЛЕНИЯ,МЕСТОПОЛОЖЕНИЕ"


class Journal:
    def __init__(self, id, contract_id, department_id, request_date, execution_date, location_id):
        self.id = id
        self.contract_id = contract_id
        self.department_id = department_id
        self.request_date = request_date
        self.execution_date = execution_date
        self.location_id = location_id

    def __repr__(self):
        return f"{self.id},{self.contract_id},{self.department_id},{self.request_date},{self.execution_date},{self.location_id}"


def generate(applications, contracts, locations):
    journal = []
    id = 0
    for contract in contracts:
        application = applications[contract.application_id]
        department_id = 1
        if application.request_type == 0:
            department_id = 5
        if application.request_type == 1:
            department_id = 2
        request_date = fake.date()
        execution_date = fake.date()
        if request_date > execution_date:
            execution_date, execution_date = execution_date, request_date
        journal.append(Journal(id, contract.id, department_id, request_date, execution_date, random.choice(locations).id))
        id += 1
    return journal
