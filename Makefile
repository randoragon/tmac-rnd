FILES = src/media.tmac src/main.tmac src/list.tmac
TARGET = tmac.rnd

all:
	cat -- $(FILES) >$(TARGET)
	@echo 'Exported to $(TARGET)'
