
# Please specify the directory with boost include files here.
PREFIX = /usr/local
BOOST_INCLUDES = ${PREFIX}/include

# CXX = g++
CXXFLAGS = -I$(BOOST_INCLUDES) -O3 -finline-functions -Wno-inline -Wall
LFLAGS =

IDEPS = aux_.h lite-hooks-wrap.h lite-malloc.h  stack.h  u-singleton.h l-singleton.h 
 
STATIC_LIB = liblite-malloc-static.a
SHARED_LIB = liblite-malloc-shared.so

litemalloc = lite-malloc.o

all: $(litemalloc)

$(litemalloc): $(IDEPS)
	$(CXX) $(CFLAGS) $(CXXFLAGS) lite-malloc.cpp -fPIC -c -o $@

$(STATIC_LIB): $(litemalloc)
	-rm -f $(STATIC_LIB)
	ar rc $(STATIC_LIB) $(litemalloc)

$(SHARED_LIB): $(litemalloc)
	objcopy --redefine-sym __wrap_malloc=malloc \
		--redefine-sym __wrap_free=free \
		--redefine-sym __wrap_calloc=calloc \
		--redefine-sym __wrap_realloc=realloc \
		--redefine-sym __wrap_memalign=memalign \
		--redefine-sym __wrap_posix_memalign=posix_memalign \
		--redefine-sym __wrap_valloc=valloc \
		$(litemalloc) lite-malloc-shared.o
	$(CXX) $(LFLAGS) lite-malloc-shared.o -shared -o $(SHARED_LIB)

clean:
	-rm -f $(litemalloc) lite-malloc-shared.o $(STATIC_LIB) $(SHARED_LIB)
