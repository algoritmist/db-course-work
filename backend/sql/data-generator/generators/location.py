import human
from faker import Faker

fake = Faker('ru_RU')

def headers():
    return "ЧЛВК_ИД,СТРАНА,ГОРОД,ШИРОТА,ДОЛГОТА"
class Location:
    def __init__(self, id, country, city, longitude, latitude):
        self.id = id
        self.country = country
        self.city = city
        self.longitude = longitude
        self.latitude = latitude

    def __repr__(self):
        return f"{self.id},{self.country},{self.city}, {self.longitude}, {self.latitude}"
    

def generate_location(id):
    (longitude, latitude, _, country, city) = fake.location_on_land()
    return Location(id, country, city.split("/")[1], longitude, latitude)

def generate():
    return [generate_location(id) for id in range(100)]
        
