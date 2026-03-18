# KeepMeWet

A production-ready smart plant monitoring and automatic irrigation system for Raspberry Pi 5. Originally designed for avocado seed cultivation, this system is fully extensible for any plant type.

## Features

- **Environmental Monitoring**: Real-time sensing of soil moisture, temperature, humidity, pressure, and light intensity
- **Automatic Irrigation**: Threshold-based watering with configurable schedules
- **Cloud Sync**: REST API integration with local offline buffering
- **Clean Architecture**: Modular, testable, and maintainable codebase
- **Mock Mode**: Full development support without hardware

## Hardware

| Component | Model | Interface |
|-----------|-------|-----------|
| Controller | Raspberry Pi 5 | - |
| Soil Moisture | Capacitive Sensor | Analog (via MCP3008) |
| ADC | MCP3008 | SPI |
| Environment | BME280 | I2C |
| Light | BH1750 | I2C |
| Relay | 5V 2-Channel | GPIO |
| Valve | FPD-270A Solenoid (12V NC) | Relay |

## Quick Start

```bash
# Clone repository
git clone https://github.com/yourusername/keepmewet.git
cd keepmewet

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -e .

# Copy and configure environment
cp .env.example .env
# Edit .env with your settings

# Run in mock mode (development)
python -m keepmewet --mock

# Run with real hardware
python -m keepmewet
```

## Project Structure

```
keepmewet/
├── src/keepmewet/           # Main application source
│   ├── domain/              # Core business logic (innermost layer)
│   │   ├── entities/        # Business objects with identity
│   │   ├── value_objects/   # Immutable domain primitives
│   │   └── interfaces/      # Abstract contracts (ports)
│   ├── application/         # Use cases and orchestration
│   │   ├── use_cases/       # Business operation handlers
│   │   ├── services/        # Long-running background services
│   │   └── dto/             # Data transfer objects
│   ├── infrastructure/      # External implementations (adapters)
│   │   ├── hardware/        # GPIO, sensors, actuators
│   │   ├── persistence/     # SQLite, file buffer
│   │   ├── api/             # HTTP/MQTT clients
│   │   ├── config/          # Configuration loading
│   │   └── logging/         # Structured logging
│   └── interface/           # Entry points
│       ├── cli/             # Command-line interface
│       ├── service/         # Systemd daemon
│       └── api_contracts/   # Shared API schemas
├── tests/                   # Test suite
│   ├── unit/                # Unit tests by layer
│   ├── integration/         # End-to-end tests
│   ├── fixtures/            # Test data
│   └── mocks/               # Reusable mock implementations
├── config/                  # Configuration files
│   ├── environments/        # Environment-specific configs
│   └── schemas/             # JSON schemas for validation
├── scripts/                 # Automation scripts
│   ├── deployment/          # RPi deployment
│   ├── maintenance/         # Backup, rotation
│   └── development/         # Dev utilities
├── docs/                    # Documentation
│   ├── architecture/        # System design
│   ├── api/                 # API reference
│   ├── hardware/            # Wiring, pinout, BOM
│   └── guides/              # User guides
└── data/                    # Runtime data (gitignored)
    ├── logs/                # Application logs
    ├── db/                  # SQLite databases
    ├── buffer/              # Offline sync buffer
    ├── ml_models/           # ML inference models
    └── datasets/            # Training data exports
```

## Architecture

This project follows **Clean Architecture** principles:

```
┌─────────────────────────────────────────────────────────────┐
│                     Interface Layer                         │
│              (CLI, Service Daemon, API Contracts)           │
├─────────────────────────────────────────────────────────────┤
│                   Infrastructure Layer                       │
│        (Hardware, Persistence, API Clients, Logging)        │
├─────────────────────────────────────────────────────────────┤
│                    Application Layer                         │
│              (Use Cases, Services, DTOs)                    │
├─────────────────────────────────────────────────────────────┤
│                      Domain Layer                            │
│           (Entities, Value Objects, Interfaces)             │
└─────────────────────────────────────────────────────────────┘
```

**Key Principles:**
- **Dependency Inversion**: Inner layers define interfaces, outer layers implement
- **Separation of Concerns**: Hardware, logic, and infrastructure are isolated
- **Testability**: Mock implementations for all external dependencies
- **Extensibility**: Plugin-style sensor/actuator registration

## Configuration

### Environment Variables

```bash
# .env
KEEPMEWET_ENV=development          # development | production | testing
KEEPMEWET_MOCK_MODE=true           # Use simulated sensors
KEEPMEWET_LOG_LEVEL=DEBUG          # DEBUG | INFO | WARNING | ERROR

# API Configuration
API_BASE_URL=https://api.example.com
API_KEY=your-api-key

# Hardware Pins (BCM numbering)
GPIO_RELAY_CHANNEL_1=17
GPIO_RELAY_CHANNEL_2=27
SPI_CE_PIN=0
I2C_BUS=1

# Thresholds
SOIL_MOISTURE_LOW=30               # % - trigger irrigation
SOIL_MOISTURE_HIGH=70              # % - stop irrigation
WATERING_DURATION_SECONDS=30
READING_INTERVAL_SECONDS=60
SYNC_INTERVAL_SECONDS=300
```

## Development

### Running Tests

```bash
# All tests
pytest

# With coverage
pytest --cov=keepmewet --cov-report=html

# Specific layer
pytest tests/unit/domain/
pytest tests/integration/
```

### Mock Mode

Run the full application without hardware:

```bash
python -m keepmewet --mock --verbose
```

Mock sensors generate realistic patterns:
- Soil moisture decreases over time (simulating evaporation)
- Temperature follows day/night cycles
- Light intensity varies with simulated sun position

### Calibration

```bash
# Interactive sensor calibration
python -m keepmewet calibrate --sensor soil_moisture

# Export calibration to file
python -m keepmewet calibrate --export config/calibration_local.yaml
```

## Deployment

### Raspberry Pi Setup

```bash
# On Raspberry Pi
./scripts/deployment/install_dependencies.sh
./scripts/deployment/setup_systemd.sh

# Start service
sudo systemctl start keepmewet
sudo systemctl enable keepmewet

# View logs
journalctl -u keepmewet -f
```

### Systemd Service

The application runs as a systemd service with:
- Automatic restart on failure
- Graceful shutdown handling
- Log integration with journald

## Future Extensions

The architecture supports planned enhancements:

- **Machine Learning**: On-device inference for predictive watering
- **Computer Vision**: Plant health monitoring via camera
- **MQTT Support**: Real-time bidirectional communication
- **Multi-Zone**: Multiple plant zones with independent control

## API Integration

### Sensor Data Payload

```json
{
  "device_id": "rpi5-001",
  "timestamp": "2024-01-15T10:30:00Z",
  "readings": {
    "soil_moisture": 45.2,
    "temperature": 22.5,
    "humidity": 65.0,
    "pressure": 1013.25,
    "light_intensity": 850
  }
}
```

### Configuration Payload

```json
{
  "thresholds": {
    "soil_moisture_low": 30,
    "soil_moisture_high": 70
  },
  "watering": {
    "duration_seconds": 30,
    "cooldown_minutes": 60
  },
  "schedules": [
    {
      "time": "06:00",
      "duration_seconds": 45
    }
  ]
}
```

## License

MIT

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `pytest`
5. Run linting: `ruff check .`
6. Submit a pull request

## Support

- Documentation: `docs/`
- Issues: GitHub Issues
- Hardware questions: See `docs/hardware/`
