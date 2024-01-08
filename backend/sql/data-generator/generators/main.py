import human
import location
import status
import subject
import warrior_type
import spell
import warrior
import worker
import department_type
import request_type
import application
import priveleges
import contract
import journal
import warrior_spell
import contract_status
import application_status

MAX_PEOPLE = 10 ** 5

spells = spell.generate()
with open("../out/ЗАКЛИНАНИЕ.csv", "w") as f:
    f.write(spell.headers() + "\n")
    [f.write(spell.__repr__() + "\n") for spell in spells]
    f.close()

warrior_types = warrior_type.generate()
with open("../out/ТИП_ВОИНА.csv", "w") as f:
    f.write(warrior_type.headers() + "\n")

    [f.write(warrior_types.__repr__() + "\n") for warrior_types in warrior_types]
    f.close()

statuses = status.Status
with open("../out/СТАТУС.csv", "w") as f:
    f.write(status.headers() + "\n")
    [f.write(f"{status.value},{status.name}\n") for status in statuses]
    f.close()

humans = human.generate(MAX_PEOPLE)
with open("../out/ЧЕЛОВЕК.csv", "w") as f:
    f.write(human.headers() + "\n")
    [f.write(human.__repr__() + "\n") for human in humans]
    f.close()

subjects = subject.generate(humans)
with open("../out/ПРЕДМЕТ.csv", "w") as f:
    f.write(subject.headers() + "\n")
    [f.write(subject.__repr__() + "\n") for subject in subjects]
    f.close()

locations = location.generate(humans)
with open("../out/МЕСТОПОЛОЖЕНИЕ.csv", "w") as f:
    f.write(location.headers() + "\n")
    [f.write(location.__repr__() + "\n") for location in locations]
    f.close()

warriors = warrior.generate(humans, warrior_types)
with open("../out/ВОИН.csv", "w") as f:
    f.write(warrior.headers() + "\n")
    [f.write(warrior.__repr__() + "\n") for warrior in warriors]
    f.close()

departments = department_type.generate()
with open("../out/ОТДЕЛ.csv", "w") as f:
    f.write(department_type.headers() + "\n")
    [f.write(department.__repr__() + "\n") for department in departments]
    f.close()
workers = worker.generate(humans, departments)
with open("../out/РАБОТНИК.csv", "w") as f:
    f.write(worker.headers() + "\n")
    [f.write(worker.__repr__() + "\n") for worker in workers]
    f.close()

request_types = request_type.generate()
with open("../out/ТИП_ЗАПРОСА.csv", "w") as f:
    f.write(request_type.headers() + "\n")
    [f.write(request.__repr__() + "\n") for request in request_types]
    f.close()

privs = priveleges.Priveleges
with open("../out/ПРИВИЛЕГИИ.csv", "w") as f:
    f.write(priveleges.headers() + "\n")
    [f.write(f"{privelege.value},{privelege.name}\n") for privelege in privs]
    f.close()

applications = application.generate(humans, request_types, subjects)
with open("../out/ЗАЯВКА.csv", "w") as f:
    f.write(application.headers() + "\n")
    [f.write(application.__repr__() + "\n") for application in applications]
    f.close()

contracts = contract.generate(applications)
with open("../out/КОНТРАКТ.csv", "w") as f:
    f.write(contract.headers() + "\n")
    [f.write(contract.__repr__() + "\n") for contract in contracts]
    f.close()

jl = journal.generate(applications, contracts)
with open("../out/ВЕДОМОСТЬ.csv", "w") as f:
    f.write(journal.headers() + "\n")
    [f.write(je.__repr__() + "\n") for je in jl]
    f.close()

warrior_spells = warrior_spell.generate(warriors, spells)

with open("../out/ЗАКЛИНАНИЯ_ВОИНА.csv", "w") as f:
    f.write(warrior_spell.headers() + "\n")
    [f.write(warrior_spell.__repr__() + "\n") for warrior_spell in warrior_spells]
    f.close()

contract_statuses = contract_status.ContractStatus
with open("../out/СТАТУС_КОНТРАКТА.csv", "w") as f:
    f.write(contract_status.headers() + "\n")
    [f.write(f"{status.value},{status.name}\n") for status in contract_statuses]
    f.close()

application_statuses = application_status.ApplicationStatus
with open("../out/СТАТУС_ЗАЯВКИ.csv", "w") as f:
    f.write(application_status.headers() + "\n")
    [f.write(f"{status.value},{status.name}\n") for status in application_statuses]
    f.close()
