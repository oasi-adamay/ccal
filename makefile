
#------------------------------------------------------------------------------
# source & target
SRCS 	= lex.yy.c	y.tab.c

# カレントディレクト名をターゲット名称にする。
ifeq ($(OS),Windows_NT)
TARGET = $(notdir $(CURDIR)).exe
else
TARGET = $(notdir $(CURDIR))
endif

#------------------------------------------------------------------------------
# build type
BUILD_TYPE = Debug


#------------------------------------------------------------------------------
# tool chain & options

CC = clang
#CFLAGS = -Wall -std=c++14
#CFLAGS = -Wall
CFLAGS += -D"_CRT_SECURE_NO_WARNINGS"

ifeq ($(BUILD_TYPE),Debug)
CFLAGS += -g -O0
else
CFLAGS += -O3
endif
#CFLAGS += -ferror-limit=1
#CFLAGS += -v

ifeq ($(OS),Windows_NT)
else
FLAGS += -stdlib=libc++
endif

YACC = yacc
LEX = flex

#------------------------------------------------------------------------------
# phony command
.PHONY: all
all:	build

.PHONY: build
build:	$(TARGET) 	

.PHONY: clean
clean:
	rm -f $(TARGET) $(DEPENDS) $(OBJS)

.PHONY: run
run:	build
	@./$(TARGET)


#------------------------------------------------------------------------------
# make rule
%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

y.tab.c: ccal.y
	$(YACC) -dv $<

lex.yy.c: ccal.l
	$(LEX) $<

$(TARGET) : lex.yy.c y.tab.c
	$(CC) $(CFLAGS)  $^ -o $@










