FILES = src/tmac.media \
		src/tmac.toc \
		src/tmac.list \
		src/tmac.profile \
		src/tmac.main
TARGET = tmac.rnd

all:
	cat -- $(FILES) >$(TARGET)
	@echo 'Exported to $(TARGET)'
