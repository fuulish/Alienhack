MODULES := src/Console \
	   src/Console/Interface \
	   src/Model \
	   src/Model/Actions \
	   src/Model/Objects
#look for include files in
# each of the modules
CXXFLAGS += $(patsubst %,-I%,$(MODULES))

#extra libraries if required
LIBS :=

#each module will add to this
SRC :=

#include the description for
# each module
include $(patsubst %,%/module.mk,$(MODULES))

#determine the object files
OBJ := $(patsubst %.cpp,%.o,$(filter %.cpp,$(SRC)))

#link the program

prog: $(OBJ)

$(OBJ):

#include the C include
# dependencies
include $(OBJ:.o=.d)

#calculate C include
# dependencies
%.d: %.cpp
	./depend.sh ‘dirname $*.cpp‘ $(CFLAGS) $*.cpp > $@
