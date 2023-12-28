class Subject:
    def __init__(self, id, name):
        self.id = id
        self.name = name

    def __repr__(self):
        return f"{self.id},{self.name}"
    
def generate():
    subjects = []
    with open("backend/sql/data-generator/data/subjects.csv") as f:
        for id, line in enumerate(f)[1:]:
            name = line
            subjects.append(Subject(id, name))
    return subjects