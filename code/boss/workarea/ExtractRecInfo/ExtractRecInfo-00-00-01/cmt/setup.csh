# echo "setup ExtractRecInfo ExtractRecInfo-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtExtractRecInfotempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtExtractRecInfotempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt setup -csh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtExtractRecInfotempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt setup -csh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtExtractRecInfotempfile}"
  set cmtsetupstatus=2
  /bin/rm -f ${cmtExtractRecInfotempfile}
  unset cmtExtractRecInfotempfile
  exit $cmtsetupstatus
endif
set cmtsetupstatus=0
source ${cmtExtractRecInfotempfile}
if ( $status != 0 ) then
  set cmtsetupstatus=2
endif
/bin/rm -f ${cmtExtractRecInfotempfile}
unset cmtExtractRecInfotempfile
exit $cmtsetupstatus

