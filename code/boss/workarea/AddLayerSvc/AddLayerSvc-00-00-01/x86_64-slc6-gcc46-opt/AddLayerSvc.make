#-- start of make_header -----------------

#====================================
#  Library AddLayerSvc
#
#   Generated Mon Dec  5 00:08:10 2022  by yuansc
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
#-- start of libary ----------------------

AddLayerSvcLIB :: $(AddLayerSvclib) $(AddLayerSvcshstamp)
	$(echo) "AddLayerSvc : library ok"

$(AddLayerSvclib) :: $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o
	$(lib_echo) "static library $@"
	$(lib_silent) [ ! -f $@ ] || \rm -f $@
	$(lib_silent) $(ar) $(AddLayerSvclib) $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o
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

#
# We add one level of dependency upon the true shared library 
# (rather than simply upon the stamp file)
# this is for cases where the shared library has not been built
# while the stamp was created (error??) 
#

$(AddLayerSvclibname).$(shlibsuffix) :: $(AddLayerSvclib) requirements $(use_requirements) $(AddLayerSvcstamps)
	$(lib_echo) "shared library $@"
	$(lib_silent) if test "$(makecmd)"; then QUIET=; else QUIET=1; fi; QUIET=$${QUIET} bin="$(bin)" ld="$(shlibbuilder)" ldflags="$(shlibflags)" suffix=$(shlibsuffix) libprefix=$(library_prefix) libsuffix=$(library_suffix) $(make_shlib) "$(tags)" AddLayerSvc $(AddLayerSvc_shlibflags)

$(AddLayerSvcshstamp) :: $(AddLayerSvclibname).$(shlibsuffix)
	$(lib_silent) if test -f $(AddLayerSvclibname).$(shlibsuffix) ; then cat /dev/null >$(AddLayerSvcshstamp) ; fi

AddLayerSvcclean ::
	$(cleanup_echo) objects AddLayerSvc
	$(cleanup_silent) /bin/rm -f $(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o
	$(cleanup_silent) /bin/rm -f $(patsubst %.o,%.d,$(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o) $(patsubst %.o,%.dep,$(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o) $(patsubst %.o,%.d.stamp,$(bin)AddLayerSvc.o $(bin)AddLayerSvc_load.o $(bin)AddLayerSvc_dll.o)
	$(cleanup_silent) cd $(bin); /bin/rm -rf AddLayerSvc_deps AddLayerSvc_dependencies.make

#-----------------------------------------------------------------
#
#  New section for automatic installation
#
#-----------------------------------------------------------------

install_dir = ${CMTINSTALLAREA}/$(tag)/lib
AddLayerSvcinstallname = $(library_prefix)AddLayerSvc$(library_suffix).$(shlibsuffix)

AddLayerSvc :: AddLayerSvcinstall ;

install :: AddLayerSvcinstall ;

AddLayerSvcinstall :: $(install_dir)/$(AddLayerSvcinstallname)
ifdef CMTINSTALLAREA
	$(echo) "installation done"
endif

$(install_dir)/$(AddLayerSvcinstallname) :: $(bin)$(AddLayerSvcinstallname)
ifdef CMTINSTALLAREA
	$(install_silent) $(cmt_install_action) \
	    -source "`(cd $(bin); pwd)`" \
	    -name "$(AddLayerSvcinstallname)" \
	    -out "$(install_dir)" \
	    -cmd "$(cmt_installarea_command)" \
	    -cmtpath "$($(package)_cmtpath)"
endif

##AddLayerSvcclean :: AddLayerSvcuninstall

uninstall :: AddLayerSvcuninstall ;

AddLayerSvcuninstall ::
ifdef CMTINSTALLAREA
	$(cleanup_silent) $(cmt_uninstall_action) \
	    -source "`(cd $(bin); pwd)`" \
	    -name "$(AddLayerSvcinstallname)" \
	    -out "$(install_dir)" \
	    -cmtpath "$($(package)_cmtpath)"
endif

#-- end of libary -----------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),AddLayerSvcclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)AddLayerSvc.d

$(bin)$(binobj)AddLayerSvc.d :

$(bin)$(binobj)AddLayerSvc.o : $(cmt_final_setup_AddLayerSvc)

$(bin)$(binobj)AddLayerSvc.o : $(src)AddLayerSvc.cc
	$(cpp_echo) $(src)AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags)  $(src)AddLayerSvc.cc
endif
endif

else
$(bin)AddLayerSvc_dependencies.make : $(AddLayerSvc_cc_dependencies)

$(bin)AddLayerSvc_dependencies.make : $(src)AddLayerSvc.cc

$(bin)$(binobj)AddLayerSvc.o : $(AddLayerSvc_cc_dependencies)
	$(cpp_echo) $(src)AddLayerSvc.cc
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(lib_AddLayerSvc_pp_cppflags) $(AddLayerSvc_pp_cppflags) $(use_cppflags) $(AddLayerSvc_cppflags) $(lib_AddLayerSvc_cppflags) $(AddLayerSvc_cppflags) $(AddLayerSvc_cc_cppflags)  $(src)AddLayerSvc.cc

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
