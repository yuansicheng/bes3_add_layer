#-- start of make_header -----------------

#====================================
#  Library ExtractRecInfo
#
#   Generated Wed Jan 18 23:25:08 2023  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_ExtractRecInfo_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_ExtractRecInfo_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_ExtractRecInfo

ExtractRecInfo_tag = $(tag)

#cmt_local_tagfile_ExtractRecInfo = $(ExtractRecInfo_tag)_ExtractRecInfo.make
cmt_local_tagfile_ExtractRecInfo = $(bin)$(ExtractRecInfo_tag)_ExtractRecInfo.make

else

tags      = $(tag),$(CMTEXTRATAGS)

ExtractRecInfo_tag = $(tag)

#cmt_local_tagfile_ExtractRecInfo = $(ExtractRecInfo_tag).make
cmt_local_tagfile_ExtractRecInfo = $(bin)$(ExtractRecInfo_tag).make

endif

include $(cmt_local_tagfile_ExtractRecInfo)
#-include $(cmt_local_tagfile_ExtractRecInfo)

ifdef cmt_ExtractRecInfo_has_target_tag

cmt_final_setup_ExtractRecInfo = $(bin)setup_ExtractRecInfo.make
cmt_dependencies_in_ExtractRecInfo = $(bin)dependencies_ExtractRecInfo.in
#cmt_final_setup_ExtractRecInfo = $(bin)ExtractRecInfo_ExtractRecInfosetup.make
cmt_local_ExtractRecInfo_makefile = $(bin)ExtractRecInfo.make

else

cmt_final_setup_ExtractRecInfo = $(bin)setup.make
cmt_dependencies_in_ExtractRecInfo = $(bin)dependencies.in
#cmt_final_setup_ExtractRecInfo = $(bin)ExtractRecInfosetup.make
cmt_local_ExtractRecInfo_makefile = $(bin)ExtractRecInfo.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)ExtractRecInfosetup.make

#ExtractRecInfo :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'ExtractRecInfo'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = ExtractRecInfo/
#ExtractRecInfo::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

ExtractRecInfolibname   = $(bin)$(library_prefix)ExtractRecInfo$(library_suffix)
ExtractRecInfolib       = $(ExtractRecInfolibname).a
ExtractRecInfostamp     = $(bin)ExtractRecInfo.stamp
ExtractRecInfoshstamp   = $(bin)ExtractRecInfo.shstamp

ExtractRecInfo :: dirs  ExtractRecInfoLIB
	$(echo) "ExtractRecInfo ok"

#-- end of libary_header ----------------

ExtractRecInfoLIB :: $(ExtractRecInfolib) $(ExtractRecInfoshstamp)
	@/bin/echo "------> ExtractRecInfo : library ok"

$(ExtractRecInfolib) :: $(bin)extract_single_particle.o $(bin)ExtractRecInfo_entries.o $(bin)ExtractRecInfo_load.o
	$(lib_echo) library
	$(lib_silent) cd $(bin); \
	  $(ar) $(ExtractRecInfolib) $?
	$(lib_silent) $(ranlib) $(ExtractRecInfolib)
	$(lib_silent) cat /dev/null >$(ExtractRecInfostamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

$(ExtractRecInfolibname).$(shlibsuffix) :: $(ExtractRecInfolib) $(ExtractRecInfostamps)
	$(lib_silent) cd $(bin); QUIET=$(QUIET); $(make_shlib) "$(tags)" ExtractRecInfo $(ExtractRecInfo_shlibflags)

$(ExtractRecInfoshstamp) :: $(ExtractRecInfolibname).$(shlibsuffix)
	@if test -f $(ExtractRecInfolibname).$(shlibsuffix) ; then cat /dev/null >$(ExtractRecInfoshstamp) ; fi

ExtractRecInfoclean ::
	$(cleanup_echo) objects
	$(cleanup_silent) cd $(bin); /bin/rm -f $(bin)extract_single_particle.o $(bin)ExtractRecInfo_entries.o $(bin)ExtractRecInfo_load.o

#-----------------------------------------------------------------
#
#  New section for automatic installation
#
#-----------------------------------------------------------------

ifeq ($(INSTALLAREA),)
installarea = $(CMTINSTALLAREA)
else
ifeq ($(findstring `,$(INSTALLAREA)),`)
installarea = $(shell $(subst `,, $(INSTALLAREA)))
else
installarea = $(INSTALLAREA)
endif
endif

install_dir = ${installarea}/${CMTCONFIG}/lib
ExtractRecInfoinstallname = $(library_prefix)ExtractRecInfo$(library_suffix).$(shlibsuffix)

ExtractRecInfo :: ExtractRecInfoinstall

install :: ExtractRecInfoinstall

ExtractRecInfoinstall :: $(install_dir)/$(ExtractRecInfoinstallname)
	@if test ! "${installarea}" = ""; then\
	  echo "installation done"; \
	fi

$(install_dir)/$(ExtractRecInfoinstallname) :: $(bin)$(ExtractRecInfoinstallname)
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test ! -d "$(install_dir)"; then \
	      mkdir -p $(install_dir); \
	    fi ; \
	    if test -d "$(install_dir)"; then \
	      echo "Installing library $(ExtractRecInfoinstallname) into $(install_dir)"; \
	      if test -e $(install_dir)/$(ExtractRecInfoinstallname); then \
	        $(cmt_uninstall_area_command) $(install_dir)/$(ExtractRecInfoinstallname); \
	        $(cmt_uninstall_area_command) $(install_dir)/$(ExtractRecInfoinstallname).cmtref; \
	      fi; \
	      $(cmt_install_area_command) `pwd`/$(ExtractRecInfoinstallname) $(install_dir)/$(ExtractRecInfoinstallname); \
	      echo `pwd`/$(ExtractRecInfoinstallname) >$(install_dir)/$(ExtractRecInfoinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot install library $(ExtractRecInfoinstallname), no installation directory specified"; \
	  fi; \
	fi

ExtractRecInfoclean :: ExtractRecInfouninstall

uninstall :: ExtractRecInfouninstall

ExtractRecInfouninstall ::
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test -d "$(install_dir)"; then \
	      echo "Removing installed library $(ExtractRecInfoinstallname) from $(install_dir)"; \
	      $(cmt_uninstall_area_command) $(install_dir)/$(ExtractRecInfoinstallname); \
	      $(cmt_uninstall_area_command) $(install_dir)/$(ExtractRecInfoinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot uninstall library $(ExtractRecInfoinstallname), no installation directory specified"; \
	  fi; \
	fi




#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),ExtractRecInfoclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)extract_single_particle.d

$(bin)$(binobj)extract_single_particle.d :

$(bin)$(binobj)extract_single_particle.o : $(cmt_final_setup_ExtractRecInfo)

$(bin)$(binobj)extract_single_particle.o : $(src)extract_single_particle.cxx
	$(cpp_echo) $(src)extract_single_particle.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(extract_single_particle_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(extract_single_particle_cppflags) $(extract_single_particle_cxx_cppflags)  $(src)extract_single_particle.cxx
endif
endif

else
$(bin)ExtractRecInfo_dependencies.make : $(extract_single_particle_cxx_dependencies)

$(bin)ExtractRecInfo_dependencies.make : $(src)extract_single_particle.cxx

$(bin)$(binobj)extract_single_particle.o : $(extract_single_particle_cxx_dependencies)
	$(cpp_echo) $(src)extract_single_particle.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(extract_single_particle_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(extract_single_particle_cppflags) $(extract_single_particle_cxx_cppflags)  $(src)extract_single_particle.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),ExtractRecInfoclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)ExtractRecInfo_entries.d

$(bin)$(binobj)ExtractRecInfo_entries.d :

$(bin)$(binobj)ExtractRecInfo_entries.o : $(cmt_final_setup_ExtractRecInfo)

$(bin)$(binobj)ExtractRecInfo_entries.o : $(src)components/ExtractRecInfo_entries.cxx
	$(cpp_echo) $(src)components/ExtractRecInfo_entries.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(ExtractRecInfo_entries_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(ExtractRecInfo_entries_cppflags) $(ExtractRecInfo_entries_cxx_cppflags) -I../src/components $(src)components/ExtractRecInfo_entries.cxx
endif
endif

else
$(bin)ExtractRecInfo_dependencies.make : $(ExtractRecInfo_entries_cxx_dependencies)

$(bin)ExtractRecInfo_dependencies.make : $(src)components/ExtractRecInfo_entries.cxx

$(bin)$(binobj)ExtractRecInfo_entries.o : $(ExtractRecInfo_entries_cxx_dependencies)
	$(cpp_echo) $(src)components/ExtractRecInfo_entries.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(ExtractRecInfo_entries_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(ExtractRecInfo_entries_cppflags) $(ExtractRecInfo_entries_cxx_cppflags) -I../src/components $(src)components/ExtractRecInfo_entries.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),ExtractRecInfoclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)ExtractRecInfo_load.d

$(bin)$(binobj)ExtractRecInfo_load.d :

$(bin)$(binobj)ExtractRecInfo_load.o : $(cmt_final_setup_ExtractRecInfo)

$(bin)$(binobj)ExtractRecInfo_load.o : $(src)components/ExtractRecInfo_load.cxx
	$(cpp_echo) $(src)components/ExtractRecInfo_load.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(ExtractRecInfo_load_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(ExtractRecInfo_load_cppflags) $(ExtractRecInfo_load_cxx_cppflags) -I../src/components $(src)components/ExtractRecInfo_load.cxx
endif
endif

else
$(bin)ExtractRecInfo_dependencies.make : $(ExtractRecInfo_load_cxx_dependencies)

$(bin)ExtractRecInfo_dependencies.make : $(src)components/ExtractRecInfo_load.cxx

$(bin)$(binobj)ExtractRecInfo_load.o : $(ExtractRecInfo_load_cxx_dependencies)
	$(cpp_echo) $(src)components/ExtractRecInfo_load.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(ExtractRecInfo_pp_cppflags) $(lib_ExtractRecInfo_pp_cppflags) $(ExtractRecInfo_load_pp_cppflags) $(use_cppflags) $(ExtractRecInfo_cppflags) $(lib_ExtractRecInfo_cppflags) $(ExtractRecInfo_load_cppflags) $(ExtractRecInfo_load_cxx_cppflags) -I../src/components $(src)components/ExtractRecInfo_load.cxx

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: ExtractRecInfoclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(ExtractRecInfo.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

ExtractRecInfoclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library ExtractRecInfo
	-$(cleanup_silent) cd $(bin); /bin/rm -f $(library_prefix)ExtractRecInfo$(library_suffix).a $(library_prefix)ExtractRecInfo$(library_suffix).s? ExtractRecInfo.stamp ExtractRecInfo.shstamp
#-- end of cleanup_library ---------------
