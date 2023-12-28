import human
import location
import status
import subject
import warrior_type
import spells
import warrior
import worker
import department_type

spells = spells.generate()
with open("../out/spell.csv", "w") as f:
    [f.write(spell.__repr__()+"\n") for spell in spells]
    f.close()

warrior_types = warrior_type.generate()

with open("../out/warrior_type.csv", "w") as f:
    [f.write(warrior_types.__repr__()) for warrior_types in warrior_types]
    f.close()

subjects = subject.generate()
with open("../out/subject.csv", "w") as f:
    [f.write(subject.__repr__()) for subject in subjects]
    f.close()

statuses = status.Status
with open("../out/status.csv", "w") as f:
    [f.write(status.value.__repr__()) for status in statuses]
    f.close()

humans = human.generate(100)
with open("../out/human.csv", "w") as f:
    [f.write(human.__repr__()+"\n") for human in humans]
    f.close()
locations = location.generate(humans)
with open("../out/location.csv", "w") as f:
    [f.write(location.__repr__()) for location in locations]
    f.close()

warriors = warrior.generate(humans, warrior_types)
with open("../out/warrior.csv", "w") as f:
    [f.write(warrior.__repr__()) for warrior in warriors]
    f.close()

departments = department_type.generate()
with open("../out/department.csv", "w") as f:
    [f.write(department.__repr__()) for department in departments]
    f.close()
workers = worker.generate(humans, departments)
with open("../out/worker.csv", "w") as f:
    [f.write(worker.__repr__()) for worker in workers]
    f.close()