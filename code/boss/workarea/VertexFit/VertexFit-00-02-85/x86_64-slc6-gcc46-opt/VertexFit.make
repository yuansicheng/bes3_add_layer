#-- start of make_header -----------------

#====================================
#  Library VertexFit
#
#   Generated Wed Jan 25 21:49:30 2023  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_VertexFit_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_VertexFit_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_VertexFit

VertexFit_tag = $(tag)

#cmt_local_tagfile_VertexFit = $(VertexFit_tag)_VertexFit.make
cmt_local_tagfile_VertexFit = $(bin)$(VertexFit_tag)_VertexFit.make

else

tags      = $(tag),$(CMTEXTRATAGS)

VertexFit_tag = $(tag)

#cmt_local_tagfile_VertexFit = $(VertexFit_tag).make
cmt_local_tagfile_VertexFit = $(bin)$(VertexFit_tag).make

endif

include $(cmt_local_tagfile_VertexFit)
#-include $(cmt_local_tagfile_VertexFit)

ifdef cmt_VertexFit_has_target_tag

cmt_final_setup_VertexFit = $(bin)setup_VertexFit.make
cmt_dependencies_in_VertexFit = $(bin)dependencies_VertexFit.in
#cmt_final_setup_VertexFit = $(bin)VertexFit_VertexFitsetup.make
cmt_local_VertexFit_makefile = $(bin)VertexFit.make

else

cmt_final_setup_VertexFit = $(bin)setup.make
cmt_dependencies_in_VertexFit = $(bin)dependencies.in
#cmt_final_setup_VertexFit = $(bin)VertexFitsetup.make
cmt_local_VertexFit_makefile = $(bin)VertexFit.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)VertexFitsetup.make

#VertexFit :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'VertexFit'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = VertexFit/
#VertexFit::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

VertexFitlibname   = $(bin)$(library_prefix)VertexFit$(library_suffix)
VertexFitlib       = $(VertexFitlibname).a
VertexFitstamp     = $(bin)VertexFit.stamp
VertexFitshstamp   = $(bin)VertexFit.shstamp

VertexFit :: dirs  VertexFitLIB
	$(echo) "VertexFit ok"

#-- end of libary_header ----------------

VertexFitLIB :: $(VertexFitlib) $(VertexFitshstamp)
	@/bin/echo "------> VertexFit : library ok"

$(VertexFitlib) :: $(bin)VertexDbSvc.o $(bin)KalmanVertexFit.o $(bin)HTrackParameter.o $(bin)Helix.o $(bin)TrackPool.o $(bin)WTrackParameter.o $(bin)VertexFit.o $(bin)BField.o $(bin)FastVertexFit.o $(bin)VertexParameter.o $(bin)KinematicFit.o $(bin)SecondVertexFit.o $(bin)GammaShape.o $(bin)KinematicConstraints.o $(bin)VertexConstraints.o $(bin)KalmanKinematicFit.o $(bin)VertexDbSvc_dll.o $(bin)VertexDbSvc_load.o $(bin)test_read.o
	$(lib_echo) library
	$(lib_silent) cd $(bin); \
	  $(ar) $(VertexFitlib) $?
	$(lib_silent) $(ranlib) $(VertexFitlib)
	$(lib_silent) cat /dev/null >$(VertexFitstamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

$(VertexFitlibname).$(shlibsuffix) :: $(VertexFitlib) $(VertexFitstamps)
	$(lib_silent) cd $(bin); QUIET=$(QUIET); $(make_shlib) "$(tags)" VertexFit $(VertexFit_shlibflags)

$(VertexFitshstamp) :: $(VertexFitlibname).$(shlibsuffix)
	@if test -f $(VertexFitlibname).$(shlibsuffix) ; then cat /dev/null >$(VertexFitshstamp) ; fi

VertexFitclean ::
	$(cleanup_echo) objects
	$(cleanup_silent) cd $(bin); /bin/rm -f $(bin)VertexDbSvc.o $(bin)KalmanVertexFit.o $(bin)HTrackParameter.o $(bin)Helix.o $(bin)TrackPool.o $(bin)WTrackParameter.o $(bin)VertexFit.o $(bin)BField.o $(bin)FastVertexFit.o $(bin)VertexParameter.o $(bin)KinematicFit.o $(bin)SecondVertexFit.o $(bin)GammaShape.o $(bin)KinematicConstraints.o $(bin)VertexConstraints.o $(bin)KalmanKinematicFit.o $(bin)VertexDbSvc_dll.o $(bin)VertexDbSvc_load.o $(bin)test_read.o

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
VertexFitinstallname = $(library_prefix)VertexFit$(library_suffix).$(shlibsuffix)

VertexFit :: VertexFitinstall

install :: VertexFitinstall

VertexFitinstall :: $(install_dir)/$(VertexFitinstallname)
	@if test ! "${installarea}" = ""; then\
	  echo "installation done"; \
	fi

$(install_dir)/$(VertexFitinstallname) :: $(bin)$(VertexFitinstallname)
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test ! -d "$(install_dir)"; then \
	      mkdir -p $(install_dir); \
	    fi ; \
	    if test -d "$(install_dir)"; then \
	      echo "Installing library $(VertexFitinstallname) into $(install_dir)"; \
	      if test -e $(install_dir)/$(VertexFitinstallname); then \
	        $(cmt_uninstall_area_command) $(install_dir)/$(VertexFitinstallname); \
	        $(cmt_uninstall_area_command) $(install_dir)/$(VertexFitinstallname).cmtref; \
	      fi; \
	      $(cmt_install_area_command) `pwd`/$(VertexFitinstallname) $(install_dir)/$(VertexFitinstallname); \
	      echo `pwd`/$(VertexFitinstallname) >$(install_dir)/$(VertexFitinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot install library $(VertexFitinstallname), no installation directory specified"; \
	  fi; \
	fi

VertexFitclean :: VertexFituninstall

uninstall :: VertexFituninstall

VertexFituninstall ::
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test -d "$(install_dir)"; then \
	      echo "Removing installed library $(VertexFitinstallname) from $(install_dir)"; \
	      $(cmt_uninstall_area_command) $(install_dir)/$(VertexFitinstallname); \
	      $(cmt_uninstall_area_command) $(install_dir)/$(VertexFitinstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot uninstall library $(VertexFitinstallname), no installation directory specified"; \
	  fi; \
	fi




#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexDbSvc.d

$(bin)$(binobj)VertexDbSvc.d :

$(bin)$(binobj)VertexDbSvc.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexDbSvc.o : $(src)VertexDbSvc.cxx
	$(cpp_echo) $(src)VertexDbSvc.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_cppflags) $(VertexDbSvc_cxx_cppflags)  $(src)VertexDbSvc.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexDbSvc_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)VertexDbSvc.cxx

$(bin)$(binobj)VertexDbSvc.o : $(VertexDbSvc_cxx_dependencies)
	$(cpp_echo) $(src)VertexDbSvc.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_cppflags) $(VertexDbSvc_cxx_cppflags)  $(src)VertexDbSvc.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalmanVertexFit.d

$(bin)$(binobj)KalmanVertexFit.d :

$(bin)$(binobj)KalmanVertexFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)KalmanVertexFit.o : $(src)KalmanVertexFit.cxx
	$(cpp_echo) $(src)KalmanVertexFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KalmanVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KalmanVertexFit_cppflags) $(KalmanVertexFit_cxx_cppflags)  $(src)KalmanVertexFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(KalmanVertexFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)KalmanVertexFit.cxx

$(bin)$(binobj)KalmanVertexFit.o : $(KalmanVertexFit_cxx_dependencies)
	$(cpp_echo) $(src)KalmanVertexFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KalmanVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KalmanVertexFit_cppflags) $(KalmanVertexFit_cxx_cppflags)  $(src)KalmanVertexFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)HTrackParameter.d

$(bin)$(binobj)HTrackParameter.d :

$(bin)$(binobj)HTrackParameter.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)HTrackParameter.o : $(src)HTrackParameter.cxx
	$(cpp_echo) $(src)HTrackParameter.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(HTrackParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(HTrackParameter_cppflags) $(HTrackParameter_cxx_cppflags)  $(src)HTrackParameter.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(HTrackParameter_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)HTrackParameter.cxx

$(bin)$(binobj)HTrackParameter.o : $(HTrackParameter_cxx_dependencies)
	$(cpp_echo) $(src)HTrackParameter.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(HTrackParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(HTrackParameter_cppflags) $(HTrackParameter_cxx_cppflags)  $(src)HTrackParameter.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)Helix.d

$(bin)$(binobj)Helix.d :

$(bin)$(binobj)Helix.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)Helix.o : $(src)Helix.cxx
	$(cpp_echo) $(src)Helix.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(Helix_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(Helix_cppflags) $(Helix_cxx_cppflags)  $(src)Helix.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(Helix_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)Helix.cxx

$(bin)$(binobj)Helix.o : $(Helix_cxx_dependencies)
	$(cpp_echo) $(src)Helix.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(Helix_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(Helix_cppflags) $(Helix_cxx_cppflags)  $(src)Helix.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)TrackPool.d

$(bin)$(binobj)TrackPool.d :

$(bin)$(binobj)TrackPool.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)TrackPool.o : $(src)TrackPool.cxx
	$(cpp_echo) $(src)TrackPool.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(TrackPool_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(TrackPool_cppflags) $(TrackPool_cxx_cppflags)  $(src)TrackPool.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(TrackPool_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)TrackPool.cxx

$(bin)$(binobj)TrackPool.o : $(TrackPool_cxx_dependencies)
	$(cpp_echo) $(src)TrackPool.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(TrackPool_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(TrackPool_cppflags) $(TrackPool_cxx_cppflags)  $(src)TrackPool.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)WTrackParameter.d

$(bin)$(binobj)WTrackParameter.d :

$(bin)$(binobj)WTrackParameter.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)WTrackParameter.o : $(src)WTrackParameter.cxx
	$(cpp_echo) $(src)WTrackParameter.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(WTrackParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(WTrackParameter_cppflags) $(WTrackParameter_cxx_cppflags)  $(src)WTrackParameter.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(WTrackParameter_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)WTrackParameter.cxx

$(bin)$(binobj)WTrackParameter.o : $(WTrackParameter_cxx_dependencies)
	$(cpp_echo) $(src)WTrackParameter.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(WTrackParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(WTrackParameter_cppflags) $(WTrackParameter_cxx_cppflags)  $(src)WTrackParameter.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexFit.d

$(bin)$(binobj)VertexFit.d :

$(bin)$(binobj)VertexFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexFit.o : $(src)VertexFit.cxx
	$(cpp_echo) $(src)VertexFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexFit_cppflags) $(VertexFit_cxx_cppflags)  $(src)VertexFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)VertexFit.cxx

$(bin)$(binobj)VertexFit.o : $(VertexFit_cxx_dependencies)
	$(cpp_echo) $(src)VertexFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexFit_cppflags) $(VertexFit_cxx_cppflags)  $(src)VertexFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)BField.d

$(bin)$(binobj)BField.d :

$(bin)$(binobj)BField.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)BField.o : $(src)BField.cxx
	$(cpp_echo) $(src)BField.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(BField_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(BField_cppflags) $(BField_cxx_cppflags)  $(src)BField.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(BField_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)BField.cxx

$(bin)$(binobj)BField.o : $(BField_cxx_dependencies)
	$(cpp_echo) $(src)BField.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(BField_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(BField_cppflags) $(BField_cxx_cppflags)  $(src)BField.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)FastVertexFit.d

$(bin)$(binobj)FastVertexFit.d :

$(bin)$(binobj)FastVertexFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)FastVertexFit.o : $(src)FastVertexFit.cxx
	$(cpp_echo) $(src)FastVertexFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(FastVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(FastVertexFit_cppflags) $(FastVertexFit_cxx_cppflags)  $(src)FastVertexFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(FastVertexFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)FastVertexFit.cxx

$(bin)$(binobj)FastVertexFit.o : $(FastVertexFit_cxx_dependencies)
	$(cpp_echo) $(src)FastVertexFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(FastVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(FastVertexFit_cppflags) $(FastVertexFit_cxx_cppflags)  $(src)FastVertexFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexParameter.d

$(bin)$(binobj)VertexParameter.d :

$(bin)$(binobj)VertexParameter.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexParameter.o : $(src)VertexParameter.cxx
	$(cpp_echo) $(src)VertexParameter.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexParameter_cppflags) $(VertexParameter_cxx_cppflags)  $(src)VertexParameter.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexParameter_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)VertexParameter.cxx

$(bin)$(binobj)VertexParameter.o : $(VertexParameter_cxx_dependencies)
	$(cpp_echo) $(src)VertexParameter.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexParameter_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexParameter_cppflags) $(VertexParameter_cxx_cppflags)  $(src)VertexParameter.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KinematicFit.d

$(bin)$(binobj)KinematicFit.d :

$(bin)$(binobj)KinematicFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)KinematicFit.o : $(src)KinematicFit.cxx
	$(cpp_echo) $(src)KinematicFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KinematicFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KinematicFit_cppflags) $(KinematicFit_cxx_cppflags)  $(src)KinematicFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(KinematicFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)KinematicFit.cxx

$(bin)$(binobj)KinematicFit.o : $(KinematicFit_cxx_dependencies)
	$(cpp_echo) $(src)KinematicFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KinematicFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KinematicFit_cppflags) $(KinematicFit_cxx_cppflags)  $(src)KinematicFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)SecondVertexFit.d

$(bin)$(binobj)SecondVertexFit.d :

$(bin)$(binobj)SecondVertexFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)SecondVertexFit.o : $(src)SecondVertexFit.cxx
	$(cpp_echo) $(src)SecondVertexFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(SecondVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(SecondVertexFit_cppflags) $(SecondVertexFit_cxx_cppflags)  $(src)SecondVertexFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(SecondVertexFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)SecondVertexFit.cxx

$(bin)$(binobj)SecondVertexFit.o : $(SecondVertexFit_cxx_dependencies)
	$(cpp_echo) $(src)SecondVertexFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(SecondVertexFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(SecondVertexFit_cppflags) $(SecondVertexFit_cxx_cppflags)  $(src)SecondVertexFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)GammaShape.d

$(bin)$(binobj)GammaShape.d :

$(bin)$(binobj)GammaShape.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)GammaShape.o : $(src)GammaShape.cxx
	$(cpp_echo) $(src)GammaShape.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(GammaShape_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(GammaShape_cppflags) $(GammaShape_cxx_cppflags)  $(src)GammaShape.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(GammaShape_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)GammaShape.cxx

$(bin)$(binobj)GammaShape.o : $(GammaShape_cxx_dependencies)
	$(cpp_echo) $(src)GammaShape.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(GammaShape_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(GammaShape_cppflags) $(GammaShape_cxx_cppflags)  $(src)GammaShape.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KinematicConstraints.d

$(bin)$(binobj)KinematicConstraints.d :

$(bin)$(binobj)KinematicConstraints.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)KinematicConstraints.o : $(src)KinematicConstraints.cxx
	$(cpp_echo) $(src)KinematicConstraints.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KinematicConstraints_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KinematicConstraints_cppflags) $(KinematicConstraints_cxx_cppflags)  $(src)KinematicConstraints.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(KinematicConstraints_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)KinematicConstraints.cxx

$(bin)$(binobj)KinematicConstraints.o : $(KinematicConstraints_cxx_dependencies)
	$(cpp_echo) $(src)KinematicConstraints.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KinematicConstraints_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KinematicConstraints_cppflags) $(KinematicConstraints_cxx_cppflags)  $(src)KinematicConstraints.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexConstraints.d

$(bin)$(binobj)VertexConstraints.d :

$(bin)$(binobj)VertexConstraints.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexConstraints.o : $(src)VertexConstraints.cxx
	$(cpp_echo) $(src)VertexConstraints.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexConstraints_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexConstraints_cppflags) $(VertexConstraints_cxx_cppflags)  $(src)VertexConstraints.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexConstraints_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)VertexConstraints.cxx

$(bin)$(binobj)VertexConstraints.o : $(VertexConstraints_cxx_dependencies)
	$(cpp_echo) $(src)VertexConstraints.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexConstraints_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexConstraints_cppflags) $(VertexConstraints_cxx_cppflags)  $(src)VertexConstraints.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalmanKinematicFit.d

$(bin)$(binobj)KalmanKinematicFit.d :

$(bin)$(binobj)KalmanKinematicFit.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)KalmanKinematicFit.o : $(src)KalmanKinematicFit.cxx
	$(cpp_echo) $(src)KalmanKinematicFit.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KalmanKinematicFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KalmanKinematicFit_cppflags) $(KalmanKinematicFit_cxx_cppflags)  $(src)KalmanKinematicFit.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(KalmanKinematicFit_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)KalmanKinematicFit.cxx

$(bin)$(binobj)KalmanKinematicFit.o : $(KalmanKinematicFit_cxx_dependencies)
	$(cpp_echo) $(src)KalmanKinematicFit.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(KalmanKinematicFit_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(KalmanKinematicFit_cppflags) $(KalmanKinematicFit_cxx_cppflags)  $(src)KalmanKinematicFit.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexDbSvc_dll.d

$(bin)$(binobj)VertexDbSvc_dll.d :

$(bin)$(binobj)VertexDbSvc_dll.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexDbSvc_dll.o : $(src)components/VertexDbSvc_dll.cxx
	$(cpp_echo) $(src)components/VertexDbSvc_dll.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_dll_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_dll_cppflags) $(VertexDbSvc_dll_cxx_cppflags) -I../src/components $(src)components/VertexDbSvc_dll.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexDbSvc_dll_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)components/VertexDbSvc_dll.cxx

$(bin)$(binobj)VertexDbSvc_dll.o : $(VertexDbSvc_dll_cxx_dependencies)
	$(cpp_echo) $(src)components/VertexDbSvc_dll.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_dll_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_dll_cppflags) $(VertexDbSvc_dll_cxx_cppflags) -I../src/components $(src)components/VertexDbSvc_dll.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)VertexDbSvc_load.d

$(bin)$(binobj)VertexDbSvc_load.d :

$(bin)$(binobj)VertexDbSvc_load.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)VertexDbSvc_load.o : $(src)components/VertexDbSvc_load.cxx
	$(cpp_echo) $(src)components/VertexDbSvc_load.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_load_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_load_cppflags) $(VertexDbSvc_load_cxx_cppflags) -I../src/components $(src)components/VertexDbSvc_load.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(VertexDbSvc_load_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)components/VertexDbSvc_load.cxx

$(bin)$(binobj)VertexDbSvc_load.o : $(VertexDbSvc_load_cxx_dependencies)
	$(cpp_echo) $(src)components/VertexDbSvc_load.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(VertexDbSvc_load_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(VertexDbSvc_load_cppflags) $(VertexDbSvc_load_cxx_cppflags) -I../src/components $(src)components/VertexDbSvc_load.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),VertexFitclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)test_read.d

$(bin)$(binobj)test_read.d :

$(bin)$(binobj)test_read.o : $(cmt_final_setup_VertexFit)

$(bin)$(binobj)test_read.o : $(src)test/test_read.cxx
	$(cpp_echo) $(src)test/test_read.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(test_read_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(test_read_cppflags) $(test_read_cxx_cppflags) -I../src/test $(src)test/test_read.cxx
endif
endif

else
$(bin)VertexFit_dependencies.make : $(test_read_cxx_dependencies)

$(bin)VertexFit_dependencies.make : $(src)test/test_read.cxx

$(bin)$(binobj)test_read.o : $(test_read_cxx_dependencies)
	$(cpp_echo) $(src)test/test_read.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(VertexFit_pp_cppflags) $(lib_VertexFit_pp_cppflags) $(test_read_pp_cppflags) $(use_cppflags) $(VertexFit_cppflags) $(lib_VertexFit_cppflags) $(test_read_cppflags) $(test_read_cxx_cppflags) -I../src/test $(src)test/test_read.cxx

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: VertexFitclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(VertexFit.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

VertexFitclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library VertexFit
	-$(cleanup_silent) cd $(bin); /bin/rm -f $(library_prefix)VertexFit$(library_suffix).a $(library_prefix)VertexFit$(library_suffix).s? VertexFit.stamp VertexFit.shstamp
#-- end of cleanup_library ---------------
