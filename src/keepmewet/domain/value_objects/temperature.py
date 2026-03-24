from dataclasses import dataclass

#We want to keep this object immutable, once we read, we want to be sura that 
# i will not change.
@dataclass(frozen=True)
class BME280Reading:
    """A value object to hold the readings from a BME280 sensor."""
    temperature: float
    humidity: float
    pressure: float