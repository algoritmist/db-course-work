from enum import Enum


def headers():
    return "ИД,Описание"
class Priveleges(Enum):
    ОСОБЫЙ = 2
    СЕКРЕТНО = 1
    СОВЕРШЕННО_СЕКРЕТНО = 0