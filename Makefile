# Uncomment to enable compilation with LAPACK (functions --mds and --pca will work)
# Path to atlas needs to be specified
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
# Path to atlas library (blas, cblas, lapack) needs to be specified
BLASFLAGS ?= $(LAPACK_LIB)
LIB ?=  -lm -lz
OUTPUT = king-dynamic
SRC = *.cpp
HDR = *.h
OBJ ?= $(SRC)

# Not tested on MAC
#ifeq ($(SYS), MAC)
#  GCC_GTEQ_43 := $(shell expr `g++ -dumpversion | sed -e 's/\.\([0-9][0-9]\)/\1/g' -e 's/\.\([0-9]\)/0\1/g' -e 's/^[0-9]\{3,4\}$$/&00/'` \>= 40300)
#  ifeq "$(GCC_GTEQ_43)" "1"
#    CFLAGS ?= -Wall -O2 -flax-vector-conversions
#  endif
#  BLASFLAGS ?= -framework Accelerate
#  LDFLAGS ?= -ldl
#  ZLIB ?= ../zlib-1.2.11/libz.1.2.11.dylib
#endif

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
