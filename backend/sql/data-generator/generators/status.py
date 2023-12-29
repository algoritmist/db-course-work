from enum import Enum

def headers():
   return "ИД,Описание"

class Status(Enum):
   ВОЕННООБЯЗАННЫЙ = 0
   СОЛДАТ = 1
   ПОЛКОВОДЕЦ = 2
   ИМПЕРАТОР = 3
   СВОБОДНЫЙ = 4