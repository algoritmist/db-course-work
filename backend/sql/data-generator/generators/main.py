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
for spell in spells:
    print(spell)
warrior_types = warrior_type.generate()
for warrior_type in warrior_types:
    print(warrior_type)

subjects = subject.generate()
for subject in subjects:
    print(subject)
statuses = status.Status
for status in statuses:
    print(status)
humans = human.generate(100)
locations = location.generate(humans)
for human in humans:
    print(human)
for location in locations:
    print(location)

warriors = warrior.generate(humans, warrior_types)
for warrior in warriors:
    print(warrior)

departments = department_type.generate()
for department in departments:
    print(department)
workers = worker.generate(humans, departments)
for worker in workers:
    print(worker)