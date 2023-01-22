# echo "cleanup VertexFit VertexFit-00-02-85 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if test "${CMTROOT}" = ""; then
  CMTROOT=/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25; export CMTROOT
fi
. ${CMTROOT}/mgr/setup.sh
cmtVertexFittempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if test ! $? = 0 ; then cmtVertexFittempfile=/tmp/cmt.$$; fi
${CMTROOT}/mgr/cmt cleanup -sh -pack=VertexFit -version=VertexFit-00-02-85 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtVertexFittempfile}
if test $? != 0 ; then
  echo >&2 "${CMTROOT}/mgr/cmt cleanup -sh -pack=VertexFit -version=VertexFit-00-02-85 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  $* >${cmtVertexFittempfile}"
  cmtcleanupstatus=2
  /bin/rm -f ${cmtVertexFittempfile}
  unset cmtVertexFittempfile
  return $cmtcleanupstatus
fi
cmtcleanupstatus=0
. ${cmtVertexFittempfile}
if test $? != 0 ; then
  cmtcleanupstatus=2
fi
/bin/rm -f ${cmtVertexFittempfile}
unset cmtVertexFittempfile
return $cmtcleanupstatus

