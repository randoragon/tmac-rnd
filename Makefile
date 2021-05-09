FILES = src/tmac.media src/tmac.main src/tmac.list
TARGET = tmac.rnd

all:
	cat -- $(FILES) >$(TARGET)
	@echo 'Exported to $(TARGET)'
