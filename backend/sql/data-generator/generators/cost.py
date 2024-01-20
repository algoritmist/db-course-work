def headers():
    return "НАЗВАНИЕ,СТОИМОСТЬ"


class Cost:
    def __init__(self, cost, name):
        self.cost = cost
        self.name = name

    def __repr__(self):
        return f"{self.name},{self.cost}"


def generate():
    return [
        Cost(10, "стоимость воина"),
        Cost(20, "Стоимость предводителя"),
        Cost(30, "Найти человека"),
        Cost(40, "Транспортировка человека на 1 км"),
        Cost(50, "Найти предмет"),
        Cost(60, "Отобрать предмет")
    ]
