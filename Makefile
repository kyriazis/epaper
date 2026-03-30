
EPAPER_MODEL = EPD_2in7_V2
EPAPER_SRC = ${EPAPER_MODEL}.c

EPD_LIB_BIN = ./lib/bin
EPD_LIB = $(EPD_LIB_BIN)/libEPD.a

DIR_CONF = ./lib/Config
DIR_EPD = ./lib/e-Paper
DIR_FONTS = ./lib/Fonts
DIR_GUI = ./lib/GUI

EPDTEST_SRCDIR = ./src
EPDTEST_BINDIR = ./bin
EPDTEST_NAME = epdtest
EPDTEST = $(EPDTEST_BINDIR)/$(EPDTEST_NAME)

VPATH = $(DIR_CONF):$(DIR_EPD):$(DIR_GUI):$(DIR_FONTS)

LIBINCS = -I $(DIR_CONF)
INCS = -I ./lib

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

FONTS_SRC = \
	$(DIR_FONTS)/font12.c \
	$(DIR_FONTS)/font12CN.c \
	$(DIR_FONTS)/font16.c \
	$(DIR_FONTS)/font20.c \
	$(DIR_FONTS)/font24.c \
	$(DIR_FONTS)/font24CN.c \
	$(DIR_FONTS)/font8.c \
	$(NULL)

SRC = $(DEV_SRC) $(EPD_SRC) $(GUI_SRC) $(FONTS_SRC)
OBJ = $(patsubst %, $(EPD_LIB_BIN)/%, $(notdir $(patsubst %.c, %.o, $(SRC))))

ifeq ($(DEBUG),1)
CFLAGS += -D DEBUG -g
endif

CFLAGS += -D USE_LGPIO_LIB -D RPI

all: lib test

lib: $(EPD_LIB)

$(EPD_LIB): $(EPD_LIB_BIN) $(OBJ)

$(EPD_LIB_BIN):
	mkdir -p $(EPD_LIB_BIN)

$(EPD_LIB_BIN)/%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@ $(LIBINCS)
	$(AR) rvU $(EPD_LIB) $@

test: $(EPDTEST_BINDIR) $(EPDTEST)

$(EPDTEST_BINDIR):
	mkdir -p $(EPDTEST_BINDIR)

$(EPDTEST): $(EPDTEST_SRCDIR)/$(EPDTEST_NAME).c
	$(CC) $(CFLAGS) -o $@ $< $(INCS) -L $(EPD_LIB_BIN) -lEPD -llgpio

clean:
	rm -rf $(EPD_LIB_BIN) $(EPDTEST_BINDIR)
