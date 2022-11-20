# echo "cleanup ExtractRecInfo ExtractRecInfo-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if test "${CMTROOT}" = ""; then
  CMTROOT=/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25; export CMTROOT
fi
. ${CMTROOT}/mgr/setup.sh
cmtExtractRecInfotempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if test ! $? = 0 ; then cmtExtractRecInfotempfile=/tmp/cmt.$$; fi
${CMTROOT}/mgr/cmt cleanup -sh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtExtractRecInfotempfile}
if test $? != 0 ; then
  echo >&2 "${CMTROOT}/mgr/cmt cleanup -sh -pack=ExtractRecInfo -version=ExtractRecInfo-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtExtractRecInfotempfile}"
  cmtcleanupstatus=2
  /bin/rm -f ${cmtExtractRecInfotempfile}
  unset cmtExtractRecInfotempfile
  return $cmtcleanupstatus
fi
cmtcleanupstatus=0
. ${cmtExtractRecInfotempfile}
if test $? != 0 ; then
  cmtcleanupstatus=2
fi
/bin/rm -f ${cmtExtractRecInfotempfile}
unset cmtExtractRecInfotempfile
return $cmtcleanupstatus

