# Writing a generic sensor interface that can be used to 
# simulate different types of sensors

from abc import ABC, abstractmethod
from typing import Generic, TypeVar

T = TypeVar('T')

# We take advantage of generic datas to allow different types of sensors.
class SensorInterface(Generic[T], ABC):
    """A generic interface for a sensor that provides readings of a certain type."""

    @abstractmethod
    def read(self) -> T:
        """Reads a value from the sensor."""
        pass