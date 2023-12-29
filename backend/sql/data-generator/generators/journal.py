from request_type import RequestType
from faker import Faker

fake = Faker("ru_RU")


def headers():
    return "ИД,Контракт_ИД,Примечания,Отдел_ИД,Дата_запроса,Дата_выполнения"


class Journal:
    def __init__(self, id, contract_id, annotations, department_id, request_date, execution_date):
        self.id = id
        self.contract_id = contract_id
        self.annotations = annotations
        self.department_id = department_id
        self.request_date = request_date
        self.execution_date = execution_date

    def __repr__(self):
        return f"{self.id},{self.contract_id},{self.annotations},{self.department_id},{self.request_date},{self.execution_date}"


def generate(applications, contracts):
    journal = []
    id = 0
    for contract in contracts:
        application = applications[contract.application_id]
        department_id = 4
        if application.request_type == 0:
            department_id = 5
        if application.request_type == 1:
            department_id = 2
        annotations = fake.sentence()
        request_date = fake.date()
        execution_date = fake.date()
        if request_date > execution_date:
            execution_date, execution_date = execution_date, request_date
        journal.append(Journal(id, contract.id, annotations, department_id, request_date, execution_date))
        id += 1
    return journal
