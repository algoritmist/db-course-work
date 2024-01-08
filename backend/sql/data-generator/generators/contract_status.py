from enum import Enum


def headers():
    return "ИД,ОПИСАНИЕ"
class ContractStatus(Enum):
    ВЫПОЛНЕН=0
    ВЫПОЛНЯЕТСЯ=1