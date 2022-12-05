#include "KalFitAlg/KalFitAlg.h"
#include "KalFitAlg/KalFitTrack.h"
#include "KalFitAlg/KalFitWire.h"
//#include "EvTimeEvent/RecEsTime.h"
#include "GaudiKernel/MsgStream.h"
#include "GaudiKernel/Bootstrap.h"
#include "MagneticField/MagneticFieldSvc.h"
#include "GaudiKernel/ISvcLocator.h"
#include "GaudiKernel/IDataProviderSvc.h"
#include "GaudiKernel/SmartDataPtr.h"
#include "GaudiKernel/Algorithm.h"
#include "MdcRawEvent/MdcDigi.h"
#include "RawEvent/RawDataUtil.h"
#include "EventModel/Event.h"
#include "Identifier/MdcID.h"
#include "Identifier/Identifier.h"
#include "CLHEP/Matrix/SymMatrix.h"

double KalFitTrack::EventT0_ = 0.;
HepSymMatrix KalFitTrack::initMatrix_(5,0);
const MdcCalibFunSvc* KalFitTrack::CalibFunSvc_ = 0;
const IMagneticFieldSvc* KalFitTrack::MFSvc_ = 0;
IMdcGeomSvc* KalFitTrack::iGeomSvc_ = 0;
MdcDigiCol* KalFitTrack::mdcDigiCol_ = 0;
int KalFitTrack::tprop_ = 1;


//KalFitAlg* alg; 
//IDataProviderSvc* eventSvc = alg->eventDataService();
/* SmartDataPtr<MdcDigiCol> mdcDigiCol(alg->eventSvc(),"/Event/Digi/MdcDigiCol");
   if (!mdcDigiCol) {
   log << MSG::ERROR << "Could not find event in MdcDigiCol" << endreq;
   return( StatusCode::FAILURE);
   }
 */

void KalFitTrack::setInitMatrix(HepSymMatrix m)
{ 
	initMatrix_ = m;
}

HepSymMatrix KalFitTrack::getInitMatrix() const
{
	return initMatrix_ ;
}

void  KalFitTrack::setT0(double eventstart ) 
{
	//------------------set  event  start time-----------

	EventT0_ = eventstart;
	if(debug_ == 4) {
		std::cout<<"in function KalFitTrack::setT0(...), EventT0_ = "<<EventT0_<<std::endl;
	}
}

double  KalFitTrack::getT0(void ) const 
{
	//------------------get  event  start time-----------

	if(debug_ == 4) {
		std::cout<<"in function KalFitTrack::getT0 ( ), EventT0_ = "<<EventT0_<<std::endl;   
	}                                                                             
	return EventT0_ ;
}

//
/*   double KalFitTrack::get_T0(void) const
     {
     return 0;
     }
 */

double KalFitTrack::getDriftTime(KalFitHitMdc& hitmdc , double toftime) const
{
	const double vinner = 220.0e8; // cm/s
	const double vouter = 240.0e8; // cm/s

	int layerid = hitmdc.wire().layer().layerId();
	double zhit = (hitmdc.rechitptr())->getZhit();
	const KalFitWire* wire = &(hitmdc.wire());
	HepPoint3D fPoint = wire->fwd();
	HepPoint3D bPoint = wire->bck();

	// unit is centimeter
	double wireLen = (fPoint-bPoint).x()*(fPoint-bPoint).x()+(fPoint-bPoint).y()*(fPoint-bPoint).y()+(fPoint-bPoint).z()*(fPoint-bPoint).z();
	wireLen = sqrt(wireLen);
	double wireZLen = fabs(fPoint.z() - bPoint.z());
	double tp = 0.;
	double vp = 0.;
	// west readout  
	if(0==layerid%2){
		// inner chamber
		if(layerid<8){
			vp = vinner;
		}
		else {
			vp = vouter;
		} 
		tp = wireLen*fabs(zhit - bPoint.z())/wireZLen/vp; 
	}

	// east readout  
	if(1==layerid%2){
		// inner chamber
		if(layerid<8){
			vp = vinner;
		}
		else {
			vp = vouter;
		}
		tp = wireLen*fabs(zhit - fPoint.z())/wireZLen/vp;
	}

	// s to ns
	tp = 1.0e9*tp;

	if(0==tprop_) tp = 0.;

	//std::cout<<"propogation time: "<<tp<<std::endl;

	int wireid = hitmdc.wire().geoID();
	double drifttime1(0.);
	double drifttime2(0.);
	double drifttime3(0.);

	MdcDigiCol::iterator iter = mdcDigiCol_->begin();       
	for(; iter != mdcDigiCol_->end(); iter++ ) {
		if((*iter)->identify() == (hitmdc.rechitptr())->getMdcId()) break;
	}
	//double t0 = get_T0();
	// see the code of wulh in /Mdc/MdcCalibFunSvc/MdcCalibFunSvc/MdcCalibFunSvc.h,
	// double getT0(int wireid) const { return m_t0[wireid]; }

	//double getTimeWalk(int layid, double Q) const ;
	double Q = RawDataUtil::MdcCharge((*iter)->getChargeChannel()); 
	double timewalk = CalibFunSvc_->getTimeWalk(layerid, Q);

	if(debug_ == 4) { 
		std::cout<<"CalibFunSvc_->getTimeWalk, timewalk ="<<timewalk<<std::endl;
	} 

	double timeoffset = CalibFunSvc_->getT0(wireid);
	if(debug_ == 4) {
		std::cout<<"CalibFunSvc_->getT0, timeoffset ="<<timeoffset<<std::endl;
	} 

	double eventt0 = getT0(); 

	if(debug_ == 4) {
		std::cout<<"the Event T0 we get in the function getDriftTime(...) is "<<eventt0<<std::endl;
	}

	// this tdc value come from MdcRecHit assigned by zhangyao
	double tdctime1 = hitmdc.tdc();
	double tdctime2(0.);
	double tdctime3(0.);

	if(debug_ == 4) {
		std::cout<<"tdctime1 be here is .."<<tdctime1<<std::endl; 
	}

	// this tdc value come from MdcDigiCol time channel
	// attention, if we use the iter like this: for(MdcDigiCol::iterator iter = mdcDigiCol_->begin(); iter != mdcDigiCol_->end(); iter++) it cannot pass the gmake , throw an error !
	if(debug_ == 4) {
		//  std::cout<<"the size of the mdcDigiCol_ is "<<mdcDigiCol_.size()<<std::endl;
	}
	// MdcDigiCol::iterator iter = mdcDigiCol_->begin();       
	// for(; iter != mdcDigiCol_->end(); iter++ ) {
	//       if((*iter)->identify() == (hitmdc.rechitptr())->getMdcId()) break;
	//  }
	if(debug_ == 4) { 
		std::cout<<"the time channel be here is .."<<(*iter)->getTimeChannel()<<std::endl;
	}
	tdctime2 = RawDataUtil::MdcTime((*iter)->getTimeChannel());
	tdctime3 = hitmdc.rechitptr()->getTdc();
	drifttime1 = tdctime1 - eventt0 - toftime - timewalk -timeoffset - tp;
	drifttime2 = tdctime2 - eventt0 - toftime - timewalk -timeoffset - tp;
	drifttime3 = tdctime3 - eventt0 - toftime - timewalk -timeoffset - tp;
	if(debug_ == 4 ) {
		std::cout<<"we now compare the three kind of tdc , the tdc get from timeChannel() is "<<tdctime2<<" the tdc get from KalFitHitMdc is "<<tdctime1<<" the tdc from MdcRecHit is "<<tdctime3<<" the drifttime1 is ..."<<drifttime1<<" the drifttime 2 is ..."<<drifttime2<<" the drifttime3 is ..."<<drifttime3<<std::endl;
	}
	//return drifttime3;
	//return drifttime1;
	if(drifttime_choice_ == 0)
		return drifttime2;
	if(drifttime_choice_ == 1)
		// use the driftT caluculated by track-finding
		return hitmdc.rechitptr()->getDriftT(); 
}


// attention , the unit of the driftdist is mm
double KalFitTrack::getDriftDist(KalFitHitMdc& hitmdc, double drifttime, int lr) const
{
	int layerid = hitmdc.wire().layer().layerId();
	int  cellid = MdcID::wire(hitmdc.rechitptr()->getMdcId());
	if(debug_ == 4 ){
		std::cout<<"the cellid is .."<<cellid<<std::endl;
	} 
	double entrangle = hitmdc.rechitptr()->getEntra();

	//std::cout<<" entrangle: "<<entrangle<<std::endl;

	return CalibFunSvc_->driftTimeToDist(drifttime, layerid, cellid,  lr, entrangle);
}

// attention , the unit of the sigma is mm
double  KalFitTrack::getSigma(KalFitHitMdc& hitmdc, double tanlam, int lr, double dist) const
{ 
	int layerid = hitmdc.wire().layer().layerId();
	double entrangle = hitmdc.rechitptr()->getEntra();
	//  double tanlam = hitmdc.rechitptr()->getTanl();
	double z = hitmdc.rechitptr()->getZhit();
	double Q = hitmdc.rechitptr()->getAdc();
	//std::cout<<" the driftdist  before getsigma is "<<dist<<" the layer is"<<layerid<<std::endl;
	//cout<<"layerid, lr, dist, entrangle, tanlam, z , Q = "<<layerid<<", "<<lr<<", "<<dist<<", "<<entrangle<<", "<<tanlam<<", "<<z<<", "<<Q<<endl;//wangll
	double temp = CalibFunSvc_->getSigma(layerid, lr, dist, entrangle, tanlam, z , Q );
	//std::cout<<" the sigma is "<<temp<<std::endl;
	return temp;
}

void KalFitTrack::setMdcCalibFunSvc(const MdcCalibFunSvc*  calibsvc)
{
	CalibFunSvc_ = calibsvc;
}

void KalFitTrack::setMagneticFieldSvc(IMagneticFieldSvc* mf)
{
	/*ISvcLocator* svcLocator = Gaudi::svcLocator();
	  StatusCode sc = svcLocator->service("MagneticFieldSvc",MFSvc_);
	  if (sc.isFailure()){
	  std::cout << "Could not load MagneticFieldSvc!" << std::endl;
	  }*/
	MFSvc_ = mf;
	if(MFSvc_==0) cout<<"KalFitTrack2:: Could not load MagneticFieldSvc!"<<endl;
} 

void KalFitTrack::setIMdcGeomSvc(IMdcGeomSvc*  igeomsvc)
{
	iGeomSvc_ = igeomsvc;
}

void KalFitTrack::setMdcDigiCol(MdcDigiCol*  digicol)
{
	mdcDigiCol_ = digicol;
}

