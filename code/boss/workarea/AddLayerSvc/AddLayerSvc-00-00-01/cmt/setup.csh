# echo "setup AddLayerSvc AddLayerSvc-00-00-01 in /junofs/users/yuansc/bes3_add_layer/code/boss/workarea"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/bes3.ihep.ac.cn/bes3sw/ExternalLib/SLC6/contrib/CMT/v1r25
endif
source ${CMTROOT}/mgr/setup.csh
set cmtAddLayerSvctempfile=`${CMTROOT}/mgr/cmt -quiet build temporary_name`
if $status != 0 then
  set cmtAddLayerSvctempfile=/tmp/cmt.$$
endif
${CMTROOT}/mgr/cmt setup -csh -pack=AddLayerSvc -version=AddLayerSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtAddLayerSvctempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/mgr/cmt setup -csh -pack=AddLayerSvc -version=AddLayerSvc-00-00-01 -path=/junofs/users/yuansc/bes3_add_layer/code/boss/workarea  -no_cleanup $* >${cmtAddLayerSvctempfile}"
  set cmtsetupstatus=2
  /bin/rm -f ${cmtAddLayerSvctempfile}
  unset cmtAddLayerSvctempfile
  exit $cmtsetupstatus
endif
set cmtsetupstatus=0
source ${cmtAddLayerSvctempfile}
if ( $status != 0 ) then
  set cmtsetupstatus=2
endif
/bin/rm -f ${cmtAddLayerSvctempfile}
unset cmtAddLayerSvctempfile
exit $cmtsetupstatus

