class RequestType:
    def __init__(self, id, description, priveleges):
        self.id = id
        self.description = description
        self.priveleges = priveleges


def generate():
    return [
        RequestType(0, "Устроить войну", 3),
        RequestType(1, "Найти человека", 2),
        RequestType(2, "Купить предмет", 1)
    ]