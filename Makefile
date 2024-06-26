#!/usr/bin/make -f
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#
# Author : Alan "ale-boud" Le Bouder <ale-boud@student.42lehavre.fr>
#
# Description of source tree :
# └── include
#     └── <header>.h
# └── src
#     └── <compilunit>.c
#
# After compilation :
# - $(OBJDIR) contain all object files and gcc generated dependencies
# - $(OUTDIR) contain the executable
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# Default target
all: all-irc
bonus: all

# Include vars and msg module
include Makefile.vars Makefile.msg

# ---
# General targets
# ---

# Mostly clean (clean everything but the end result)

clean: 
	$(call rmsg,Removing the object folder ($(OBJDIR)))
	$(call qcmd,$(RM) -rf $(OBJDIR))

mclean: clean

# Clean everything

fclean: clean cleandoc
ifneq ($(OUTDIR),.)
	$(call rmsg,Removing the output binary folder ($(OUTDIR)))
	$(call qcmd,$(RM) -rf $(OUTDIR))
else
	$(call rmsg,Removing the output binary ($(BIN_PATH)))
	$(call qcmd,$(RM) -f $(BIN_PATH))
endif

# Clean libs

cleanlibs: $(LIBS_CLEAN_RULE)
	$(call rmsg,Clean libs ($(LIBS)))

# Fclean libs

fcleanlibs: cleanlibs $(LIBS_FCLEAN_RULE)
	$(call rmsg,Fclean libs ($(LIBS)))

# To original state

mrproper: fclean fcleanlibs cleandoc
	$(call rmsg,Removing the configuration file (Makefile.cfg))
	$(call qcmd,$(RM) -rf Makefile.cfg)

# Remake everything

re: fclean all

# Make the doxygen documentation

all-doc: doc/Doxyfile
	$(call bcmd,doxygen,$<,doxygen $<)

# Clean the doxygen documentation

cleandoc:
	$(call rmsg,Removing the documentation (doc/html doc/man))
	$(call qcmd,$(RM) -rf doc/html doc/man)

.PHONY: all clean mclean fclean cleanlibs fcleanlibs mrproper re all-doc \
	cleandoc bonus

# ---
# Check configuration
# ---

Makefile.cfg:
	$(call emsg,Makefile.cfg missing did you "./configure.sh")
	@exit 1

# ---
# Build targets
# ---

all-irc: $(LIBS_MAKE_RULE) $(BIN_PATH)

# Make the binary

$(BIN_PATH): $(OBJS)
	$(call qcmd,$(MKDIR) -p $(@D))
	$(call bcmd,ld,$(OBJS),$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LD_LIBS))

# Make objects

$(OBJDIR)/%.c.o: $(SRCDIR)/%.c
	$(call qcmd,$(MKDIR) -p $(@D))
	$(call bcmd,cc,$<,$(CC) -c $(CFLAGS) -o $@ $<)

$(OBJDIR)/%.cpp.o: $(SRCDIR)/%.cpp
	$(call qcmd,$(MKDIR) -p $(@D))
	$(call bcmd,cc,$<,$(CXX) -c $(CXXFLAGS) -o $@ $<)

# Make object ressources

$(OBJDIR)/%.res.o: $(RESDIR)/%
	$(call qcmd,$(MKDIR) -p $(@D))
	$(call bcmd,ld,$<,ld --format=binary -r $< -o $@)

# Include generated dep by cc

-include $(DEPS)

.PHONY: all-minirt norminette

norminette:
	@find $(INCDIR) $(SRCDIR) \( -type f -name \*.c -or -name \*.h \) -exec norminette {} \;	\
		| grep -Ev '^Notice|OK!$$'																\
	&& $(ECHO) -e '\033[1;31mNorminette KO!'													\
	|| $(ECHO) -e '\033[1;32mNorminette OK!'
