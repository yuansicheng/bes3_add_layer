# echo "cleanup KalFitAlg KalFitAlg-00-07-55-p03 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtKalFitAlgtempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtKalFitAlgtempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt cleanup -csh -pack=KalFitAlg -version=KalFitAlg-00-07-55-p03 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction  -quiet -with_version_directory $* >${cmtKalFitAlgtempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt cleanup -csh -pack=KalFitAlg -version=KalFitAlg-00-07-55-p03 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction  -quiet -with_version_directory $* >${cmtKalFitAlgtempfile}"
  set cmtcleanupstatus=2
  /bin/rm -f ${cmtKalFitAlgtempfile}
  unset cmtKalFitAlgtempfile
  exit $cmtcleanupstatus
endif
set cmtcleanupstatus=0
source ${cmtKalFitAlgtempfile}
if ( $status != 0 ) then
  set cmtcleanupstatus=2
endif
/bin/rm -f ${cmtKalFitAlgtempfile}
unset cmtKalFitAlgtempfile
exit $cmtcleanupstatus

