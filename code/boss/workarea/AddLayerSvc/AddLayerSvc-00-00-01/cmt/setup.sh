# echo "setup AddLayerSvc AddLayerSvc-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if test "${CMTROOT}" = ""; then
  CMTROOT=/cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25; export CMTROOT
fi
. ${CMTROOT}/mgr/setup.sh
cmtAddLayerSvctempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if test ! $? = 0 ; then cmtAddLayerSvctempfile=/tmp/cmt.$$; fi
${CMTROOT}/mgr/cmt setup -sh -pack=AddLayerSvc -version=AddLayerSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtAddLayerSvctempfile}
if test $? != 0 ; then
  echo >&2 "${CMTROOT}/mgr/cmt setup -sh -pack=AddLayerSvc -version=AddLayerSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtAddLayerSvctempfile}"
  cmtsetupstatus=2
  /bin/rm -f ${cmtAddLayerSvctempfile}
  unset cmtAddLayerSvctempfile
  return $cmtsetupstatus
fi
cmtsetupstatus=0
. ${cmtAddLayerSvctempfile}
if test $? != 0 ; then
  cmtsetupstatus=2
fi
/bin/rm -f ${cmtAddLayerSvctempfile}
unset cmtAddLayerSvctempfile
return $cmtsetupstatus

