from dataclasses import dataclass

@dataclass(frozen=True)
class IrrigationSettings:
    """A value object for irrigation-related settings."""
    moisture_threshold: int
    watering_duration_seconds: int

@dataclass(frozen=True)
class AppConfig:
    """The main configuration entity for the application."""
    irrigation: IrrigationSettings