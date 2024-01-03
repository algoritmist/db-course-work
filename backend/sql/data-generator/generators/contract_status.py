from enum import Enum


def headers():
    return "ИД,Описание"
class ContractStatus(Enum):
    ВЫПОЛНЕН=0
    ВЫПОЛНЯЕТСЯ=1