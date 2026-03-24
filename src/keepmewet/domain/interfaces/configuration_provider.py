from abc import ABC, abstractmethod
from keepmewet.domain.entities.configuration import AppConfig

class ConfigurationProvider(ABC):
    """An interface for a provider that loads application configuration."""

    @abstractmethod
    def get_config(self) -> AppConfig:
        """Loads and returns the application configuration."""
        pass