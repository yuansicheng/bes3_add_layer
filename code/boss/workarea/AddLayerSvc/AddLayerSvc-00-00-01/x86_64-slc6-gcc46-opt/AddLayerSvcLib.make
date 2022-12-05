#-- start of make_header -----------------

#====================================
#  Library AddLayerSvcLib
#
#   Generated Tue Dec  6 00:33:14 2022  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_AddLayerSvcLib_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_AddLayerSvcLib_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_AddLayerSvcLib

AddLayerSvc_tag = $(tag)

#cmt_local_tagfile_AddLayerSvcLib = $(AddLayerSvc_tag)_AddLayerSvcLib.make
cmt_local_tagfile_AddLayerSvcLib = $(bin)$(AddLayerSvc_tag)_AddLayerSvcLib.make

else

tags      = $(tag),$(CMTEXTRATAGS)

AddLayerSvc_tag = $(tag)

#cmt_local_tagfile_AddLayerSvcLib = $(AddLayerSvc_tag).make
cmt_local_tagfile_AddLayerSvcLib = $(bin)$(AddLayerSvc_tag).make

endif

include $(cmt_local_tagfile_AddLayerSvcLib)
#-include $(cmt_local_tagfile_AddLayerSvcLib)

ifdef cmt_AddLayerSvcLib_has_target_tag

cmt_final_setup_AddLayerSvcLib = $(bin)setup_AddLayerSvcLib.make
cmt_dependencies_in_AddLayerSvcLib = $(bin)dependencies_AddLayerSvcLib.in
#cmt_final_setup_AddLayerSvcLib = $(bin)AddLayerSvc_AddLayerSvcLibsetup.make
cmt_local_AddLayerSvcLib_makefile = $(bin)AddLayerSvcLib.make

else

cmt_final_setup_AddLayerSvcLib = $(bin)setup.make
cmt_dependencies_in_AddLayerSvcLib = $(bin)dependencies.in
#cmt_final_setup_AddLayerSvcLib = $(bin)AddLayerSvcsetup.make
cmt_local_AddLayerSvcLib_makefile = $(bin)AddLayerSvcLib.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)AddLayerSvcsetup.make

#AddLayerSvcLib :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'AddLayerSvcLib'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = AddLayerSvcLib/
#AddLayerSvcLib::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

AddLayerSvcLiblibname   = $(bin)$(library_prefix)AddLayerSvcLib$(library_suffix)
AddLayerSvcLiblib       = $(AddLayerSvcLiblibname).a
AddLayerSvcLibstamp     = $(bin)AddLayerSvcLib.stamp
AddLayerSvcLibshstamp   = $(bin)AddLayerSvcLib.shstamp

AddLayerSvcLib :: dirs  AddLayerSvcLibLIB
	$(echo) "AddLayerSvcLib ok"

#-- end of libary_header ----------------

AddLayerSvcLibLIB :: $(AddLayerSvcLiblib) $(AddLayerSvcLibshstamp)
	@/bin/echo "------> AddLayerSvcLib : library ok"

$(AddLayerSvcLiblib) :: $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o
	$(lib_echo) library
	$(lib_silent) cd $(bin); \
	  $(ar) $(AddLayerSvcLiblib) $?
	$(lib_silent) $(ranlib) $(AddLayerSvcLiblib)
	$(lib_silent) cat /dev/null >$(AddLayerSvcLibstamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

$(AddLayerSvcLiblibname).$(shlibsuffix) :: $(AddLayerSvcLiblib) $(AddLayerSvcLibstamps)
	$(lib_silent) cd $(bin); QUIET=$(QUIET); $(make_shlib) "$(tags)" AddLayerSvcLib $(AddLayerSvcLib_shlibflags)

$(AddLayerSvcLibshstamp) :: $(AddLayerSvcLiblibname).$(shlibsuffix)
	@if test -f $(AddLayerSvcLiblibname).$(shlibsuffix) ; then cat /dev/null >$(AddLayerSvcLibshstamp) ; fi

AddLayerSvcLibclean ::
	$(cleanup_echo) objects
	$(cleanup_silent) cd $(bin); /bin/rm -f $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o

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
AddLayerSvcLibinstallname = $(library_prefix)AddLayerSvcLib$(library_suffix).$(shlibsuffix)

AddLayerSvcLib :: AddLayerSvcLibinstall

install :: AddLayerSvcLibinstall

AddLayerSvcLibinstall :: $(install_dir)/$(AddLayerSvcLibinstallname)
	@if test ! "${installarea}" = ""; then\
	  echo "installation done"; \
	fi

$(install_dir)/$(AddLayerSvcLibinstallname) :: $(bin)$(AddLayerSvcLibinstallname)
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test ! -d "$(install_dir)"; then \
	      mkdir -p $(install_dir); \
	    fi ; \
	    if test -d "$(install_dir)"; then \
	      echo "Installing library $(AddLayerSvcLibinstallname) into $(install_dir)"; \
	      if test -e $(install_dir)/$(AddLayerSvcLibinstallname); then \
	        $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcLibinstallname); \
	        $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcLibinstallname).cmtref; \
	      fi; \
	      $(cmt_install_area_command) `pwd`/$(AddLayerSvcLibinstallname) $(install_dir)/$(AddLayerSvcLibinstallname); \
	      echo `pwd`/$(AddLayerSvcLibinstallname) >$(install_dir)/$(AddLayerSvcLibinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot install library $(AddLayerSvcLibinstallname), no installation directory specified"; \
	  fi; \
	fi

AddLayerSvcLibclean :: AddLayerSvcLibuninstall

uninstall :: AddLayerSvcLibuninstall

AddLayerSvcLibuninstall ::
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test -d "$(install_dir)"; then \
	      echo "Removing installed library $(AddLayerSvcLibinstallname) from $(install_dir)"; \
	      $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcLibinstallname); \
	      $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcLibinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot uninstall library $(AddLayerSvcLibinstallname), no installation directory specified"; \
	  fi; \
	fi




#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcLibclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc.d

$(bin)$(binobj)AddLayerSvc.d :

$(bin)$(binobj)AddLayerSvc.o : $(cmt_final_setup_AddLayerSvcLib)

$(bin)$(binobj)AddLayerSvc.o : $(src)AddLayerSvc.cc
	$(cpp_echo) $(src)AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags)  $(src)AddLayerSvc.cc
endif
endif

else
$(bin)AddLayerSvcLib_dependencies.make : $(AddLayerSvc_cc_dependencies)

$(bin)AddLayerSvcLib_dependencies.make : $(src)AddLayerSvc.cc

$(bin)$(binobj)AddLayerSvc.o : $(AddLayerSvc_cc_dependencies)
	$(cpp_echo) $(src)AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags)  $(src)AddLayerSvc.cc

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcLibclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc_load.d

$(bin)$(binobj)AddLayerSvc_load.d :

$(bin)$(binobj)AddLayerSvc_load.o : $(cmt_final_setup_AddLayerSvcLib)

$(bin)$(binobj)AddLayerSvc_load.o : $(src)components/AddLayerSvc_load.cc
	$(cpp_echo) $(src)components/AddLayerSvc_load.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_load_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_load_cppflags) $(AddLayerSvc_load_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_load.cc
endif
endif

else
$(bin)AddLayerSvcLib_dependencies.make : $(AddLayerSvc_load_cc_dependencies)

$(bin)AddLayerSvcLib_dependencies.make : $(src)components/AddLayerSvc_load.cc

$(bin)$(binobj)AddLayerSvc_load.o : $(AddLayerSvc_load_cc_dependencies)
	$(cpp_echo) $(src)components/AddLayerSvc_load.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_load_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_load_cppflags) $(AddLayerSvc_load_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_load.cc

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcLibclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc_dll.d

$(bin)$(binobj)AddLayerSvc_dll.d :

$(bin)$(binobj)AddLayerSvc_dll.o : $(cmt_final_setup_AddLayerSvcLib)

$(bin)$(binobj)AddLayerSvc_dll.o : $(src)components/AddLayerSvc_dll.cc
	$(cpp_echo) $(src)components/AddLayerSvc_dll.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_dll_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_dll_cppflags) $(AddLayerSvc_dll_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_dll.cc
endif
endif

else
$(bin)AddLayerSvcLib_dependencies.make : $(AddLayerSvc_dll_cc_dependencies)

$(bin)AddLayerSvcLib_dependencies.make : $(src)components/AddLayerSvc_dll.cc

$(bin)$(binobj)AddLayerSvc_dll.o : $(AddLayerSvc_dll_cc_dependencies)
	$(cpp_echo) $(src)components/AddLayerSvc_dll.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvcLib_pp_cppflags) $(lib_AddLayerSvcLib_pp_cppflags) $(AddLayerSvc_dll_pp_cppflags) $(use_cppflags) $(AddLayerSvcLib_cppflags) $(lib_AddLayerSvcLib_cppflags) $(AddLayerSvc_dll_cppflags) $(AddLayerSvc_dll_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_dll.cc

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: AddLayerSvcLibclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(AddLayerSvcLib.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

AddLayerSvcLibclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library AddLayerSvcLib
	-$(cleanup_silent) cd $(bin); /bin/rm -f $(library_prefix)AddLayerSvcLib$(library_suffix).a $(library_prefix)AddLayerSvcLib$(library_suffix).s? AddLayerSvcLib.stamp AddLayerSvcLib.shstamp
#-- end of cleanup_library ---------------
