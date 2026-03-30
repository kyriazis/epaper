
EPAPER_MODEL = EPD_2in7_V2
EPAPER_SRC = ${EPAPER_MODEL}.c

EPD_LIB_BIN = ./lib/bin
EPD_LIB = $(EPD_LIB_BIN)/libEPD.a

DIR_CONF = ./lib/Config
DIR_EPD = ./lib/e-Paper
DIR_FONTS = ./lib/Fonts
DIR_GUI = ./lib/GUI

VPATH = $(DIR_CONF):$(DIR_EPD):$(DIR_GUI)

INCS = -I $(DIR_CONF)

DEV_SRC = \
	$(DIR_CONF)/dev_hardware_SPI.c \
	$(DIR_CONF)/RPI_gpiod.c \
	$(DIR_CONF)/DEV_Config.c \
	$(NULL)

EPD_SRC = \
	$(DIR_EPD)/$(EPAPER_SRC) \
	$(NULL)

GUI_SRC = \
	$(DIR_GUI)/GUI_Paint.c \
	$(DIR_GUI)/GUI_BMPfile.c \
	$(NULL)

SRC = $(DEV_SRC) $(EPD_SRC) $(GUI_SRC)
OBJ = $(patsubst %, $(EPD_LIB_BIN)/%, $(notdir $(patsubst %.c, %.o, $(SRC))))

all: lib

lib: $(EPD_LIB)

$(EPD_LIB): $(EPD_LIB_BIN) $(OBJ)

$(EPD_LIB_BIN):
	mkdir -p $(EPD_LIB_BIN)

$(EPD_LIB_BIN)/%.o: %.c
	$(CC) $(CFLAGS) $(DEBUG) -c $< -o $@ $(INCS)
	$(AR) rvU $(EPD_LIB) $@

clean:
	rm -rf $(EPD_LIB_BIN)
