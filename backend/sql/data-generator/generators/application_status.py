from enum import Enum


def headers():
    return "ИД,ОПИСАНИЕ"
class ApplicationStatus(Enum):
    ОБРАБАТЫВАЕТСЯ=0
    ОТКЛОНЕНО=1
    ОДОБРЕНО=2