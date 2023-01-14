#-- start of make_header -----------------

#====================================
#  Library KalFitAlg
#
#   Generated Fri Jan 13 16:45:31 2023  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_KalFitAlg_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_KalFitAlg_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_KalFitAlg

KalFitAlg_tag = $(tag)

#cmt_local_tagfile_KalFitAlg = $(KalFitAlg_tag)_KalFitAlg.make
cmt_local_tagfile_KalFitAlg = $(bin)$(KalFitAlg_tag)_KalFitAlg.make

else

tags      = $(tag),$(CMTEXTRATAGS)

KalFitAlg_tag = $(tag)

#cmt_local_tagfile_KalFitAlg = $(KalFitAlg_tag).make
cmt_local_tagfile_KalFitAlg = $(bin)$(KalFitAlg_tag).make

endif

include $(cmt_local_tagfile_KalFitAlg)
#-include $(cmt_local_tagfile_KalFitAlg)

ifdef cmt_KalFitAlg_has_target_tag

cmt_final_setup_KalFitAlg = $(bin)setup_KalFitAlg.make
cmt_dependencies_in_KalFitAlg = $(bin)dependencies_KalFitAlg.in
#cmt_final_setup_KalFitAlg = $(bin)KalFitAlg_KalFitAlgsetup.make
cmt_local_KalFitAlg_makefile = $(bin)KalFitAlg.make

else

cmt_final_setup_KalFitAlg = $(bin)setup.make
cmt_dependencies_in_KalFitAlg = $(bin)dependencies.in
#cmt_final_setup_KalFitAlg = $(bin)KalFitAlgsetup.make
cmt_local_KalFitAlg_makefile = $(bin)KalFitAlg.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)KalFitAlgsetup.make

#KalFitAlg :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'KalFitAlg'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = KalFitAlg/
#KalFitAlg::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

KalFitAlglibname   = $(bin)$(library_prefix)KalFitAlg$(library_suffix)
KalFitAlglib       = $(KalFitAlglibname).a
KalFitAlgstamp     = $(bin)KalFitAlg.stamp
KalFitAlgshstamp   = $(bin)KalFitAlg.shstamp

KalFitAlg :: dirs  KalFitAlgLIB
	$(echo) "KalFitAlg ok"

#-- end of libary_header ----------------

KalFitAlgLIB :: $(KalFitAlglib) $(KalFitAlgshstamp)
	@/bin/echo "------> KalFitAlg : library ok"

$(KalFitAlglib) :: $(bin)KalFitTrack2.o $(bin)KalFitMaterial.o $(bin)KalFitSuper_Mdc.o $(bin)KalFitHitMdc.o $(bin)KalFitAlg2.o $(bin)KalFitHelixSeg.o $(bin)KalFitWire.o $(bin)KalFitElement.o $(bin)KalFitPar.o $(bin)KalFitCylinder.o $(bin)KalFitReadGdml.o $(bin)KalFitTrack.o $(bin)KalFitDoca.o $(bin)KalFitAlg.o $(bin)KalFitAlg_entries.o $(bin)KalFitAlg_load.o $(bin)Helix.o $(bin)Lpar.o $(bin)Lpav.o $(bin)Bfield.o
	$(lib_echo) library
	$(lib_silent) cd $(bin); \
	  $(ar) $(KalFitAlglib) $?
	$(lib_silent) $(ranlib) $(KalFitAlglib)
	$(lib_silent) cat /dev/null >$(KalFitAlgstamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

$(KalFitAlglibname).$(shlibsuffix) :: $(KalFitAlglib) $(KalFitAlgstamps)
	$(lib_silent) cd $(bin); QUIET=$(QUIET); $(make_shlib) "$(tags)" KalFitAlg $(KalFitAlg_shlibflags)

$(KalFitAlgshstamp) :: $(KalFitAlglibname).$(shlibsuffix)
	@if test -f $(KalFitAlglibname).$(shlibsuffix) ; then cat /dev/null >$(KalFitAlgshstamp) ; fi

KalFitAlgclean ::
	$(cleanup_echo) objects
	$(cleanup_silent) cd $(bin); /bin/rm -f $(bin)KalFitTrack2.o $(bin)KalFitMaterial.o $(bin)KalFitSuper_Mdc.o $(bin)KalFitHitMdc.o $(bin)KalFitAlg2.o $(bin)KalFitHelixSeg.o $(bin)KalFitWire.o $(bin)KalFitElement.o $(bin)KalFitPar.o $(bin)KalFitCylinder.o $(bin)KalFitReadGdml.o $(bin)KalFitTrack.o $(bin)KalFitDoca.o $(bin)KalFitAlg.o $(bin)KalFitAlg_entries.o $(bin)KalFitAlg_load.o $(bin)Helix.o $(bin)Lpar.o $(bin)Lpav.o $(bin)Bfield.o

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
KalFitAlginstallname = $(library_prefix)KalFitAlg$(library_suffix).$(shlibsuffix)

KalFitAlg :: KalFitAlginstall

install :: KalFitAlginstall

KalFitAlginstall :: $(install_dir)/$(KalFitAlginstallname)
	@if test ! "${installarea}" = ""; then\
	  echo "installation done"; \
	fi

$(install_dir)/$(KalFitAlginstallname) :: $(bin)$(KalFitAlginstallname)
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test ! -d "$(install_dir)"; then \
	      mkdir -p $(install_dir); \
	    fi ; \
	    if test -d "$(install_dir)"; then \
	      echo "Installing library $(KalFitAlginstallname) into $(install_dir)"; \
	      if test -e $(install_dir)/$(KalFitAlginstallname); then \
	        $(cmt_uninstall_area_command) $(install_dir)/$(KalFitAlginstallname); \
	        $(cmt_uninstall_area_command) $(install_dir)/$(KalFitAlginstallname).cmtref; \
	      fi; \
	      $(cmt_install_area_command) `pwd`/$(KalFitAlginstallname) $(install_dir)/$(KalFitAlginstallname); \
	      echo `pwd`/$(KalFitAlginstallname) >$(install_dir)/$(KalFitAlginstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot install library $(KalFitAlginstallname), no installation directory specified"; \
	  fi; \
	fi

KalFitAlgclean :: KalFitAlguninstall

uninstall :: KalFitAlguninstall

KalFitAlguninstall ::
	@if test ! "${installarea}" = ""; then \
	  cd $(bin); \
	  if test ! "$(install_dir)" = ""; then \
	    if test -d "$(install_dir)"; then \
	      echo "Removing installed library $(KalFitAlginstallname) from $(install_dir)"; \
	      $(cmt_uninstall_area_command) $(install_dir)/$(KalFitAlginstallname); \
	      $(cmt_uninstall_area_command) $(install_dir)/$(KalFitAlginstallname).cmtref; \
	    fi \
          else \
	    echo "Cannot uninstall library $(KalFitAlginstallname), no installation directory specified"; \
	  fi; \
	fi




#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitTrack2.d

$(bin)$(binobj)KalFitTrack2.d :

$(bin)$(binobj)KalFitTrack2.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitTrack2.o : $(src)KalFitTrack2.cxx
	$(cpp_echo) $(src)KalFitTrack2.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitTrack2_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitTrack2_cppflags) $(KalFitTrack2_cxx_cppflags)  $(src)KalFitTrack2.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitTrack2_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitTrack2.cxx

$(bin)$(binobj)KalFitTrack2.o : $(KalFitTrack2_cxx_dependencies)
	$(cpp_echo) $(src)KalFitTrack2.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitTrack2_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitTrack2_cppflags) $(KalFitTrack2_cxx_cppflags)  $(src)KalFitTrack2.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitMaterial.d

$(bin)$(binobj)KalFitMaterial.d :

$(bin)$(binobj)KalFitMaterial.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitMaterial.o : $(src)KalFitMaterial.cxx
	$(cpp_echo) $(src)KalFitMaterial.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitMaterial_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitMaterial_cppflags) $(KalFitMaterial_cxx_cppflags)  $(src)KalFitMaterial.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitMaterial_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitMaterial.cxx

$(bin)$(binobj)KalFitMaterial.o : $(KalFitMaterial_cxx_dependencies)
	$(cpp_echo) $(src)KalFitMaterial.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitMaterial_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitMaterial_cppflags) $(KalFitMaterial_cxx_cppflags)  $(src)KalFitMaterial.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitSuper_Mdc.d

$(bin)$(binobj)KalFitSuper_Mdc.d :

$(bin)$(binobj)KalFitSuper_Mdc.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitSuper_Mdc.o : $(src)KalFitSuper_Mdc.cxx
	$(cpp_echo) $(src)KalFitSuper_Mdc.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitSuper_Mdc_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitSuper_Mdc_cppflags) $(KalFitSuper_Mdc_cxx_cppflags)  $(src)KalFitSuper_Mdc.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitSuper_Mdc_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitSuper_Mdc.cxx

$(bin)$(binobj)KalFitSuper_Mdc.o : $(KalFitSuper_Mdc_cxx_dependencies)
	$(cpp_echo) $(src)KalFitSuper_Mdc.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitSuper_Mdc_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitSuper_Mdc_cppflags) $(KalFitSuper_Mdc_cxx_cppflags)  $(src)KalFitSuper_Mdc.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitHitMdc.d

$(bin)$(binobj)KalFitHitMdc.d :

$(bin)$(binobj)KalFitHitMdc.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitHitMdc.o : $(src)KalFitHitMdc.cxx
	$(cpp_echo) $(src)KalFitHitMdc.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitHitMdc_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitHitMdc_cppflags) $(KalFitHitMdc_cxx_cppflags)  $(src)KalFitHitMdc.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitHitMdc_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitHitMdc.cxx

$(bin)$(binobj)KalFitHitMdc.o : $(KalFitHitMdc_cxx_dependencies)
	$(cpp_echo) $(src)KalFitHitMdc.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitHitMdc_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitHitMdc_cppflags) $(KalFitHitMdc_cxx_cppflags)  $(src)KalFitHitMdc.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitAlg2.d

$(bin)$(binobj)KalFitAlg2.d :

$(bin)$(binobj)KalFitAlg2.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitAlg2.o : $(src)KalFitAlg2.cxx
	$(cpp_echo) $(src)KalFitAlg2.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg2_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg2_cppflags) $(KalFitAlg2_cxx_cppflags)  $(src)KalFitAlg2.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitAlg2_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitAlg2.cxx

$(bin)$(binobj)KalFitAlg2.o : $(KalFitAlg2_cxx_dependencies)
	$(cpp_echo) $(src)KalFitAlg2.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg2_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg2_cppflags) $(KalFitAlg2_cxx_cppflags)  $(src)KalFitAlg2.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitHelixSeg.d

$(bin)$(binobj)KalFitHelixSeg.d :

$(bin)$(binobj)KalFitHelixSeg.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitHelixSeg.o : $(src)KalFitHelixSeg.cxx
	$(cpp_echo) $(src)KalFitHelixSeg.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitHelixSeg_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitHelixSeg_cppflags) $(KalFitHelixSeg_cxx_cppflags)  $(src)KalFitHelixSeg.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitHelixSeg_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitHelixSeg.cxx

$(bin)$(binobj)KalFitHelixSeg.o : $(KalFitHelixSeg_cxx_dependencies)
	$(cpp_echo) $(src)KalFitHelixSeg.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitHelixSeg_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitHelixSeg_cppflags) $(KalFitHelixSeg_cxx_cppflags)  $(src)KalFitHelixSeg.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitWire.d

$(bin)$(binobj)KalFitWire.d :

$(bin)$(binobj)KalFitWire.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitWire.o : $(src)KalFitWire.cxx
	$(cpp_echo) $(src)KalFitWire.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitWire_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitWire_cppflags) $(KalFitWire_cxx_cppflags)  $(src)KalFitWire.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitWire_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitWire.cxx

$(bin)$(binobj)KalFitWire.o : $(KalFitWire_cxx_dependencies)
	$(cpp_echo) $(src)KalFitWire.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitWire_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitWire_cppflags) $(KalFitWire_cxx_cppflags)  $(src)KalFitWire.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitElement.d

$(bin)$(binobj)KalFitElement.d :

$(bin)$(binobj)KalFitElement.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitElement.o : $(src)KalFitElement.cxx
	$(cpp_echo) $(src)KalFitElement.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitElement_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitElement_cppflags) $(KalFitElement_cxx_cppflags)  $(src)KalFitElement.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitElement_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitElement.cxx

$(bin)$(binobj)KalFitElement.o : $(KalFitElement_cxx_dependencies)
	$(cpp_echo) $(src)KalFitElement.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitElement_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitElement_cppflags) $(KalFitElement_cxx_cppflags)  $(src)KalFitElement.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitPar.d

$(bin)$(binobj)KalFitPar.d :

$(bin)$(binobj)KalFitPar.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitPar.o : $(src)KalFitPar.cxx
	$(cpp_echo) $(src)KalFitPar.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitPar_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitPar_cppflags) $(KalFitPar_cxx_cppflags)  $(src)KalFitPar.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitPar_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitPar.cxx

$(bin)$(binobj)KalFitPar.o : $(KalFitPar_cxx_dependencies)
	$(cpp_echo) $(src)KalFitPar.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitPar_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitPar_cppflags) $(KalFitPar_cxx_cppflags)  $(src)KalFitPar.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitCylinder.d

$(bin)$(binobj)KalFitCylinder.d :

$(bin)$(binobj)KalFitCylinder.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitCylinder.o : $(src)KalFitCylinder.cxx
	$(cpp_echo) $(src)KalFitCylinder.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitCylinder_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitCylinder_cppflags) $(KalFitCylinder_cxx_cppflags)  $(src)KalFitCylinder.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitCylinder_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitCylinder.cxx

$(bin)$(binobj)KalFitCylinder.o : $(KalFitCylinder_cxx_dependencies)
	$(cpp_echo) $(src)KalFitCylinder.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitCylinder_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitCylinder_cppflags) $(KalFitCylinder_cxx_cppflags)  $(src)KalFitCylinder.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitReadGdml.d

$(bin)$(binobj)KalFitReadGdml.d :

$(bin)$(binobj)KalFitReadGdml.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitReadGdml.o : $(src)KalFitReadGdml.cxx
	$(cpp_echo) $(src)KalFitReadGdml.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitReadGdml_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitReadGdml_cppflags) $(KalFitReadGdml_cxx_cppflags)  $(src)KalFitReadGdml.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitReadGdml_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitReadGdml.cxx

$(bin)$(binobj)KalFitReadGdml.o : $(KalFitReadGdml_cxx_dependencies)
	$(cpp_echo) $(src)KalFitReadGdml.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitReadGdml_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitReadGdml_cppflags) $(KalFitReadGdml_cxx_cppflags)  $(src)KalFitReadGdml.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitTrack.d

$(bin)$(binobj)KalFitTrack.d :

$(bin)$(binobj)KalFitTrack.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitTrack.o : $(src)KalFitTrack.cxx
	$(cpp_echo) $(src)KalFitTrack.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitTrack_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitTrack_cppflags) $(KalFitTrack_cxx_cppflags)  $(src)KalFitTrack.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitTrack_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitTrack.cxx

$(bin)$(binobj)KalFitTrack.o : $(KalFitTrack_cxx_dependencies)
	$(cpp_echo) $(src)KalFitTrack.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitTrack_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitTrack_cppflags) $(KalFitTrack_cxx_cppflags)  $(src)KalFitTrack.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitDoca.d

$(bin)$(binobj)KalFitDoca.d :

$(bin)$(binobj)KalFitDoca.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitDoca.o : $(src)KalFitDoca.cxx
	$(cpp_echo) $(src)KalFitDoca.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitDoca_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitDoca_cppflags) $(KalFitDoca_cxx_cppflags)  $(src)KalFitDoca.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitDoca_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitDoca.cxx

$(bin)$(binobj)KalFitDoca.o : $(KalFitDoca_cxx_dependencies)
	$(cpp_echo) $(src)KalFitDoca.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitDoca_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitDoca_cppflags) $(KalFitDoca_cxx_cppflags)  $(src)KalFitDoca.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitAlg.d

$(bin)$(binobj)KalFitAlg.d :

$(bin)$(binobj)KalFitAlg.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitAlg.o : $(src)KalFitAlg.cxx
	$(cpp_echo) $(src)KalFitAlg.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_cppflags) $(KalFitAlg_cxx_cppflags)  $(src)KalFitAlg.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitAlg_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)KalFitAlg.cxx

$(bin)$(binobj)KalFitAlg.o : $(KalFitAlg_cxx_dependencies)
	$(cpp_echo) $(src)KalFitAlg.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_cppflags) $(KalFitAlg_cxx_cppflags)  $(src)KalFitAlg.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitAlg_entries.d

$(bin)$(binobj)KalFitAlg_entries.d :

$(bin)$(binobj)KalFitAlg_entries.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitAlg_entries.o : $(src)components/KalFitAlg_entries.cxx
	$(cpp_echo) $(src)components/KalFitAlg_entries.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_entries_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_entries_cppflags) $(KalFitAlg_entries_cxx_cppflags) -I../src/components $(src)components/KalFitAlg_entries.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitAlg_entries_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)components/KalFitAlg_entries.cxx

$(bin)$(binobj)KalFitAlg_entries.o : $(KalFitAlg_entries_cxx_dependencies)
	$(cpp_echo) $(src)components/KalFitAlg_entries.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_entries_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_entries_cppflags) $(KalFitAlg_entries_cxx_cppflags) -I../src/components $(src)components/KalFitAlg_entries.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)KalFitAlg_load.d

$(bin)$(binobj)KalFitAlg_load.d :

$(bin)$(binobj)KalFitAlg_load.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)KalFitAlg_load.o : $(src)components/KalFitAlg_load.cxx
	$(cpp_echo) $(src)components/KalFitAlg_load.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_load_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_load_cppflags) $(KalFitAlg_load_cxx_cppflags) -I../src/components $(src)components/KalFitAlg_load.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(KalFitAlg_load_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)components/KalFitAlg_load.cxx

$(bin)$(binobj)KalFitAlg_load.o : $(KalFitAlg_load_cxx_dependencies)
	$(cpp_echo) $(src)components/KalFitAlg_load.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(KalFitAlg_load_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(KalFitAlg_load_cppflags) $(KalFitAlg_load_cxx_cppflags) -I../src/components $(src)components/KalFitAlg_load.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)Helix.d

$(bin)$(binobj)Helix.d :

$(bin)$(binobj)Helix.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)Helix.o : $(src)helix/Helix.cxx
	$(cpp_echo) $(src)helix/Helix.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Helix_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Helix_cppflags) $(Helix_cxx_cppflags) -I../src/helix $(src)helix/Helix.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(Helix_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)helix/Helix.cxx

$(bin)$(binobj)Helix.o : $(Helix_cxx_dependencies)
	$(cpp_echo) $(src)helix/Helix.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Helix_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Helix_cppflags) $(Helix_cxx_cppflags) -I../src/helix $(src)helix/Helix.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)Lpar.d

$(bin)$(binobj)Lpar.d :

$(bin)$(binobj)Lpar.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)Lpar.o : $(src)lpav/Lpar.cxx
	$(cpp_echo) $(src)lpav/Lpar.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Lpar_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Lpar_cppflags) $(Lpar_cxx_cppflags) -I../src/lpav $(src)lpav/Lpar.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(Lpar_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)lpav/Lpar.cxx

$(bin)$(binobj)Lpar.o : $(Lpar_cxx_dependencies)
	$(cpp_echo) $(src)lpav/Lpar.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Lpar_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Lpar_cppflags) $(Lpar_cxx_cppflags) -I../src/lpav $(src)lpav/Lpar.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)Lpav.d

$(bin)$(binobj)Lpav.d :

$(bin)$(binobj)Lpav.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)Lpav.o : $(src)lpav/Lpav.cxx
	$(cpp_echo) $(src)lpav/Lpav.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Lpav_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Lpav_cppflags) $(Lpav_cxx_cppflags) -I../src/lpav $(src)lpav/Lpav.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(Lpav_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)lpav/Lpav.cxx

$(bin)$(binobj)Lpav.o : $(Lpav_cxx_dependencies)
	$(cpp_echo) $(src)lpav/Lpav.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Lpav_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Lpav_cppflags) $(Lpav_cxx_cppflags) -I../src/lpav $(src)lpav/Lpav.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),KalFitAlgclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)Bfield.d

$(bin)$(binobj)Bfield.d :

$(bin)$(binobj)Bfield.o : $(cmt_final_setup_KalFitAlg)

$(bin)$(binobj)Bfield.o : $(src)coil/Bfield.cxx
	$(cpp_echo) $(src)coil/Bfield.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Bfield_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Bfield_cppflags) $(Bfield_cxx_cppflags) -I../src/coil $(src)coil/Bfield.cxx
endif
endif

else
$(bin)KalFitAlg_dependencies.make : $(Bfield_cxx_dependencies)

$(bin)KalFitAlg_dependencies.make : $(src)coil/Bfield.cxx

$(bin)$(binobj)Bfield.o : $(Bfield_cxx_dependencies)
	$(cpp_echo) $(src)coil/Bfield.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(KalFitAlg_pp_cppflags) $(lib_KalFitAlg_pp_cppflags) $(Bfield_pp_cppflags) $(use_cppflags) $(KalFitAlg_cppflags) $(lib_KalFitAlg_cppflags) $(Bfield_cppflags) $(Bfield_cxx_cppflags) -I../src/coil $(src)coil/Bfield.cxx

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: KalFitAlgclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(KalFitAlg.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

KalFitAlgclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library KalFitAlg
	-$(cleanup_silent) cd $(bin); /bin/rm -f $(library_prefix)KalFitAlg$(library_suffix).a $(library_prefix)KalFitAlg$(library_suffix).s? KalFitAlg.stamp KalFitAlg.shstamp
#-- end of cleanup_library ---------------
