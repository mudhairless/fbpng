CC := gcc
FBC := fbc
RM := rm

LIBNAME := fbpng

BUILDDIR := build
SRCDIR := src
INCDIR := inc
OBJDIR := src/o
TSTDIR := tests
ZDIR   := zlib
TESTPNGDIR := tests/out

SRCS := $(wildcard $(SRCDIR)/*.bas)
INCS := $(wildcard $(INCDIR)/*.bi)
OBJS := $(subst $(SRCDIR)/,,$(SRCS))
OBJS := $(patsubst %.bas,%.o,$(OBJS))
OBJS := $(patsubst %.o,$(OBJDIR)/%.o,$(OBJS))
TSTS := $(wildcard $(TSTDIR)/*.bas)

BACKUPS := $(SRCS) $(INCS) $(TSTS)
BACKUPS := $(patsubst %.bas,%.bas~,$(BACKUPS))
BACKUPS := $(patsubst %.bi,%.bi~,$(BACKUPS))
BACKUPS += Makefile~

TESTPNGS := $(wildcard $(TESTPNGDIR)/*.png)

LIBBIN=$(BUILDDIR)/lib$(LIBNAME).a
LIBXNAME=$(BUILDDIR)/$(LIBNAME)

ifdef STATICZ
	LIBBIN=$(BUILDDIR)/lib$(LIBNAME)s.a
	LIBXNAME=$(BUILDDIR)/$(LIBNAME)s
	FLAGS += -d PNG_STATICZ
	ZOBJS := adler32.o compress.o crc32.o deflate.o inffast.o
	ZOBJS += inflate.o infback.o inftrees.o trees.o uncompr.o zutil.o
	ZOBJS := $(patsubst %.o,$(ZDIR)/%.o,$(ZOBJS))
	ZSRCS := $(patsubst %.o,%.c,$(ZOBJS))
	ZINCS := $(wildcard $(ZDIR)/*.h)
endif

ifdef DEBUG
	FLAGS += -g -d PNG_DEBUG
	CFLAGS += -g
else
	CFLAGS += -O2
endif

ifdef PROFILE
	FLAGS += -profile
	CFLAGS += -p
endif

ifdef EXX
	FLAGS += -exx
endif

ifdef PNG_NO_OLD_API
	FLAGS += -d PNG_NO_OLD_API
	ifdef PNG_NO_PALETTE_8
		FLAGS += -d PNG_NO_PALETTE_8
	endif
	ifdef PNG_NO_RGB_16
		FLAGS += -d PNG_NO_RGB_16
	endif
	ifdef PNG_NO_RGB_32
		FLAGS += -d PNG_NO_RGB_32
	endif
	ifdef PNG_NO_ARGB_32
		FLAGS += -d PNG_NO_ARGB_32
	endif
	ifdef PNG_NO_ABGR_32
		FLAGS += -d PNG_NO_ABGR_32
	endif
endif

ifndef LINUX
	EXEEXT := .exe
endif

all: $(LIBBIN) $(patsubst %.bas,%$(EXEEXT),$(TSTS))

$(LIBBIN) : $(OBJS) $(ZOBJS)
	$(FBC) $(FLAGS) -i $(INCDIR) -lib -x $(LIBBIN) $(OBJS) $(ZOBJS)

$(OBJDIR)/%.o : $(SRCDIR)/%.bas $(INCS)
	$(FBC) $(FLAGS) -i $(INCDIR) $< -c -o $@

$(TSTDIR)/%$(EXEEXT) : $(TSTDIR)/%.bas $(LIBBIN)
	$(FBC) $(FLAGS) -i $(INCDIR) $< -x $@ -p $(BUILDDIR)/

$(ZDIR)/%.o : $(ZDIR)/%.c $(ZINCS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) -f $(OBJS) $(ZOBJS) $(BACKUPS) $(TESTPNGS)

.Phony : clean
