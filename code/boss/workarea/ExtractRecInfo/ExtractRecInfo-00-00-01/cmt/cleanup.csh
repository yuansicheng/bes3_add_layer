# echo "cleanup ExtractRecInfo ExtractRecInfo-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtExtractRecInfotempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtExtractRecInfotempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt cleanup -csh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtExtractRecInfotempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt cleanup -csh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtExtractRecInfotempfile}"
  set cmtcleanupstatus=2
  /bin/rm -f ${cmtExtractRecInfotempfile}
  unset cmtExtractRecInfotempfile
  exit $cmtcleanupstatus
endif
set cmtcleanupstatus=0
source ${cmtExtractRecInfotempfile}
if ( $status != 0 ) then
  set cmtcleanupstatus=2
endif
/bin/rm -f ${cmtExtractRecInfotempfile}
unset cmtExtractRecInfotempfile
exit $cmtcleanupstatus

