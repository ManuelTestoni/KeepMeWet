# In src/keepmewet/infrastructure/config/yaml_config_provider.py

import yaml
from keepmewet.domain.entities.configuration import AppConfig, IrrigationSettings
from keepmewet.domain.interfaces.configuration_provider import ConfigurationProvider

class YamlConfigProvider(ConfigurationProvider):
    """Loads configuration from a YAML file."""

    def __init__(self, file_path: str):
        self._file_path = file_path

    def get_config(self) -> AppConfig:
        with open(self._file_path, 'r') as f:
            raw_config = yaml.safe_load(f)

        # Here you would manually map the dictionary to your dataclasses
        # This provides a layer of validation and transformation
        irrigation_settings = IrrigationSettings(
            moisture_threshold=raw_config['irrigation']['moisture_threshold'],
            watering_duration_seconds=raw_config['irrigation']['watering_duration_seconds']
        )

        return AppConfig(irrigation=irrigation_settings)
