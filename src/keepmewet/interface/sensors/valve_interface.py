# Our program does not have to know if he is doing what is supposed to do or just printing something.
# To do this we have to use interfaces.

from abc import ABC, abstractmethod

class ValveInterface(ABC):
    """Interfaccia base per l'elettrovalvola o pompa dell'acqua."""

    @abstractmethod
    def open(self) -> None:
        """Apre la valvola (inizia l'irrigazione)."""
        pass

    @abstractmethod
    def close(self) -> None:
        """Chiude la valvola (ferma l'irrigazione)."""
        pass