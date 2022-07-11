MODULES := RL-Shared/ActionEngine \
           RL-Shared/Algorithm \
           RL-Shared/Console \
           RL-Shared/ConsoleView \
           RL-Shared/Game \
           RL-Shared/Interface \
           RL-Shared/Messages/Console \
           RL-Shared/Messages \
           RL-Shared/World-2DTiles/BSPMapGeneration \
           RL-Shared/World-2DTiles \
           RL-Shared/WorldObjects \
           RL-Shared/World-2DTiles/permissive-fov \
           src/Console \
           src/Console/Interface \
           src/Model \
           src/Model/Actions \
           src/Model/Objects

INC := -IRL-Shared
#look for include files in
# each of the modules
CXXFLAGS += $(patsubst %,-I%,$(MODULES))
CXXFLAGS += $(INC)

#extra libraries if required
LIBS :=

LDLIBS := -lncurses -ltinfo -lboost_serialization -lboost_filesystem

#each module will add to this
SRC :=

#include the description for
# each module
include $(patsubst %,%/module.mk,$(MODULES))

DEP := $(patsubst %.cpp,%.d,$(SRC))

#determine the object files
OBJ := $(patsubst %.cpp,%.o,$(filter %.cpp,$(SRC)))

PROG := prog

#link the program

$(PROG): $(OBJ)
	$(CXX) $(LDFLAGS) $^ $(LOADLIBES) $(LDLIBS) -o $@

$(OBJ):

#include the C include
# dependencies
include $(OBJ:.o=.d)

#calculate C include
# dependencies
%.d: %.cpp
	./depend.sh 'dirname $*.cpp' $(CFLAGS) $*.cpp > $@

clean:
	rm -f $(OBJ)

distclean:
	rm -f $(PROG)

depclean:
	rm -f $(DEP)
