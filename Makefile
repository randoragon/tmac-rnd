FILES = src/media.tmac src/main.tmac
TARGET = rnd.tmac

all:
	cat -- $(FILES) >$(TARGET)
	@echo 'Exported to $(TARGET)'
