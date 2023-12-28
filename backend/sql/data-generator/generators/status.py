class Status:
    def __init__(self, id, name):
        self.id = id
        self.name = name

    def __repr__(self):
        return f"{self.id},{self.name}"

def generate():
    return [
        Status(0, 'военнообязанный'),
        Status(1, "солдат"),
        Status(2, "полководец"),
        Status(3, "император"),
        Status(4, 'свободный')
    ]