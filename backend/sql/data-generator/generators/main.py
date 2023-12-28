import human
import location
import status
import subject
import soldier_type

soldier_type = soldier_type.generate()
for soldier in soldier_type:
    print(soldier)

subjects = subject.generate()
for subject in subjects:
    print(subject)
statuses = status.generate()
for status in statuses:
    print(status)
humans = human.generate(100)
locations = location.generate(humans)
for human in humans:
    print(human)
for location in locations:
    print(location)