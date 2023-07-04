CXXFLAGS=-Wall -O3 -g
OBJECTS=led-telemetry.o
BINARIES=led-telemetry

RGB_LIB_DISTRIBUTION=matrix
RGB_INCDIR=$(RGB_LIB_DISTRIBUTION)/include
RGB_LIBDIR=$(RGB_LIB_DISTRIBUTION)/lib
RGB_LIBRARY_NAME=rgbmatrix
RGB_LIBRARY=$(RGB_LIBDIR)/lib$(RGB_LIBRARY_NAME).a

LEDT_INCDIR=ledt-server/include
LEDT_LIBDIR=ledt-server/lib
LEDT_LIBRARY_NAME=led-telemetry-server
LEDT_LIBRARY=$(LEDT_LIBDIR)/lib$(LEDT_LIBRARY_NAME).a

LDFLAGS+=-L$(LEDT_LIBDIR) -l$(LEDT_LIBRARY_NAME) \
	 -L$(RGB_LIBDIR) -l$(RGB_LIBRARY_NAME) -lrt -lm -lpthread

all : led-telemetry

led-telemetry : $(OBJECTS) $(RGB_LIBRARY) $(LEDT_LIBRARY) 
	$(CXX) $(CXXFLAGS) $(OBJECTS) -o $@ $(LDFLAGS)

# (FYI: Make sure, there is a TAB-character in front of the $(MAKE))
$(RGB_LIBRARY):
	 $(MAKE) -C $(RGB_LIBDIR)

$(LEDT_LIBRARY):
	 $(MAKE) -C $(LEDT_LIBDIR)

led-telemetry.o : led-telemetry.cc

%.o : %.cc
	$(CXX) -I$(LEDT_INCDIR) -I$(RGB_INCDIR) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJECTS) $(BINARIES)
	$(MAKE) -C $(RGB_LIBDIR) clean
	$(MAKE) -C $(LEDT_LIBDIR) clean

FORCE:
.PHONY: FORCE
