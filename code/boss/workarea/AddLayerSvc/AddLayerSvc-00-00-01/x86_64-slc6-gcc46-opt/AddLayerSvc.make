#-- start of make_header -----------------

#====================================
#  Library AddLayerSvc
#
#   Generated Fri Jan 13 16:44:29 2023  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_AddLayerSvc_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_AddLayerSvc_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_AddLayerSvc

AddLayerSvc_tag = $(tag)

#cmt_local_tagfile_AddLayerSvc = $(AddLayerSvc_tag)_AddLayerSvc.make
cmt_local_tagfile_AddLayerSvc = $(bin)$(AddLayerSvc_tag)_AddLayerSvc.make

else

tags      = $(tag),$(CMTEXTRATAGS)

AddLayerSvc_tag = $(tag)

#cmt_local_tagfile_AddLayerSvc = $(AddLayerSvc_tag).make
cmt_local_tagfile_AddLayerSvc = $(bin)$(AddLayerSvc_tag).make

endif

include $(cmt_local_tagfile_AddLayerSvc)
#-include $(cmt_local_tagfile_AddLayerSvc)

ifdef cmt_AddLayerSvc_has_target_tag

cmt_final_setup_AddLayerSvc = $(bin)setup_AddLayerSvc.make
cmt_dependencies_in_AddLayerSvc = $(bin)dependencies_AddLayerSvc.in
#cmt_final_setup_AddLayerSvc = $(bin)AddLayerSvc_AddLayerSvcsetup.make
cmt_local_AddLayerSvc_makefile = $(bin)AddLayerSvc.make

else

cmt_final_setup_AddLayerSvc = $(bin)setup.make
cmt_dependencies_in_AddLayerSvc = $(bin)dependencies.in
#cmt_final_setup_AddLayerSvc = $(bin)AddLayerSvcsetup.make
cmt_local_AddLayerSvc_makefile = $(bin)AddLayerSvc.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)AddLayerSvcsetup.make

#AddLayerSvc :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'AddLayerSvc'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = AddLayerSvc/
#AddLayerSvc::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

AddLayerSvclibname   = $(bin)$(library_prefix)AddLayerSvc$(library_suffix)
AddLayerSvclib       = $(AddLayerSvclibname).a
AddLayerSvcstamp     = $(bin)AddLayerSvc.stamp
AddLayerSvcshstamp   = $(bin)AddLayerSvc.shstamp

AddLayerSvc :: dirs  AddLayerSvcLIB
	$(echo) "AddLayerSvc ok"

#-- end of libary_header ----------------

AddLayerSvcLIB :: $(AddLayerSvclib) $(AddLayerSvcshstamp)
	@/bin/echo "------> AddLayerSvc : library ok"

$(AddLayerSvclib) :: $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o
	$(lib_echo) library
	$(lib_silent) cd $(bin); \
	  $(ar) $(AddLayerSvclib) $?
	$(lib_silent) $(ranlib) $(AddLayerSvclib)
	$(lib_silent) cat /dev/null >$(AddLayerSvcstamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

$(AddLayerSvclibname).$(shlibsuffix) :: $(AddLayerSvclib) $(AddLayerSvcstamps)
	$(lib_silent) cd $(bin); QUIET=$(QUIET); $(make_shlib) "$(tags)" AddLayerSvc $(AddLayerSvc_shlibflags)

$(AddLayerSvcshstamp) :: $(AddLayerSvclibname).$(shlibsuffix)
	@if test -f $(AddLayerSvclibname).$(shlibsuffix) ; then cat /dev/null >$(AddLayerSvcshstamp) ; fi

AddLayerSvcclean ::
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
AddLayerSvcinstallname = $(library_prefix)AddLayerSvc$(library_suffix).$(shlibsuffix)

AddLayerSvc :: AddLayerSvcinstall

install :: AddLayerSvcinstall

AddLayerSvcinstall :: $(install_dir)/$(AddLayerSvcinstallname)
	@if test ! "${installarea}" = ""; then\
	  echo "installation done"; \
	fi

$(install_dir)/$(AddLayerSvcinstallname) :: $(bin)$(AddLayerSvcinstallname)
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test ! -d "$(install_dir)"; then \
	      mkdir -p $(install_dir); \
	    fi ; \
	    if test -d "$(install_dir)"; then \
	      echo "Installing library $(AddLayerSvcinstallname) into $(install_dir)"; \
	      if test -e $(install_dir)/$(AddLayerSvcinstallname); then \
	        $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcinstallname); \
	        $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcinstallname).cmtref; \
	      fi; \
	      $(cmt_install_area_command) `pwd`/$(AddLayerSvcinstallname) $(install_dir)/$(AddLayerSvcinstallname); \
	      echo `pwd`/$(AddLayerSvcinstallname) >$(install_dir)/$(AddLayerSvcinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot install library $(AddLayerSvcinstallname), no installation directory specified"; \
	  fi; \
	fi

AddLayerSvcclean :: AddLayerSvcuninstall

uninstall :: AddLayerSvcuninstall

AddLayerSvcuninstall ::
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test -d "$(install_dir)"; then \
	      echo "Removing installed library $(AddLayerSvcinstallname) from $(install_dir)"; \
	      $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcinstallname); \
	      $(cmt_uninstall_area_command) $(install_dir)/$(AddLayerSvcinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot uninstall library $(AddLayerSvcinstallname), no installation directory specified"; \
	  fi; \
	fi




#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc.d

$(bin)$(binobj)AddLayerSvc.d :

$(bin)$(binobj)AddLayerSvc.o : $(cmt_final_setup_AddLayerSvc)

$(bin)$(binobj)AddLayerSvc.o : $(src)components/AddLayerSvc.cc
	$(cpp_echo) $(src)components/AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags) -I../src/components $(src)components/AddLayerSvc.cc
endif
endif

else
$(bin)AddLayerSvc_dependencies.make : $(AddLayerSvc_cc_dependencies)

$(bin)AddLayerSvc_dependencies.make : $(src)components/AddLayerSvc.cc

$(bin)$(binobj)AddLayerSvc.o : $(AddLayerSvc_cc_dependencies)
	$(cpp_echo) $(src)components/AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags) -I../src/components $(src)components/AddLayerSvc.cc

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc_load.d

$(bin)$(binobj)AddLayerSvc_load.d :

$(bin)$(binobj)AddLayerSvc_load.o : $(cmt_final_setup_AddLayerSvc)

$(bin)$(binobj)AddLayerSvc_load.o : $(src)components/AddLayerSvc_load.cc
	$(cpp_echo) $(src)components/AddLayerSvc_load.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_load_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_load_cppflags) $(AddLayerSvc_load_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_load.cc
endif
endif

else
$(bin)AddLayerSvc_dependencies.make : $(AddLayerSvc_load_cc_dependencies)

$(bin)AddLayerSvc_dependencies.make : $(src)components/AddLayerSvc_load.cc

$(bin)$(binobj)AddLayerSvc_load.o : $(AddLayerSvc_load_cc_dependencies)
	$(cpp_echo) $(src)components/AddLayerSvc_load.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_load_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_load_cppflags) $(AddLayerSvc_load_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_load.cc

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc_dll.d

$(bin)$(binobj)AddLayerSvc_dll.d :

$(bin)$(binobj)AddLayerSvc_dll.o : $(cmt_final_setup_AddLayerSvc)

$(bin)$(binobj)AddLayerSvc_dll.o : $(src)components/AddLayerSvc_dll.cc
	$(cpp_echo) $(src)components/AddLayerSvc_dll.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_dll_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_dll_cppflags) $(AddLayerSvc_dll_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_dll.cc
endif
endif

else
$(bin)AddLayerSvc_dependencies.make : $(AddLayerSvc_dll_cc_dependencies)

$(bin)AddLayerSvc_dependencies.make : $(src)components/AddLayerSvc_dll.cc

$(bin)$(binobj)AddLayerSvc_dll.o : $(AddLayerSvc_dll_cc_dependencies)
	$(cpp_echo) $(src)components/AddLayerSvc_dll.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_dll_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_dll_cppflags) $(AddLayerSvc_dll_cc_cppflags) -I../src/components $(src)components/AddLayerSvc_dll.cc

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: AddLayerSvcclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(AddLayerSvc.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

AddLayerSvcclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library AddLayerSvc
	-$(cleanup_silent) cd $(bin); /bin/rm -f $(library_prefix)AddLayerSvc$(library_suffix).a $(library_prefix)AddLayerSvc$(library_suffix).s? AddLayerSvc.stamp AddLayerSvc.shstamp
#-- end of cleanup_library ---------------
