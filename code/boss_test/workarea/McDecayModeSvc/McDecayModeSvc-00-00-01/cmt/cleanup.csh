# echo "cleanup McDecayModeSvc McDecayModeSvc-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss_test/workarea"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtMcDecayModeSvctempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtMcDecayModeSvctempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt cleanup -csh -pack=McDecayModeSvc -version=McDecayModeSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss_test/workarea  $* >${cmtMcDecayModeSvctempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt cleanup -csh -pack=McDecayModeSvc -version=McDecayModeSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss_test/workarea  $* >${cmtMcDecayModeSvctempfile}"
  set cmtcleanupstatus=2
  /bin/rm -f ${cmtMcDecayModeSvctempfile}
  unset cmtMcDecayModeSvctempfile
  exit $cmtcleanupstatus
endif
set cmtcleanupstatus=0
source ${cmtMcDecayModeSvctempfile}
if ( $status != 0 ) then
  set cmtcleanupstatus=2
endif
/bin/rm -f ${cmtMcDecayModeSvctempfile}
unset cmtMcDecayModeSvctempfile
exit $cmtcleanupstatus

