from keepmewet.domain.interfaces.sensor_interface import SensorInterface

# Soil moisture is supposed to change slowly overtime, to simulate drying and watering.
class SimulatedSoilMoistureSensor(SensorInterface[int]):
    """
    A simulated soil moisture sensor.
    The moisture level slowly decreases over time to simulate drying soil.
    """
    def __init__(self, initial_moisture: int = 800, drying_rate: int = 1):
        self._current_moisture = initial_moisture
        self._drying_rate = drying_rate

    def read(self) -> int:
        # Simulate a slow decrease in moisture
        self._current_moisture -= self._drying_rate
        # Add some noise to make it more realistic
        # ... your logic for noise ...
        return max(0, self._current_moisture)

    def set_moisture(self, value: int):
        """A helper method for testing, to simulate watering."""
        self._current_moisture = value