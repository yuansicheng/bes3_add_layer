#-- start of make_header -----------------

#====================================
#  Document ExtractRecInfo_check_install_runtime
#
#   Generated Mon Dec  5 22:18:55 2022  by yuansc
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_ExtractRecInfo_check_install_runtime_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_ExtractRecInfo_check_install_runtime_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_ExtractRecInfo_check_install_runtime

ExtractRecInfo_tag = $(tag)

#cmt_local_tagfile_ExtractRecInfo_check_install_runtime = $(ExtractRecInfo_tag)_ExtractRecInfo_check_install_runtime.make
cmt_local_tagfile_ExtractRecInfo_check_install_runtime = $(bin)$(ExtractRecInfo_tag)_ExtractRecInfo_check_install_runtime.make

else

tags      = $(tag),$(CMTEXTRATAGS)

ExtractRecInfo_tag = $(tag)

#cmt_local_tagfile_ExtractRecInfo_check_install_runtime = $(ExtractRecInfo_tag).make
cmt_local_tagfile_ExtractRecInfo_check_install_runtime = $(bin)$(ExtractRecInfo_tag).make

endif

include $(cmt_local_tagfile_ExtractRecInfo_check_install_runtime)
#-include $(cmt_local_tagfile_ExtractRecInfo_check_install_runtime)

ifdef cmt_ExtractRecInfo_check_install_runtime_has_target_tag

cmt_final_setup_ExtractRecInfo_check_install_runtime = $(bin)setup_ExtractRecInfo_check_install_runtime.make
cmt_dependencies_in_ExtractRecInfo_check_install_runtime = $(bin)dependencies_ExtractRecInfo_check_install_runtime.in
#cmt_final_setup_ExtractRecInfo_check_install_runtime = $(bin)ExtractRecInfo_ExtractRecInfo_check_install_runtimesetup.make
cmt_local_ExtractRecInfo_check_install_runtime_makefile = $(bin)ExtractRecInfo_check_install_runtime.make

else

cmt_final_setup_ExtractRecInfo_check_install_runtime = $(bin)setup.make
cmt_dependencies_in_ExtractRecInfo_check_install_runtime = $(bin)dependencies.in
#cmt_final_setup_ExtractRecInfo_check_install_runtime = $(bin)ExtractRecInfosetup.make
cmt_local_ExtractRecInfo_check_install_runtime_makefile = $(bin)ExtractRecInfo_check_install_runtime.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)ExtractRecInfosetup.make

#ExtractRecInfo_check_install_runtime :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'ExtractRecInfo_check_install_runtime'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = ExtractRecInfo_check_install_runtime/
#ExtractRecInfo_check_install_runtime::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of cmt_action_runner_header ---------------

ifdef ONCE
ExtractRecInfo_check_install_runtime_once = 1
endif

ifdef ExtractRecInfo_check_install_runtime_once

ExtractRecInfo_check_install_runtimeactionstamp = $(bin)ExtractRecInfo_check_install_runtime.actionstamp
#ExtractRecInfo_check_install_runtimeactionstamp = ExtractRecInfo_check_install_runtime.actionstamp

ExtractRecInfo_check_install_runtime :: $(ExtractRecInfo_check_install_runtimeactionstamp)
	$(echo) "ExtractRecInfo_check_install_runtime ok"
#	@echo ExtractRecInfo_check_install_runtime ok

#$(ExtractRecInfo_check_install_runtimeactionstamp) :: $(ExtractRecInfo_check_install_runtime_dependencies)
$(ExtractRecInfo_check_install_runtimeactionstamp) ::
	$(silent) /cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/7.0.5/BesPolicy/BesPolicy-01-05-05/cmt/bes_check_installations.sh -files= -s=../share *.txt   -installdir=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/InstallArea/share
	$(silent) cat /dev/null > $(ExtractRecInfo_check_install_runtimeactionstamp)
#	@echo ok > $(ExtractRecInfo_check_install_runtimeactionstamp)

ExtractRecInfo_check_install_runtimeclean ::
	$(cleanup_silent) /bin/rm -f $(ExtractRecInfo_check_install_runtimeactionstamp)

else

#ExtractRecInfo_check_install_runtime :: $(ExtractRecInfo_check_install_runtime_dependencies)
ExtractRecInfo_check_install_runtime ::
	$(silent) /cvmfs/bes3.ihep.ac.cn/bes3sw/Boss/7.0.5/BesPolicy/BesPolicy-01-05-05/cmt/bes_check_installations.sh -files= -s=../share *.txt   -installdir=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/InstallArea/share

endif

install ::
uninstall ::

#-- end of cmt_action_runner_header -----------------
#-- start of cleanup_header --------------

clean :: ExtractRecInfo_check_install_runtimeclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(ExtractRecInfo_check_install_runtime.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

ExtractRecInfo_check_install_runtimeclean ::
#-- end of cleanup_header ---------------
