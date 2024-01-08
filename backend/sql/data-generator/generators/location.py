import human
from faker import Faker

fake = Faker('ru_RU')

def headers():
    return "ЧЛВК_ИД,СТРАНА,ГОРОД,ШИРОТА,ДОЛГОТА"
class Location:
    def __init__(self, human_id, country, city, longitude, latitude):
        self.human_id = human_id
        self.country = country
        self.city = city
        self.longitude = longitude
        self.latitude = latitude

    def __repr__(self):
        return f"{self.human_id},{self.country},{self.city}, {self.longitude}, {self.latitude}"
    

def generate_location(human_id):
    (longitude, latitude, _, country, city) = fake.location_on_land()
    return Location(human_id, country, city.split("/")[1], longitude, latitude)

def generate(humans):
    return [generate_location(human.id) for human in humans]
        
