FILES = src/media.tmac src/main.tmac
TARGET = tmac.rnd

all:
	cat -- $(FILES) >$(TARGET)
	@echo 'Exported to $(TARGET)'
