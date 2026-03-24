# In src/keepmewet/infrastructure/simulation/simulated_bme280_sensor.py

import math
import time
from keepmewet.domain.interfaces.sensor_interface import SensorInterface
from keepmewet.domain.value_objects.bme280_reading import BME280Reading

class SimulatedBME280Sensor(SensorInterface[BME280Reading]):
    """
    A simulated BME280 sensor that provides cyclical temperature,
    humidity, and pressure readings.
    """
    def read(self) -> BME280Reading:
        # Use a sine wave based on the time of day to simulate changes
        # For example, map 24 hours to a full 2*pi cycle
        cycle = (time.time() % (24 * 3600)) / (24 * 3600) * 2 * math.pi

        # Simulate temperature oscillating between 20 and 25 degrees
        temp = 22.5 + math.sin(cycle) * 2.5

        # Simulate humidity being inversely related to temperature
        humidity = 50 - math.sin(cycle) * 10

        # Pressure can have some minor noise around a baseline
        pressure = 1013.25 + (math.sin(cycle * 4) * 0.2) # Faster, smaller fluctuations

        return BME280Reading(
            temperature=temp,
            humidity=humidity,
            pressure=pressure
        )