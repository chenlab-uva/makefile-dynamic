# Uncomment to enable compilation with LAPACK (functions --mds and --pca will work)
# Path to LAPACK library needs to be specified
#WITH_LAPACK = 1
#LAPACK_LIB = /usr/lib64/liblapack.so.3

# should autodetect system
SYS = UNIX
ifdef SystemRoot
	SYS = WIN
else
	UNAME := $(shell uname)
	ifeq ($(UNAME), Darwin)
		SYS = MAC
	endif
endif

# Variables that will be overwritten if building with LAPACK 
BIN ?=          king
CXX ?=          c++
CXXFLAGS ?=     -O2 -I. -fopenmp
BLASFLAGS ?= $(LAPACK_LIB)
LIB ?=  -lm -lz
OUTPUT = king
SRC = *.cpp
HDR = *.h
OBJ ?= $(SRC)

# Not tested on MAC
ifeq ($(SYS), MAC)
	BLASFLAGS ?= -framework Accelerate
	LIB += -ldl -lstdc++
	CXX = gcc-9
	CXXFLAGS ?= -O2 -fopenmp
endif

ifdef WITH_LAPACK
	CXXFLAGS += -DWITH_LAPACK
	LIB += $(BLASFLAGS)
	OBJ = $(SRC:.cpp=.o)
endif

all : $(OUTPUT)
$(OUTPUT) :
	$(CXX) $(CXXFLAGS) -o $(OUTPUT) $(OBJ) $(LIB) 
$(OBJ) : $(HDR)
.cpp.o :
	$(CXX) $(CXXFLAGS) -c $*.cpp
.SUFFIXES : .cpp .c .o $(SUFFIXES)
$(OUTPUT) : $(OBJ)
