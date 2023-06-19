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

CXXFLAGS += -std=c++11

#extra libraries if required
LIBS :=

LDLIBS := -lncurses -lboost_serialization -lboost_filesystem

#each module will add to this
SRC :=

#include the description for
# each module
include $(patsubst %,%/module.mk,$(MODULES))

DEP := $(patsubst %.cpp,%.d,$(SRC))

#determine the object files
OBJ := $(patsubst %.cpp,%.o,$(filter %.cpp,$(SRC)))

PROG := ahack

ENV := env.out

.PHONY: all release_compile release debug_compile debug

release: release_compile

release_compile: CXXFLAGS += -O2
release_compile: all

debug: debug_compile

debug_compile: CXXFLAGS += -O0 -g3
debug_compile: all

all: $(PROG)

#link the program
$(PROG): $(OBJ) $(ENV)
	$(CXX) $(LDFLAGS) $(filter %.o,$^) $(LOADLIBES) $(LDLIBS) -o $@

$(OBJ): $(ENV)

tmp.env:
	@env | grep -e ^CXX > $@
	@echo "CXXFLAGS=$(CXXFLAGS)" > $@

$(ENV): tmp.env
	@test -f $@ || cp $< $@
	@diff $@ $< || cp $< $@
	@rm $<

#include the C include dependencies (only for non-clean targets)
ifeq (,$(findstring clean,$(MAKECMDGOALS)))
include $(OBJ:.o=.d)
endif

#calculate C include
# dependencies
%.d: %.cpp
	echo $(shell dirname $@)/$(shell $(CXX) $(CXXFLAGS) -MM -MG "$<") > $@

clean:
	rm -f $(OBJ)

distclean:
	rm -f $(PROG) $(ENV)

depclean:
	rm -f $(DEP)
