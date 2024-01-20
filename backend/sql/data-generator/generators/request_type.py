from priveleges import Priveleges

def headers():
    return "ИД,РАСШИФРОВКА"
class RequestType:
    def __init__(self, id, description, priveleges):
        self.id = id
        self.description = description
        self.priveleges = priveleges

    def __repr__(self):
        return f"{self.id},{self.description}"


def generate():
    return [
        RequestType(0, "Устроить войну", Priveleges.СОВЕРШЕННО_СЕКРЕТНО.value),
        RequestType(1, "Найти человека", Priveleges.СЕКРЕТНО.value),
        RequestType(2, "Купить предмет", Priveleges.ОСОБЫЙ.value)
    ]