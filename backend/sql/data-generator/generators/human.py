import random
from status import Status
from faker import Faker

fake = Faker('ru_RU')


def headers():
    return "ИД,ИМЯ,ФАМИЛИЯ,ПОЛ,ДАТА_РОЖДЕНИЯ,СТАТУС_ИД,БАЛАНС,ПРОДАЖА_ДУШИ,МЕСТОПОЛОЖЕНИЕ"


class Human:
    def __init__(self, id, gender, first_name, last_name, date_of_birth, status_id, money, sold_soul, location):
        self.id = id
        self.gender = gender
        self.first_name = first_name
        self.last_name = last_name
        self.date_of_birth = date_of_birth
        self.status_id = status_id
        self.money = money
        self.sold_soul = sold_soul
        self.location = location

    def __repr__(self):
        return f"{self.id},{self.first_name},{self.last_name},{self.gender},{self.date_of_birth},{self.status_id},{self.money},{self.sold_soul},{self.location}"


def generate_name_and_gender():
    gender = 'М' if random.randint(0, 1) == 0 else 'Ж'
    first_name = fake.first_name_male() if gender == 'М' else fake.first_name_female()
    last_name = fake.last_name_male() if gender == 'М' else fake.last_name_female()
    return {'gender': gender, 'first_name': first_name, 'last_name': last_name}


def generate_random_status():
    r = random.randint(0, 10)
    if r == 10:
        return Status.ИМПЕРАТОР
    if r >= 8:
        return Status.ПОЛКОВОДЕЦ
    if r >= 2:
        return Status.СОЛДАТ
    return Status.ВОЕННООБЯЗАННЫЙ


def generate_one(id, locations):
    result = generate_name_and_gender()
    gender = result['gender']
    first_name = result['first_name']
    last_name = result['last_name']
    date = fake.date_of_birth()
    status = Status.СВОБОДНЫЙ if gender == 'F' else generate_random_status()
    money = random.randint(0, 10 ** 9)
    sold_soul = random.randint(0, 1) == 0
    location = random.choice(locations).id
    return Human(id, gender, first_name, last_name, date, status.value, money, sold_soul, location)


def generate(rows, locations):
    return [generate_one(id, locations) for id in range(rows)]
