# echo "cleanup KalFitAlg KalFitAlg-00-07-55-p03 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction"

if test "${CMTROOT}" = ""; then
  CMTROOT=/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25; export CMTROOT
fi
. ${CMTROOT}/mgr/setup.sh
cmtKalFitAlgtempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if test ! $? = 0 ; then cmtKalFitAlgtempfile=/tmp/cmt.$$; fi
${CMTROOT}/mgr/cmt cleanup -sh -pack=KalFitAlg -version=KalFitAlg-00-07-55-p03 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction  -quiet -with_version_directory $* >${cmtKalFitAlgtempfile}
if test $? != 0 ; then
  echo >&2 "${CMTROOT}/mgr/cmt cleanup -sh -pack=KalFitAlg -version=KalFitAlg-00-07-55-p03 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea/Reconstruction  -quiet -with_version_directory $* >${cmtKalFitAlgtempfile}"
  cmtcleanupstatus=2
  /bin/rm -f ${cmtKalFitAlgtempfile}
  unset cmtKalFitAlgtempfile
  return $cmtcleanupstatus
fi
cmtcleanupstatus=0
. ${cmtKalFitAlgtempfile}
if test $? != 0 ; then
  cmtcleanupstatus=2
fi
/bin/rm -f ${cmtKalFitAlgtempfile}
unset cmtKalFitAlgtempfile
return $cmtcleanupstatus

