def headers():
    return "ИД,РАСШИФРОВКА"
class RequestType:
    def __init__(self, id, description):
        self.id = id
        self.description = description

    def __repr__(self):
        return f"{self.id},{self.description}"


def generate():
    return [
        RequestType(0, "Устроить войну"),
        RequestType(1, "Найти человека"),
        RequestType(2, "Купить предмет")
    ]