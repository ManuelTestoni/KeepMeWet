import time
from keepmewet.domain.interfaces.sensor_interface import SensorInterface
from keepmewet.domain.interfaces.valve_interface import ValveInterface
from keepmewet.domain.entities.configuration import AppConfig

class IrrigationService:
    def __init__(
        self, 
        moisture_sensor: SensorInterface[int], 
        valve: ValveInterface, 
        config: AppConfig
    ):
        # Service receives form other files (Dependency Injection).
        self._sensor = moisture_sensor
        self._valve = valve
        self._config = config

    def check_and_irrigate(self):
        """Main Method, read water level then starts watering if needed."""
        
        # 1. Read sensor value
        current_moisture = self._sensor.read()
        threshold = self._config.irrigation.moisture_threshold
        
        # 2. Take decision
        if current_moisture < threshold:
            # Doing decision taken
            self._start_watering()
        else:
            
            pass 

    def _start_watering(self):
        """Grants opening and closign cycle.."""
        duration = self._config.irrigation.watering_duration_seconds
        
        # Apri
        self._valve.open()
        
        # Aspetta. 
        # NOTA: time.sleep blocca il programma. In un sistema base va bene,
        # in un sistema avanzato o asincrono useremmo asyncio, ma per ora 
        # manteniamolo semplice per imparare l'architettura.
        time.sleep(duration)
        
        # Chiudi
        self._valve.close()