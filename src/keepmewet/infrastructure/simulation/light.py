import time
import random
from keepmewet.domain.interfaces.sensor_interface import SensorInterface

class SimulatedBH1750Sensor(SensorInterface[float]):
    """
    A simulated BH1750 light sensor that mimics an indoor light
    being turned on and off.
    """
    def __init__(self):
        self._light_on = False
        self._last_toggle_time = time.time()
        # Toggle every 1 to 4 hours
        self._toggle_interval = random.uniform(3600, 4 * 3600)

    def read(self) -> float:
        # Check if it's time to toggle the light state
        if time.time() - self._last_toggle_time > self._toggle_interval:
            self._light_on = not self._light_on
            self._last_toggle_time = time.time()
            self._toggle_interval = random.uniform(3600, 4 * 3600)

        if self._light_on:
            # Simulate a bright light with some noise
            return 300.0 + random.uniform(-10, 10)
        else:
            # Simulate a dim/dark room
            return 10.0 + random.uniform(-5, 5)
