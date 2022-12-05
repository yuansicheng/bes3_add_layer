
//#include "TrackUtil/Helix.h"
#include "KalFitAlg/helix/Helix.h"
#include "KalFitAlg/KalFitWire.h"
#include "KalFitAlg/KalFitTrack.h"
#include "KalFitAlg/KalFitMaterial.h"
#include "KalFitAlg/KalFitElement.h"
#include "KalFitAlg/KalFitCylinder.h"
#include "MdcGeomSvc/MdcGeomSvc.h"
#include "GaudiKernel/Bootstrap.h"
#include "CLHEP/Matrix/Vector.h"
#include "CLHEP/Matrix/Matrix.h"
#include "CLHEP/Matrix/SymMatrix.h"
#include "CLHEP/Vector/ThreeVector.h"
#include "CLHEP/Units/PhysicalConstants.h"
#include "Math/Point3Dfwd.h"
#include "Math/Point3D.h"
#include "Math/Vector3D.h"

using namespace ROOT::Math;

using namespace KalmanFit;

using namespace CLHEP;


// for debug purpose .
int KalFitTrack::drifttime_choice_ = 0;
int KalFitTrack::debug_ = 0;
int KalFitTrack::numf_ = 0;
int KalFitTrack::numfcor_ = 1;
double KalFitTrack::Bznom_ = 10;
int KalFitTrack::steplev_ = 0;
int KalFitTrack::inner_steps_ = 3;
int KalFitTrack::outer_steps_ = 3;
// Mdc factors :
int KalFitTrack::Tof_correc_ = 1;
int KalFitTrack::strag_ = 1;
double KalFitTrack::chi2_hitf_ = 1000;
double KalFitTrack::chi2_hits_ = 1000;
double KalFitTrack::factor_strag_ = 0.4;
//double KalFitTrack::chi2_hitf_ = DBL_MAX;
int KalFitTrack::lead_ = 2;
int KalFitTrack::back_ = 1;
// attention resolflag !!!
int KalFitTrack::resolflag_ = 0;
int KalFitTrack::tofall_ = 1;
// chi2 cut set :
int KalFitTrack::nmdc_hit2_ = 500;
//int KalFitTrack::LR_ = 0;
int KalFitTrack::LR_ = 1;


double KalFitTrack::dchi2cutf_anal[43] = {0.};
double KalFitTrack::dchi2cuts_anal[43] = {0.};
double KalFitTrack::dchi2cutf_calib[43] = {0.};
double KalFitTrack::dchi2cuts_calib[43] = {0.};


///
double KalFitTrack::mdcGasRadlen_ = 0.;


const double KalFitTrack::MASS[NMASS] = { 0.000510999,
	0.105658,
	0.139568,
	0.493677,
	0.938272 };
const double
M_PI2 = 2. * M_PI;

const double
M_PI4 = 4. * M_PI;

const double
M_PI8 = 8. * M_PI;



// constructor
KalFitTrack::KalFitTrack(const HepPoint3D& pivot,
		const HepVector& a,
		const HepSymMatrix& Ea,
		unsigned int m, double chisq, unsigned int nhits)
: Helix(pivot, a, Ea), type_(0), insist_(0), chiSq_(0),
	nchits_(0), nster_(0), ncath_(0),
	ndf_back_(0), chiSq_back_(0), pathip_(0), 
	path_rd_(0), path_ab_(0), tof_(0), dchi2_max_(0), r_max_(0),
	tof_kaon_(0), tof_proton_(0), pat1_(0), pat2_(0), layer_prec_(0),
	trasan_id_(0), nhit_r_(0), nhit_z_(0),pathSM_(0),tof2_(0)
{
	memset(PathL_, 0, sizeof(PathL_));
	l_mass_ = m;
	if (m < NMASS) mass_ = MASS[m];
	else mass_ = MASS[2];
	r0_ = fabs(center().perp() - fabs(radius()));
	//bFieldZ(Bznom_);
	Bznom_=bFieldZ(); // 2012-09-13 wangll
	update_last();
}

// destructor
KalFitTrack::~KalFitTrack(void)
{
	// delete all objects

}

void KalFitTrack::update_last(void)
{
	pivot_last_ = pivot();
	a_last_ = a();
	Ea_last_ = Ea();
}

void KalFitTrack::update_forMdc(void)
{
	pivot_forMdc_ = pivot();
	a_forMdc_ = a();
	Ea_forMdc_ = Ea();
}

double KalFitTrack::intersect_cylinder(double r) const
{
	double m_rad = radius();
	double l = center().perp();

	double cosPhi = (m_rad * m_rad + l * l  - r * r) / (2 * m_rad * l);

	if(cosPhi < -1 || cosPhi > 1) return 0;

	double dPhi = center().phi() - acos(cosPhi) - phi0();

	if(dPhi < -M_PI) dPhi += 2 * M_PI;

	return dPhi;
}

double KalFitTrack::intersect_zx_plane(const HepTransform3D& plane,
		double y) const
{
	HepPoint3D xc = plane * center();
	double r = radius();
	double d = r * r - (y - xc.y()) * (y - xc.y());
	if(d < 0) return 0;

	double xx = xc.x();
	if(xx > 0) xx -= sqrt(d);
	else xx += sqrt(d);

	double l = (plane.inverse() *
			HepPoint3D(xx, y, 0)).perp();

	return intersect_cylinder(l);
}

double KalFitTrack::intersect_yz_plane(const HepTransform3D& plane,
		double x) const
{
	HepPoint3D xc = plane * center();
	double r = radius();
	double d = r * r - (x - xc.x()) * (x - xc.x());
	if(d < 0) return 0;

	double yy = xc.y();
	if(yy > 0) yy -= sqrt(d);
	else yy += sqrt(d);

	double l = (plane.inverse() *
			HepPoint3D(x, yy, 0)).perp();

	return intersect_cylinder(l);
}

double KalFitTrack::intersect_xy_plane(double z) const
{
	if (tanl() != 0 && radius() != 0)
		return (pivot().z() + dz() - z) / (radius() * tanl());
	else return 0;
}

void KalFitTrack::ms(double path,
		const KalFitMaterial& material, int index)
{
	HepSymMatrix ea = Ea();
	//cout<<"ms():path  "<<path<<endl;
	//cout<<"ms():ea before: "<<ea<<endl;
	double k = kappa();
	double t = tanl();
	double t2 = t * t;
	double pt2 = 1 + t2;
	double k2 = k * k;

	double pmag = 1 / fabs(k) * sqrt(pt2);
	double dth = material.mcs_angle(mass_, path, pmag);
	double dth2 = dth * dth;
	double pt2dth2 = pt2 * dth2;

	ea[1][1] += pt2dth2;
	ea[2][2] += k2 * t2 * dth2;
	ea[2][4] += k * t * pt2dth2;
	ea[4][4] += pt2 * pt2dth2;

	ea[3][3] += dth2 * path * path /3 / (1 + t2);
	ea[3][4] += dth2 * path/2 * sqrt(1 + t2);
	ea[3][2] += dth2 * t / sqrt(1 + t2) * k * path/2;
	ea[0][0] += dth2 * path * path/3;
	ea[0][1] += dth2 * sqrt(1 + t2) * path/2;

	Ea(ea);
	//cout<<"ms():ms angle in this: "<<dth<<endl;  
	//cout<<"ms():ea after: "<<Ea()<<endl;
	if (index < 0) {
		double x0 = material.X0();
		if (x0) path_rd_ += path/x0;
	}
}

void KalFitTrack::msgasmdc(double path, int index)
{
	double k = kappa();
	double t = tanl();
	double t2 = t * t;
	double k2 = k * k;

	double pmag = ( 1 / fabs(k) ) * sqrt(1 + t2);
	double psq = pmag*pmag;
	/*
	   double Zprims = 3/2*0.076 + 0.580/9.79*4.99*(4.99+1) +
	   0.041/183.85*74*(74+1) + 0.302/26.98 * 13 * (13+1);
	   double chicc = 0.00039612 * sqrt(Zprims * 0.001168);
	   double dth = 2.557 * chicc * sqrt(path * (mass_*mass_ + psq)) / psq;
	 */

	//std::cout<<" mdcGasRadlen: "<<mdcGasRadlen_<<std::endl;
	double pathx = path/mdcGasRadlen_;
	double dth =  0.0136* sqrt(pathx * (mass_*mass_ + psq))/psq 
		*(1 + 0.038 * log(pathx));;
	HepSymMatrix ea = Ea();
#ifdef YDEBUG
	cout<<"msgasmdc():path  "<<path<<"  pathx "<<pathx<<endl;
	cout<<"msgasmdc():dth  "<<dth<<endl;
	cout<<"msgasmdc():ea before: "<<ea<<endl;
#endif
	double dth2 = dth * dth;

	ea[1][1] += (1 + t2) * dth2;
	ea[2][2] += k2 * t2 * dth2;
	ea[2][4] += k * t * (1 + t2) * dth2;
	ea[4][4] += (1 + t2) * (1 + t2) * dth2;

	// additionnal terms (terms proportional to l and l^2)

	ea[3][3] += dth2 * path * path /3 / (1 + t2);
	ea[3][4] += dth2 * path/2 * sqrt(1 + t2);
	ea[3][2] += dth2 * t / sqrt(1 + t2) * k * path/2;
	ea[0][0] += dth2 * path * path/3;
	ea[0][1] += dth2 * sqrt(1 + t2) * path/2;

	Ea(ea);
#ifdef YDEBUG
	cout<<"msgasmdc():ea after: "<<Ea()<<endl;
#endif
	if (index < 0) {
		pathip_ += path;
		// RMK : put by hand, take care !!
		double x0 = mdcGasRadlen_; // for the Mdc gas
		path_rd_ += path/x0;
		tof(path);
#ifdef YDEBUG
		cout<<"ms...pathip..."<<pathip_<<endl;
#endif
	}
}

void KalFitTrack::eloss(double path,
		const KalFitMaterial& material, int index)
{
#ifdef YDEBUG
	cout<<"eloss():ea before: "<<Ea()<<endl;
#endif
	HepVector v_a = a();
	double v_a_2_2 = v_a[2] * v_a[2];
	double v_a_4_2 = v_a[4] * v_a[4];
	double pmag = 1 / fabs(v_a[2]) * sqrt(1 + v_a_4_2);
	double psq = pmag * pmag;
	double E = sqrt(mass_ * mass_ + psq);
	double dE = material.dE(mass_, path, pmag);
	//std::cout<<" eloss(): dE: "<<dE<<std::endl;//wangll

	if (index > 0) 
		psq += dE * (dE + 2 * sqrt(mass_ * mass_ + psq));
	else {
		double dE_max = E - mass_;
		if( dE<dE_max ) psq += dE * (dE - 2 * sqrt(mass_ * mass_ + psq));
		else psq=-1.0;
	}

	if (tofall_ && index < 0){
		// Kaon case :
		if (p_kaon_ > 0){
			double psq_kaon = p_kaon_ * p_kaon_;
			double dE_kaon = material.dE(MASS[3], path, p_kaon_);
			psq_kaon += dE_kaon * (dE_kaon - 
					2 * sqrt(MASS[3] * MASS[3] + psq_kaon));
			if (psq_kaon < 0) psq_kaon = 0;
			p_kaon_ = sqrt(psq_kaon);
		}
		// Proton case :
		if (p_proton_ > 0){
			double psq_proton = p_proton_ * p_proton_;
			double dE_proton = material.dE(MASS[4], path, p_proton_);
			psq_proton += dE_proton * (dE_proton - 
					2 * sqrt(MASS[4] * MASS[4] + psq_proton));
			if (psq_proton < 0) psq_proton = 0;
			p_proton_ = sqrt(psq_proton);
		}
	}

	double dpt;
	//cout<<"eloss(): psq = "<<psq<<endl;//wangll
	if(psq < 0) dpt = 9999;
	else dpt = v_a[2] * pmag / sqrt(psq);
	//cout<<"eloss():k:   "<<v_a[2]<<"  k'  "<<dpt<<endl;//wangll
#ifdef YDEBUG
	cout<<"eloss():k:   "<<v_a[2]<<"  k'  "<<dpt<<endl;
#endif
	// attempt to take account of energy loss for error matrix 

	HepSymMatrix ea = Ea();
	double r_E_prim = (E + dE)/E;

	// 1/ Straggling in the energy loss :
	if (strag_){
		double del_E(0);
		if(l_mass_==0) {
			del_E = dE*factor_strag_;
		}   else  {
			del_E  = material.del_E(mass_, path, pmag);
		}

		ea[2][2] += (v_a[2] * v_a[2]) * E * E * del_E * del_E / (psq*psq);
	}

	// Effect of the change of curvature (just variables change):
	double dpt2 = dpt*dpt;
	double A = dpt*dpt2/(v_a_2_2*v_a[2])*r_E_prim;
	double B = v_a[4]/(1+v_a_4_2)*
		dpt*(1-dpt2/v_a_2_2*r_E_prim);

	double ea_2_0 = A*ea[2][0] + B*ea[4][0];
	double ea_2_1 = A*ea[2][1] + B*ea[4][1];
	double ea_2_2 = A*A*ea[2][2] + 2*A*B*ea[2][4] + B*B*ea[4][4]; 
	double ea_2_3 = A*ea[2][3] + B*ea[4][3]; 
	double ea_2_4 = A*ea[2][4] + B*ea[4][4];

	v_a[2] = dpt;
	a(v_a);

	ea[2][0] = ea_2_0;
	//std::cout<<"ea[2][0] is "<<ea[2][0]<<" ea(3,1) is "<<ea(3,1)<<std::endl;
	ea[2][1] = ea_2_1;
	//std::cout<<"ea[2][2] is "<<ea[2][2]<<" ea(3,3) is "<<ea(3,3)<<std::endl;
	ea[2][2] = ea_2_2;
	ea[2][3] = ea_2_3;
	ea[2][4] = ea_2_4;

	Ea(ea);
	//cout<<"eloss():dE:   "<<dE<<endl;
	//cout<<"eloss():A:   "<<A<<"   B:    "<<B<<endl;
	//cout<<"eloss():ea after: "<<Ea()<<endl;
	r0_ = fabs(center().perp() - fabs(radius()));
}

void KalFitTrack::order_wirhit(int index)
{
	unsigned int nhit = HitsMdc_.size();
	Helix tracktest = *(Helix*)this;
	int ind = 0;
	double* Rad = new double[nhit];
	double* Ypos = new double[nhit];
	for( unsigned i=0 ; i < nhit; i++ ){

		HepPoint3D fwd(HitsMdc_[i].wire().fwd());
		HepPoint3D bck(HitsMdc_[i].wire().bck());
		Hep3Vector wire = (CLHEP::Hep3Vector)fwd -(CLHEP::Hep3Vector)bck;

		// Modification for stereo wires :
		Helix work = tracktest;
		work.ignoreErrorMatrix();
		work.pivot((fwd + bck) * .5);
		HepPoint3D x0 = (work.x(0).z() - bck.z())
			/ wire.z() * wire + bck;

		tracktest.pivot(x0);
		Rad[ind] = tracktest.x(0).perp();
		Ypos[ind] = x0.y();
		ind++;
		//cout<<"Ypos: "<<Ypos[ind-1]<<endl;
	}

	// Reorder...
	if (index < 0)
		for(int j, k = nhit - 1; k >= 0; k = j){
			j = -1;
			for(int i = 1; i <= k; i++)
				if(Rad[i - 1] > Rad[i]){
					j = i - 1;
					std::swap(Rad[i], Rad[j]);
					std::swap(HitsMdc_[i], HitsMdc_[j]);
				}
		}
	if (index > 0)
		for(int j, k = nhit - 1; k >= 0; k = j){
			j = -1;
			for(int i = 1; i <= k; i++)
				if(Rad[i - 1] < Rad[i]){
					j = i - 1;
					std::swap(Rad[i], Rad[j]);
					std::swap(HitsMdc_[i], HitsMdc_[j]);
				}
		}
	if (index == 0)
		for(int j, k = nhit - 1; k >= 0; k = j){
			j = -1;
			for(int i = 1; i <= k; i++)
				if(Ypos[i - 1] > Ypos[i]){
					j = i - 1;
					std::swap(Ypos[i], Ypos[j]);
					std::swap(HitsMdc_[i], HitsMdc_[j]);
				}
		}
	delete [] Rad;
	delete [] Ypos;
}

void KalFitTrack::order_hits(void){
	for(int it=0; it<HitsMdc().size()-1; it++){
		if(HitsMdc_[it].wire().layer().layerId() == HitsMdc_[it+1].wire().layer().layerId())    
		{
			if((kappa()<0)&&(HitsMdc_[it].wire().localId() > HitsMdc_[it+1].wire().localId())){
				std::swap(HitsMdc_[it], HitsMdc_[it+1]);
			}
			if((kappa()>0)&&(HitsMdc_[it].wire().localId() < HitsMdc_[it+1].wire().localId())){
				std::swap(HitsMdc_[it], HitsMdc_[it+1]);
			}
		}
	}
}


void KalFitTrack::number_wirhit(void)
{
	unsigned int nhit = HitsMdc_.size();
	int Num[50] = {0};
	for( unsigned i=0 ; i < nhit; i++ )
		Num[HitsMdc_[i].wire().layer().layerId()]++;
	for( unsigned i=0 ; i < nhit; i++ )
		if (Num[HitsMdc_[i].wire().layer().layerId()]>2)
			HitsMdc_[i].chi2(-2);
}


double KalFitTrack::smoother_Mdc(KalFitHitMdc& HitMdc, Hep3Vector& meas, KalFitHelixSeg& seg, double& dchi2, int csmflag)
{
	// 
	double lr = HitMdc.LR();
	// For taking the propagation delay into account :
	int wire_ID = HitMdc.wire().geoID(); // from 0 to 6796
	int layerid = HitMdc.wire().layer().layerId();
	double entrangle = HitMdc.rechitptr()->getEntra();
	if (wire_ID<0 || wire_ID>6796){ //bes
		std::cout << "KalFitTrack : wire_ID problem : " << wire_ID << std::endl;
		return 0;
	} 

	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};

	double tofest(0);
	double dd(0.);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;

	if (Tof_correc_) {
		Hep3Vector ip(0, 0, 0);
		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		work.pivot(ip);
		double phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		double t = tanl();
		double l = fabs(radius() * (phi - phi_ip) * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && HitMdc.wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	const HepVector& v_a = a();

	HepPoint3D pivot_work = pivot();

	double dchi2R(99999999), dchi2L(99999999);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;  
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNew(5);
	HepVector aNew(5);

	//double time = HitMdc.tdc();
	// if (Tof_correc_)
	//  time -= tofest;

	double drifttime = getDriftTime(HitMdc , tofest); 
	//cout<<"drifttime = "<<drifttime<<endl;
	seg.dt(drifttime);
	double ddl = getDriftDist(HitMdc, drifttime, 0);
	double ddr = getDriftDist(HitMdc, drifttime, 1);
	/*cout<<endl<<" $$$  smoother_Mdc():: "<<endl;//wangll
	cout<<"pivot = "<<pivot()<<endl;//wangll
	cout<<"helix = "<<a()<<endl;//wangll
	cout<<"drifttime = "<<drifttime<<endl;//wangll
	cout<<"ddl, ddr = "<<ddl<<", "<<ddr<<endl;//wangll
	*/
	double erddl = getSigma( HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( HitMdc, a()[4], 1, ddr); 

	//  double dd = 1.0e-4 * 40.0 * time;
	double dmeas2[2] = { 0.1*ddl, 0.1*ddr }; //millimeter to centimeter 
	double er_dmeas2[2] = {0. , 0.};
	if(resolflag_== 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//int layid = HitMdc.wire().layer().layerId();
		//double sigma = getSigma(layid, dd);
		//er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	// Left hypothesis :
	if (lr == -1) {
		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*dmeas2[0];  // the dmeas&erdmeas  calculated by myself 
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs(HitMdc.dist()[0]); // the dmeas&erdmeas  calculated by track-finding algorithm
			er_dmeasL = HitMdc.erdist()[0];
		}

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNew.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNew = v_a + diffL;
		double sigL = (dmeasL - (v_HT * aNew)[0]);
		dchi2L =  (sigL*sigL) /  (RkL * er_dmeasL*er_dmeasL);
	} else if (lr == 1) {
		// Right hypothesis :

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs(HitMdc.dist()[1]);
			er_dmeasR = HitMdc.erdist()[1];
		}


		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNew.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNew = v_a + diffR;
		double sigR = (dmeasR- (v_HT * aNew)[0]);
		dchi2R =  (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	}

	// Update Kalman result :
#ifdef YDEBUG
	cout<<"in smoother_Mdc: lr= "<<lr<<" a: "<<v_a<<" a_NEW: "<<aNew<<endl;
#endif
	double dchi2_loc(0);
	if ((dchi2R < dchi2cuts_anal[layerid] && lr == 1) || 
			(dchi2L < dchi2cuts_anal[layerid] && lr == -1)) {
		ndf_back_++;
		int chge(1);
		if ( !( aNew[2] && fabs(aNew[2]-a()[2]) < 1.0 ) ) chge=0;
		if (lr == 1) {
			chiSq_back_ += dchi2R;
			dchi2_loc = dchi2R;
			dd = 0.1*ddr;
		} else if (lr == -1) {
			chiSq_back_ += dchi2L;
			dchi2_loc = dchi2L;
			dd = -0.1*ddl;
		} 
		if (chge){
			a(aNew);
			Ea(eaNew);
		}
	}
	dchi2=dchi2_loc;

	seg.doca_include(fabs((v_HT*a())[0]));
	seg.doca_exclude(fabs(estim));
	/// move the pivot of the helixseg to IP(0,0,0)
	Hep3Vector ip(0, 0, 0);
	KalFitTrack helixNew1(pivot_work, a(), Ea(), 0, 0, 0);
	helixNew1.pivot(ip);
	HepVector    a_temp1  = helixNew1.a();
	HepSymMatrix ea_temp1 = helixNew1.Ea();
	seg.Ea(ea_temp1);
	seg.a(a_temp1);
	seg.Ea_include(ea_temp1);
	seg.a_include(a_temp1);

	KalFitTrack helixNew2(pivot_work, v_a, ea, 0, 0, 0);
	helixNew2.pivot(ip);
	HepVector    a_temp2  = helixNew2.a();
	HepSymMatrix ea_temp2 = helixNew2.Ea();
	seg.Ea_exclude(ea_temp2);
	seg.a_exclude(a_temp2);

	seg.tof(tofest);
	seg.dd(dd);

	return chiSq_back_;
}

// Smoothing procedure in Mdc cosmic align
// RMK attention for the case chi2R = chi2L during forward filter !
double KalFitTrack::smoother_Mdc_csmalign(KalFitHelixSeg& seg, Hep3Vector& meas,int& flg, int csmflag )
{


	HepPoint3D ip(0., 0., 0.);
	// attention! we should not to decide the left&right in the smoother process,
	// because we choose the left&right of hits from the filter process. 

	KalFitHitMdc* HitMdc = seg.HitMdc();
	double lr = HitMdc->LR();

	// For taking the propagation delay into account :
	int layerid  = (*HitMdc).wire().layer().layerId();
	int wire_ID = HitMdc->wire().geoID();
	double entrangle = HitMdc->rechitptr()->getEntra();

	if (wire_ID<0 || wire_ID>6796){ //bes
		std::cout << "KalFitTrack : wire_ID problem : " << wire_ID << std::endl;
		return 0;
	} 

	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double dd(0.);
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;

	if (Tof_correc_) {
		Hep3Vector ip(0, 0, 0);
		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		work.pivot(ip);
		double phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		double t = tanl();
		double l = fabs(radius() * (phi - phi_ip) * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && (*HitMdc).wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	const HepVector& v_a = a();


	HepPoint3D pivot_work = pivot();

	/*
	   HepVector a_work = a();
	   HepSymMatrix ea_work = Ea();

	   KalFitTrack helix_work(pivot_work, a_work, ea_work, 0, 0, 0);
	   helix_work.pivot(ip);

	   HepVector a_temp = helix_work.a();
	   HepSymMatrix ea_temp = helix_work.Ea();

	   seg.Ea_pre_bwd(ea_temp);	
	   seg.a_pre_bwd(a_temp);

	 */

	seg.a_pre_bwd(a()); 
	seg.Ea_pre_bwd(Ea()); 

	double dchi2R(99999999), dchi2L(99999999);
	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;  
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;
	HepSymMatrix eaNew(5);
	HepVector aNew(5);
	double time = (*HitMdc).tdc();

	//seg.dt(time);
	// if (Tof_correc_)
	// { 
	//  time -= tofest;
	//  seg.dt(time);
	// }
	// double dd = 1.0e-4 * 40.0 * time;
	// seg.dd(dd);

	double drifttime = getDriftTime(*HitMdc , tofest);
	seg.dt(drifttime);
	double ddl = getDriftDist(*HitMdc, drifttime, 0 );
	double ddr = getDriftDist(*HitMdc, drifttime, 1 );
	double erddl = getSigma( *HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( *HitMdc, a()[4], 1, ddr);

	double dmeas2[2] = { 0.1*ddl, 0.1*ddr }; // millimeter to centimeter
	double er_dmeas2[2] = {0., 0.};
	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	}else if(resolflag_ == 0)  
	{
	}

	// Left hypothesis :
	if (lr == -1) {
		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*dmeas2[0];
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs((*HitMdc).dist()[0]);
			er_dmeasL = (*HitMdc).erdist()[0];
		}


		//if(layerid < 4)  er_dmeasL*=2.0;

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNew.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNew = v_a + diffL;
		double sigL = (dmeasL - (v_HT * aNew)[0]);
		dchi2L =  (sigL*sigL) /  (RkL * er_dmeasL*er_dmeasL);
	} else if (lr == 1) {
		// Right hypothesis :

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs((*HitMdc).dist()[1]);
			er_dmeasR = (*HitMdc).erdist()[1];
		}


		//if(layerid < 4)  er_dmeasR*=2.0;


		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNew.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNew = v_a + diffR;
		double sigR = (dmeasR- (v_HT * aNew)[0]);
		dchi2R =  (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	}

	// Update Kalman result :
#ifdef YDEBUG
	cout<<"in smoother_Mdc: lr= "<<lr<<" a: "<<v_a<<" a_NEW: "<<aNew<<endl;
#endif
	double dchi2_loc(0);
	if ((dchi2R < dchi2cuts_calib[layerid] && lr == 1) || 
			(dchi2L < dchi2cuts_calib[layerid] && lr == -1)) {

		ndf_back_++;
		flg = 1;
		int chge(1);
		if (!(aNew[2] && fabs(aNew[2]-a()[2]) < 1.0))  chge = 0;
		if (lr == 1) {
			chiSq_back_ += dchi2R;
			dchi2_loc = dchi2R;
			dd = 0.1*ddr;
			// if(debug_ ==4) std::cout<<"in  smoother "<<std::endl;

		} else if (lr == -1) {
			chiSq_back_ += dchi2L;
			dchi2_loc = dchi2L;
			dd = -0.1*ddl;

		} 
		if (chge){
			a(aNew);
			Ea(eaNew);
		}

		seg.a_filt_bwd(aNew);
		seg.Ea_filt_bwd(eaNew);

		HepVector a_pre_fwd_temp=seg.a_pre_fwd();
		if( (a_pre_fwd_temp[1]-seg.a_pre_bwd()[1]) > 3. * M_PI /2.)  a_pre_fwd_temp[1]-= M_PI2;
		if( (a_pre_fwd_temp[1]-seg.a_pre_bwd()[1]) < -3. * M_PI /2. )  a_pre_fwd_temp[1]+= M_PI2;

		seg.a_pre_fwd(a_pre_fwd_temp);

		HepVector a_pre_filt_temp=seg.a_filt_fwd();
		if( (a_pre_filt_temp[1]-seg.a_pre_bwd()[1]) > 3. * M_PI /2. )  a_pre_filt_temp[1] -= M_PI2;
		if( (a_pre_filt_temp[1]-seg.a_pre_bwd()[1]) < -3. * M_PI /2.)  a_pre_filt_temp[1] += M_PI2;
		seg.a_filt_fwd(a_pre_filt_temp);

		/*   
		     KalFitTrack helixNew(pivot_work, aNew, eaNew, 0, 0, 0);
		     helixNew.pivot(ip);
		     a_temp = helixNew.a();
		     ea_temp = helixNew.Ea();
		     seg.Ea_filt_bwd(ea_temp);
		     seg.a_filt_bwd(a_temp);
		 */

		int inv;

		if(debug_ == 4){
			std::cout<<"seg.Ea_pre_bwd().inverse(inv) ..."<<seg.Ea_pre_bwd().inverse(inv)<<std::endl;
			std::cout<<"seg.Ea_pre_fwd().inverse(inv) ..."<<seg.Ea_pre_fwd().inverse(inv)<<std::endl;
		}

		HepSymMatrix  Ea_pre_comb = (seg.Ea_pre_bwd().inverse(inv)+seg.Ea_pre_fwd().inverse(inv)).inverse(inv);
		seg.Ea_exclude(Ea_pre_comb);


		if(debug_ == 4) {
			std::cout<<"Ea_pre_comb_ ... "<<Ea_pre_comb<<std::endl;
			std::cout<<"seg.a_pre_bwd()..."<<seg.a_pre_bwd()<<std::endl;
			std::cout<<"seg.a_pre_fwd()..."<<seg.a_pre_fwd()<<std::endl;
		}
		HepVector  a_pre_comb = Ea_pre_comb*((seg.Ea_pre_bwd().inverse(inv))*seg.a_pre_bwd()+(seg.Ea_pre_fwd().inverse(inv))*seg.a_pre_fwd());
		seg.a_exclude(a_pre_comb);

		if(debug_ == 4) {
			std::cout<<"seg.Ea_filt_fwd()..."<<seg.Ea_filt_fwd()<<std::endl;
			std::cout<<"seg.Ea_filt_fwd().inverse(inv)..."<<seg.Ea_filt_fwd().inverse(inv)<<std::endl;
		}
		seg.Ea((seg.Ea_filt_fwd().inverse(inv)+seg.Ea_pre_bwd().inverse(inv)).inverse(inv));
		seg.Ea_include((seg.Ea_filt_fwd().inverse(inv)+seg.Ea_pre_bwd().inverse(inv)).inverse(inv));

		if(debug_ == 4) {
			std::cout<<"seg.Ea() is ..."<<seg.Ea()<<std::endl;
			std::cout<<"seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd() ..."<<seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()<<std::endl;
			std::cout<<"seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd() ... "<<seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()<<std::endl;
		}

		seg.a(seg.Ea()*(seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()+seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()));
		seg.a_include(seg.Ea()*(seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()+seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()));

		if(inv != 0) {
			//std::cout<<"ERROR OCCUR WHEN INVERSE MATRIX !"<<std::endl;
		}

		seg.residual_exclude(dd - (v_HT*a_pre_comb)[0]);
		seg.residual_include(dd - (v_HT*seg.a())[0]);
		seg.doca_exclude(fabs((v_HT*a_pre_comb)[0]));
		seg.doca_include(fabs((v_HT*seg.a())[0]));

		if(debug_ == 4){
			std::cout<<"the dd in smoother_Mdc is "<<dd
				<<" the (v_HT*a_pre_comb)[0] is "<<(v_HT*a_pre_comb)[0]<<std::endl;
		}

		//compare the two method to calculate the include doca value : 
		if(debug_ == 4){
			std::cout<<"method 1 ..."<<sqrt(seg.a()[0]*seg.a()[0]+seg.a()[3]*seg.a()[3])<<std::endl;
			std::cout<<"method 2 ..."<<fabs((v_HT*seg.a())[0])<<std::endl;
		}


		/// move the pivot of the helixseg to IP(0,0,0)
		KalFitTrack helixNew1(pivot_work, seg.a(), seg.Ea(), 0, 0, 0);
		helixNew1.pivot(ip);
		HepVector    a_temp1  = helixNew1.a();
		HepSymMatrix ea_temp1 = helixNew1.Ea();
		seg.Ea(ea_temp1);
		seg.a(a_temp1);
		seg.Ea_include(ea_temp1);
		seg.a_include(a_temp1);

		KalFitTrack helixNew2(pivot_work, seg.a_exclude(), seg.Ea_exclude(), 0, 0, 0);
		helixNew2.pivot(ip);
		HepVector    a_temp2  = helixNew2.a();
		HepSymMatrix ea_temp2 = helixNew2.Ea();	   
		seg.Ea_exclude(ea_temp2);		     
		seg.a_exclude(a_temp2);		    

		seg.tof(tofest);
		seg.dd(dd);

	}
	return chiSq_back_;
}

// Smoothing procedure in Mdc calib
// RMK attention for the case chi2R = chi2L during forward filter !
double KalFitTrack::smoother_Mdc(KalFitHelixSeg& seg, Hep3Vector& meas,int& flg, int csmflag )
{


	HepPoint3D ip(0., 0., 0.);
	// attention! we should not to decide the left&right in the smoother process,
	// because we choose the left&right of hits from the filter process. 

	KalFitHitMdc* HitMdc = seg.HitMdc();
	double lr = HitMdc->LR();

	// For taking the propagation delay into account :
	int layerid  = (*HitMdc).wire().layer().layerId();
	int wire_ID = HitMdc->wire().geoID();
	double entrangle = HitMdc->rechitptr()->getEntra();

	if (wire_ID<0 || wire_ID>6796){ //bes
		std::cout << "KalFitTrack : wire_ID problem : " << wire_ID << std::endl;
		return 0;
	} 

	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double dd(0.);
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;

	if (Tof_correc_) {
		Hep3Vector ip(0, 0, 0);
		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		work.pivot(ip);
		double phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		double t = tanl();
		double l = fabs(radius() * (phi - phi_ip) * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && (*HitMdc).wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	const HepVector& v_a = a();



	HepPoint3D pivot_work = pivot();

	/*
	   HepVector a_work = a();
	   HepSymMatrix ea_work = Ea();

	   KalFitTrack helix_work(pivot_work, a_work, ea_work, 0, 0, 0);
	   helix_work.pivot(ip);

	   HepVector a_temp = helix_work.a();
	   HepSymMatrix ea_temp = helix_work.Ea();

	   seg.Ea_pre_bwd(ea_temp);	
	   seg.a_pre_bwd(a_temp);

	 */

	seg.a_pre_bwd(a()); 
	seg.Ea_pre_bwd(Ea()); 

	double dchi2R(99999999), dchi2L(99999999);
	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;  
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;
	HepSymMatrix eaNew(5);
	HepVector aNew(5);
	double time = (*HitMdc).tdc();

	//seg.dt(time);
	// if (Tof_correc_)
	// { 
	//  time -= tofest;
	//  seg.dt(time);
	// }
	// double dd = 1.0e-4 * 40.0 * time;
	// seg.dd(dd);

	double drifttime = getDriftTime(*HitMdc , tofest);
	seg.dt(drifttime);
	double ddl = getDriftDist(*HitMdc, drifttime, 0 );
	double ddr = getDriftDist(*HitMdc, drifttime, 1 );
	double erddl = getSigma( *HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( *HitMdc, a()[4], 1, ddr);

	double dmeas2[2] = { 0.1*ddl, 0.1*ddr }; // millimeter to centimeter
	double er_dmeas2[2] = {0., 0.};
	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	}else if(resolflag_ == 0)  
	{
	}

	// Left hypothesis :
	if (lr == -1) {
		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*dmeas2[0];
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs((*HitMdc).dist()[0]);
			er_dmeasL = (*HitMdc).erdist()[0];
		}


		//if(layerid < 4)  er_dmeasL*=2.0;

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNew.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNew = v_a + diffL;
		double sigL = (dmeasL - (v_HT * aNew)[0]);
		dchi2L =  (sigL*sigL) /  (RkL * er_dmeasL*er_dmeasL);
	} else if (lr == 1) {
		// Right hypothesis :

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs((*HitMdc).dist()[1]);
			er_dmeasR = (*HitMdc).erdist()[1];
		}


		//if(layerid < 4)  er_dmeasR*=2.0;


		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNew.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNew = v_a + diffR;
		double sigR = (dmeasR- (v_HT * aNew)[0]);
		dchi2R =  (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	}

	// Update Kalman result :
#ifdef YDEBUG
	cout<<"in smoother_Mdc: lr= "<<lr<<" a: "<<v_a<<" a_NEW: "<<aNew<<endl;
#endif
	double dchi2_loc(0);
	if ((dchi2R < dchi2cuts_calib[layerid] && lr == 1) || 
			(dchi2L < dchi2cuts_calib[layerid] && lr == -1)) {

		ndf_back_++;
		flg = 1;
		int chge(1);
		if (!(aNew[2] && fabs(aNew[2]-a()[2]) < 1.0))  chge = 0;
		if (lr == 1) {
			chiSq_back_ += dchi2R;
			dchi2_loc = dchi2R;
			dd = 0.1*ddr;
			// if(debug_ ==4) std::cout<<"in  smoother "<<std::endl;

		} else if (lr == -1) {
			chiSq_back_ += dchi2L;
			dchi2_loc = dchi2L;
			dd = -0.1*ddl;

		} 
		if (chge){
			a(aNew);
			Ea(eaNew);
		}

		seg.a_filt_bwd(aNew);
		seg.Ea_filt_bwd(eaNew);

		HepVector a_pre_fwd_temp=seg.a_pre_fwd();
		if( (a_pre_fwd_temp[1]-seg.a_pre_bwd()[1]) > 3. * M_PI /2.)  a_pre_fwd_temp[1]-= M_PI2;
		if( (a_pre_fwd_temp[1]-seg.a_pre_bwd()[1]) < -3. * M_PI /2. )  a_pre_fwd_temp[1]+= M_PI2;

		seg.a_pre_fwd(a_pre_fwd_temp);

		HepVector a_pre_filt_temp=seg.a_filt_fwd();
		if( (a_pre_filt_temp[1]-seg.a_pre_bwd()[1]) > 3. * M_PI /2. )  a_pre_filt_temp[1] -= M_PI2;
		if( (a_pre_filt_temp[1]-seg.a_pre_bwd()[1]) < -3. * M_PI /2.)  a_pre_filt_temp[1] += M_PI2;
		seg.a_filt_fwd(a_pre_filt_temp);

		/*   
		     KalFitTrack helixNew(pivot_work, aNew, eaNew, 0, 0, 0);
		     helixNew.pivot(ip);
		     a_temp = helixNew.a();
		     ea_temp = helixNew.Ea();
		     seg.Ea_filt_bwd(ea_temp);
		     seg.a_filt_bwd(a_temp);
		 */

		int inv;

		if(debug_ == 4){
			std::cout<<"seg.Ea_pre_bwd().inverse(inv) ..."<<seg.Ea_pre_bwd().inverse(inv)<<std::endl;
			std::cout<<"seg.Ea_pre_fwd().inverse(inv) ..."<<seg.Ea_pre_fwd().inverse(inv)<<std::endl;
		}

		HepSymMatrix  Ea_pre_comb = (seg.Ea_pre_bwd().inverse(inv)+seg.Ea_pre_fwd().inverse(inv)).inverse(inv);
		seg.Ea_exclude(Ea_pre_comb);


		if(debug_ == 4) {
			std::cout<<"Ea_pre_comb_ ... "<<Ea_pre_comb<<std::endl;
			std::cout<<"seg.a_pre_bwd()..."<<seg.a_pre_bwd()<<std::endl;
			std::cout<<"seg.a_pre_fwd()..."<<seg.a_pre_fwd()<<std::endl;
		}
		HepVector  a_pre_comb = Ea_pre_comb*((seg.Ea_pre_bwd().inverse(inv))*seg.a_pre_bwd()+(seg.Ea_pre_fwd().inverse(inv))*seg.a_pre_fwd());
		seg.a_exclude(a_pre_comb);


		if(debug_ == 4) {
			std::cout<<"seg.Ea_filt_fwd()..."<<seg.Ea_filt_fwd()<<std::endl;
			std::cout<<"seg.Ea_filt_fwd().inverse(inv)..."<<seg.Ea_filt_fwd().inverse(inv)<<std::endl;
		}
		seg.Ea((seg.Ea_filt_fwd().inverse(inv)+seg.Ea_pre_bwd().inverse(inv)).inverse(inv));
		seg.Ea_include((seg.Ea_filt_fwd().inverse(inv)+seg.Ea_pre_bwd().inverse(inv)).inverse(inv));

		if(debug_ == 4) {
			std::cout<<"seg.Ea() is ..."<<seg.Ea()<<std::endl;
			std::cout<<"seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd() ..."<<seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()<<std::endl;
			std::cout<<"seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd() ... "<<seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()<<std::endl;
		}

		seg.a(seg.Ea()*(seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()+seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()));
		seg.a_include(seg.Ea()*(seg.Ea_filt_fwd().inverse(inv)*seg.a_filt_fwd()+seg.Ea_pre_bwd().inverse(inv)*seg.a_pre_bwd()));

		if(inv != 0) {
			//std::cout<<"ERROR OCCUR WHEN INVERSE MATRIX !"<<std::endl;
		}

		seg.residual_exclude(dd - (v_HT*a_pre_comb)[0]);
		seg.residual_include(dd - (v_HT*seg.a())[0]);
		seg.doca_exclude(fabs((v_HT*a_pre_comb)[0]));
		seg.doca_include(fabs((v_HT*seg.a())[0]));

		if(debug_ == 4){
			std::cout<<"the dd in smoother_Mdc is "<<dd
				<<" the (v_HT*a_pre_comb)[0] is "<<(v_HT*a_pre_comb)[0]<<std::endl;
		}

		//compare the two method to calculate the include doca value : 
		if(debug_ == 4){
			std::cout<<"method 1 ..."<<sqrt(seg.a()[0]*seg.a()[0]+seg.a()[3]*seg.a()[3])<<std::endl;
			std::cout<<"method 2 ..."<<fabs((v_HT*seg.a())[0])<<std::endl;
		}


		/// move the pivot of the helixseg to IP(0,0,0)
		KalFitTrack helixNew1(pivot_work, seg.a(), seg.Ea(), 0, 0, 0);
		helixNew1.pivot(ip);
		HepVector    a_temp1  = helixNew1.a();
		HepSymMatrix ea_temp1 = helixNew1.Ea();
		seg.Ea(ea_temp1);
		seg.a(a_temp1);
		seg.Ea_include(ea_temp1);
		seg.a_include(a_temp1);

		KalFitTrack helixNew2(pivot_work, seg.a_exclude(), seg.Ea_exclude(), 0, 0, 0);
		helixNew2.pivot(ip);
		HepVector    a_temp2  = helixNew2.a();
		HepSymMatrix ea_temp2 = helixNew2.Ea();	   
		seg.Ea_exclude(ea_temp2);		     
		seg.a_exclude(a_temp2);		    

		seg.tof(tofest);
		seg.dd(dd);

	}
	return chiSq_back_;
}





double KalFitTrack::filter(double v_m, const HepVector& m_H,
		double v_d, double m_V)
{
	HepMatrix m_HT = m_H.T();
	HepPoint3D x0 = x(0);
	HepVector v_x(3);
	v_x[0] = x0.x();
	v_x[1] = x0.y();
	v_x[2] = x0.z();
	HepMatrix m_X = delXDelA(0);
	HepMatrix m_XT = m_X.T();
	HepMatrix m_C = m_X * Ea() * m_XT;
	//int err;
	HepVector m_K = 1 / (m_V + (m_HT * m_C * m_H)[0]) * m_H;
	HepVector v_a = a();
	HepSymMatrix ea = Ea();
	HepMatrix mXTmK = m_XT * m_K;
	double v_r = v_m - v_d - (m_HT * v_x)[0];
	v_a += ea * mXTmK * v_r;
	a(v_a);
	ea.assign(ea - ea * mXTmK * m_HT * m_X * ea);
	Ea(ea);
	// Record last hit included parameters :
	update_last();
	HepMatrix mCmK = m_C * m_K;
	v_x += mCmK * v_r;
	m_C -= mCmK * m_HT * m_C;
	v_r = v_m - v_d - (m_HT * v_x)[0];
	double m_R = m_V - (m_HT * m_C * m_H)[0];
	double chiSq = v_r * v_r / m_R;
	chiSq_ += chiSq;
	return chiSq;
}


void KalFitTrack::path_add(double path)
{
	pathip_ += path;
	tof(path);
}


void KalFitTrack::addPathSM(double path){
	pathSM_ += path;
}


void KalFitTrack::addTofSM(double time){
	tof2_ += time;
} 


void KalFitTrack::fiTerm(double fi){
	fiTerm_ = fi;
}


void KalFitTrack::tof(double path)
{
	double light_speed( 29.9792458 );     // light speed in cm/nsec
	double t = tanl();
	double pmag( sqrt( 1.0 + t*t ) / kappa());
	if (pmag !=0) {
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tof_ += path / ( light_speed * beta );
	}

	if (tofall_) {
		if (p_kaon_ > 0){
			double massk_over_p( MASS[3] / p_kaon_ );
			double beta_kaon( 1.0 / sqrt( 1.0 + massk_over_p * massk_over_p ) );
			tof_kaon_ += path / (light_speed * beta_kaon);
		}
		if (p_proton_ > 0){
			double massp_over_p( MASS[4] / p_proton_ );
			double beta_proton( 1.0 / sqrt( 1.0 + massp_over_p * massp_over_p ) );
			tof_proton_ += path / (light_speed * beta_proton);
		}
	}
}

double KalFitTrack::radius_numf(void) const {

	double Bz(Bznom_);
	//std::cout<<"Bz: "<<Bz<<std::endl;
	if (numf_ > 10){
		double dr    = a()[0];
		double phi0  = a()[1];
		double dz    = a()[3];
		double phi = fmod(phi0 + M_PI4, M_PI2);
		double csf0 = cos(phi);
		double snf0 = (1. - csf0) * (1. + csf0);
		snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
		if(phi > M_PI) snf0 = - snf0;
		//XYZPoint
		HepPoint3D x0((pivot().x() + dr*csf0),
				(pivot().y() + dr*snf0),
				(pivot().z() + dz));

		//XYZVector b;
		HepVector3D b;

		//std::cout<<"b: "<<b<<std::endl;

		MFSvc_->fieldVector(10.*x0, b);

		//std::cout<<"b: "<<b<<std::endl;


		b = 10000.*b;
		Bz = b.z();
	}
	if (Bz == 0)
		Bz = Bznom_;
	double ALPHA_loc = 10000./2.99792458/Bz;
	return ALPHA_loc / a()[2];
}

const HepPoint3D &
KalFitTrack::pivot_numf(const HepPoint3D & newPivot) {

	int nstep(1);
	HepPoint3D  delta_x((newPivot-pivot()).x()/double(inner_steps_),
			(newPivot-pivot()).y()/double(inner_steps_),
			(newPivot-pivot()).z()/double(inner_steps_));
	int i = 1;

	while (i <= inner_steps_) {
		HepPoint3D nextPivot(pivot()+delta_x);
		double xnp(nextPivot.x()), ynp(nextPivot.y()), znp(nextPivot.z());  
		HepSymMatrix Ea_now = Ea();
		HepPoint3D piv(pivot());
		double xp(piv.x()), yp(piv.y()), zp(piv.z());  
		double dr    = a()[0];
		double phi0  = a()[1];
		double kappa = a()[2];
		double dz    = a()[3];
		double tanl  = a()[4];
		double m_rad(0);
		if (numfcor_ == 1)
			m_rad = radius_numf();
		else
			m_rad = radius();
		double rdr = dr + m_rad;
		double phi = fmod(phi0 + M_PI4, M_PI2);
		double csf0 = cos(phi);
		double snf0 = (1. - csf0) * (1. + csf0);
		snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
		if(phi > M_PI) snf0 = - snf0;

		double xc = xp + rdr * csf0;
		double yc = yp + rdr * snf0;
		double csf = (xc - xnp) / m_rad;
		double snf = (yc - ynp) / m_rad;
		double anrm = sqrt(csf * csf + snf * snf);
		csf /= anrm;
		snf /= anrm;
		phi = atan2(snf, csf);
		double phid = fmod(phi - phi0 + M_PI8, M_PI2);
		if(phid > M_PI) phid = phid - M_PI2;
		double drp = (xp + dr * csf0 + m_rad * (csf0 - csf) - xnp)
			* csf
			+ (yp + dr * snf0 + m_rad * (snf0 - snf) - ynp) * snf;
		double dzp = zp + dz - m_rad * tanl * phid - znp;

		HepVector ap(5);
		ap[0] = drp;
		ap[1] = fmod(phi + M_PI4, M_PI2);
		ap[2] = kappa;
		ap[3] = dzp;
		ap[4] = tanl;

		// Modification due to non uniform magnetic field :
		if (numf_ > 10) {

			Hep3Vector x1(xp + dr*csf0, yp + dr*snf0, zp + dz);
			double csf0p = cos(ap[1]);
			double snf0p = (1. - csf0p) * (1. + csf0p);
			snf0p = sqrt((snf0p > 0.) ? snf0p : 0.);
			if(ap[1] > M_PI) snf0p = - snf0p;

			Hep3Vector x2(xnp + drp*csf0p,
					ynp + drp*snf0p,
					znp + dzp);
			Hep3Vector dist((x1 - x2).x()/100.0,
					(x1 - x2).y()/100.0,
					(x1 - x2).z()/100.0);
			HepPoint3D middlebis((x1.x() + x2.x())/2,
					(x1.y() + x2.y())/2,
					(x1.z() + x2.z())/2);
			HepVector3D field;
			MFSvc_->fieldVector(10.*middlebis,field); 
			field = 1000.*field;
			Hep3Vector dB(field.x(),
					field.y(),
					(field.z()-0.1*Bznom_));
			if (field.z()) {
				double akappa(fabs(kappa));
				double sign = kappa/akappa;
				HepVector dp(3);
				dp = 0.299792458 * sign * dB.cross(dist);
				HepVector dhp(3);
				dhp[0] = -akappa*(dp[0]*csf0p+dp[1]*snf0p);
				dhp[1] = kappa*akappa*(dp[0]*snf0p-dp[1]*csf0p);
				dhp[2] = dp[2]*akappa+dhp[1]*tanl/kappa;
				if (numfcor_ == 0){
					ap[1] += dhp[0];
				}
				ap[2] += dhp[1];
				ap[4] += dhp[2];
			}
		}
		HepMatrix m_del = delApDelA(ap);
		Ea_now.assign(m_del * Ea_now * m_del.T());
		pivot(nextPivot);
		a(ap);
		Ea(Ea_now);
		i++;
	}
	return newPivot;
}

const HepPoint3D &
KalFitTrack::pivot_numf(const HepPoint3D & newPivot, double & pathl) {

	Helix tracktest = *(Helix*)this;
	tracktest.ignoreErrorMatrix();
	double tl  = a()[4];
	double th = 90.0 - 180.0*M_1_PI*atan( tl );
	/*
	   int nstep(1);
	   if (steplev_ == 1)
	   nstep = 3;
	   else if (steplev_ == 2 && (th > 140 || th <45))
	   if ((pivot()-newPivot).mag()<3.)
	   nstep = 3;
	   else
	   nstep = 6;
	 */
	Hep3Vector delta_x((newPivot-pivot()).x()/double(outer_steps_),
			(newPivot-pivot()).y()/double(outer_steps_),
			(newPivot-pivot()).z()/double(outer_steps_));
	int i = 1;

	while (i <= outer_steps_) {
		HepPoint3D nextPivot(pivot()+delta_x);
		double xnp(nextPivot.x()), ynp(nextPivot.y()), znp(nextPivot.z());  

		HepSymMatrix Ea_now = Ea();
		HepPoint3D piv(pivot());
		double xp(piv.x()), yp(piv.y()), zp(piv.z());  

		double dr    = a()[0];
		double phi0  = a()[1];
		double kappa = a()[2];
		double dz    = a()[3];
		double tanl  = a()[4];

		double m_rad(0);
		m_rad = radius();

		double rdr = dr + m_rad;
		double phi = fmod(phi0 + M_PI4, M_PI2);
		double csf0 = cos(phi);
		double snf0 = (1. - csf0) * (1. + csf0);
		snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
		if(phi > M_PI) snf0 = - snf0;

		double xc = xp + rdr * csf0;
		double yc = yp + rdr * snf0;
		double csf = (xc - xnp) / m_rad;
		double snf = (yc - ynp) / m_rad;
		double anrm = sqrt(csf * csf + snf * snf);
		csf /= anrm;
		snf /= anrm;
		phi = atan2(snf, csf);
		double phid = fmod(phi - phi0 + M_PI8, M_PI2);
		if(phid > M_PI) phid = phid - M_PI2;
		double drp = (xp + dr * csf0 + m_rad * (csf0 - csf) - xnp)
			* csf
			+ (yp + dr * snf0 + m_rad * (snf0 - snf) - ynp) * snf;
		double dzp = zp + dz - m_rad * tanl * phid - znp;

		HepVector ap(5);
		ap[0] = drp;
		ap[1] = fmod(phi + M_PI4, M_PI2);
		ap[2] = kappa;
		ap[3] = dzp;
		ap[4] = tanl;

		//std::cout<<" numf_: "<<numf_<<std::endl;

		// Modification due to non uniform magnetic field :
		if (numf_ > 10) {

			Hep3Vector x1(xp + dr*csf0, yp + dr*snf0, zp + dz);

			double csf0p = cos(ap[1]);
			double snf0p = (1. - csf0p) * (1. + csf0p);
			snf0p = sqrt((snf0p > 0.) ? snf0p : 0.);
			if(ap[1] > M_PI) snf0p = - snf0p;

			Hep3Vector x2(xnp + drp*csf0p,
					ynp + drp*snf0p,
					znp + dzp);

			Hep3Vector dist((x1 - x2).x()/100.0,
					(x1 - x2).y()/100.0,
					(x1 - x2).z()/100.0);

			HepPoint3D middlebis((x1.x() + x2.x())/2,
					(x1.y() + x2.y())/2,
					(x1.z() + x2.z())/2);

			HepVector3D field;
			MFSvc_->fieldVector(10.*middlebis,field);
			field = 1000.*field;

			//std::cout<<"B field: "<<field<<std::endl;
			Hep3Vector dB(field.x(),
					field.y(),
					(field.z()-0.1*Bznom_));


			//std::cout<<" dB: "<<dB<<std::endl;


			if (field.z()) {
				double akappa(fabs(kappa));
				double sign = kappa/akappa;
				HepVector dp(3);
				dp = 0.299792458 * sign * dB.cross(dist);

				//std::cout<<"dp: "<<dp<<std::endl;

				HepVector dhp(3);
				dhp[0] = -akappa*(dp[0]*csf0p+dp[1]*snf0p);
				dhp[1] = kappa*akappa*(dp[0]*snf0p-dp[1]*csf0p);
				dhp[2] = dp[2]*akappa+dhp[1]*tanl/kappa;


				//std::cout<<"dhp: "<<dhp<<std::endl;


				ap[1] += dhp[0];
				ap[2] += dhp[1];
				ap[4] += dhp[2];
			}
		}
		HepMatrix m_del = delApDelA(ap);
		Ea_now.assign(m_del * Ea_now * m_del.T());
		pivot(nextPivot);
		a(ap);
		Ea(Ea_now);
		i++;

		//std::cout<<" a: "<<a()<<std::endl;
	}

	// Estimation of the path length :
	double tanl_0(tracktest.a()[4]);
	double phi0_0(tracktest.a()[1]);
	double radius_0(tracktest.radius());
	tracktest.pivot(newPivot);

	double phi0_1 = tracktest.a()[1];
	if (fabs(phi0_1 - phi0_0) > M_PI) {
		if (phi0_1 > phi0_0) phi0_1 -= 2 * M_PI;
		else phi0_0 -= 2 * M_PI;
	}  
	if(phi0_1 == phi0_0) phi0_1 = phi0_0 + 1.e-10;
	pathl = fabs(radius_0 * (phi0_1 - phi0_0)
			* sqrt(1 + tanl_0 * tanl_0));
	return newPivot;
}

// function to calculate the path length in the layer
/*
   double KalFitTrack::PathL(int layer){
   HepPoint3D piv(pivot());
   double phi0  = a()[1];
   double kappa = a()[2];
   double tanl  = a()[4];

#ifdef YDEBUG
cout<<"helix "<<a()<<endl;
#endif
// Choose the local field !!
double Bz(Bznom_);
if (numf_ > 10){
HepVector3D b;
MFSvc_->fieldVector(10.*piv, b);   
b = 10000.*b;
Bz=b.z();
}
double ALPHA_loc = 10000./2.99792458/Bz;
int charge = ( kappa >= 0 )? 1 : -1;
double rho = ALPHA_loc/kappa;
double pt = fabs( 1.0/kappa );
double lambda = 180.0*M_1_PI*atan( tanl );
double theta = 90.0 - lambda;
theta = 2.0*M_PI*theta/360.;
double phi = fmod(phi0 + M_PI4, M_PI2);
double csf0 = cos(phi);
double snf0 = (1. - csf0) * (1. + csf0);
snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
if(phi > M_PI) snf0 = - snf0;

double x_c = piv.x() + ( dr() + rho )*csf0;
double y_c = piv.y() + ( dr() + rho )*snf0;
double z_c = piv.z() + dz();
HepPoint3D ccenter(x_c, y_c, 0);
double m_c_perp(ccenter.perp());
Hep3Vector m_c_unit(((CLHEP::Hep3Vector)ccenter).unit());
#ifdef YDEBUG
cout<<"rho=..."<<rho<<endl;
cout<<"ccenter "<<ccenter<<" m_c_unit "<<m_c_unit<<endl;
#endif
//phi resion estimation
double phi_io[2];
HepPoint3D IO = charge*m_c_unit;
double dphi0 = fmod( IO.phi()+4*M_PI,2*M_PI ) - phi;
if( dphi0 > M_PI ) dphi0 -= 2*M_PI;
else if( dphi0 < -M_PI ) dphi0 += 2*M_PI;
phi_io[0] = -(1+charge)*M_PI_2 - charge*dphi0;
phi_io[1] = phi_io[0]+1.5*M_PI;
double phi_in(0); /// for debug

double m_crio[2];
double m_zb, m_zf;
int m_div;

// retrieve Mdc  geometry information
// IMdcGeomSvc* geosvc;
StatusCode sc= Gaudi::svcLocator()->service("MdcGeomSvc", geosvc);
if(sc==StatusCode::FAILURE) cout << "GeoSvc failing!!!!!!!SC=" << sc << endl; 

MdcGeomSvc* geomsvc = dynamic_cast<MdcGeomSvc*>(iGeomSvc_);
if(!geomsvc){
std::cout<<"ERROR OCCUR when dynamic_cast in KalFitTrack.cxx !!"<<std::endl;
}
double rcsiz1 = geomsvc->Layer(layer)->RCSiz1();
double rcsiz2 = geomsvc->Layer(layer)->RCSiz2();
double rlay = geomsvc->Layer(layer)->Radius();
m_zb = 0.5*(geomsvc->Layer(layer)->Length());
m_zf = -0.5*(geomsvc->Layer(layer)->Length());

m_crio[0] = rlay - rcsiz1;
m_crio[1] = rlay + rcsiz2;
//conversion of the units(mm=>cm)
m_crio[0] = 0.1*m_crio[0];
m_crio[1] = 0.1*m_crio[1];
m_zb = 0.1*m_zb;
m_zf = 0.1*m_zf;

int sign = 1;  ///assumed the first half circle
int epflag[2];
Hep3Vector iocand;
Hep3Vector cell_IO[2];
double dphi;
for( int i = 0; i < 2; i++ ){
	double cos_alpha = m_c_perp*m_c_perp + m_crio[i]*m_crio[i] - rho*rho;
	cos_alpha = 0.5*cos_alpha/( m_c_perp*m_crio[i] );
	double Calpha =  acos( cos_alpha );
	epflag[i] = 0;
	iocand = m_c_unit;
	iocand.rotateZ( charge*sign*Calpha );
	iocand *= m_crio[i];
	double xx = iocand.x() - x_c;
	double yy = iocand.y() - y_c;
	dphi = atan2(yy, xx) - phi0 - M_PI_2*(1+charge);
	dphi = fmod( dphi + 8.0*M_PI, 2*M_PI );

	if( dphi < phi_io[0] ){
		dphi += 2*M_PI;
	}
	else if( phi_io[1] < dphi ){
		dphi -= 2*M_PI;
	}

	///in the Local Helix case, phi must be small

	Hep3Vector zvector( 0., 0., z_c-rho*dphi*tanl);

	double xcio, ycio, phip;
	///// z region check active volume is between zb+2. and zf-2. [cm]
	double delrin = 2.0;
	if( m_zf-delrin > zvector.z() ){
		phip = z_c - m_zb + delrin;
		phip = phip/( rho*tanl );
		phip = phip + phi0;
		xcio = x_c - rho*cos( phip );
		ycio = y_c - rho*sin( phip );
		cell_IO[i].setX( xcio );
		cell_IO[i].setY( ycio );
		cell_IO[i].setZ( m_zb+delrin );
		epflag[i] = 1;
	}
	else if( m_zb+delrin < zvector.z() ){
		phip = z_c - m_zf-delrin;
		phip = phip/( rho*tanl );
		phip = phip + phi0;
		xcio = x_c - rho*cos( phip );
		ycio = y_c - rho*sin( phip );
		cell_IO[i].setX( xcio );
		cell_IO[i].setY( ycio );
		cell_IO[i].setZ( m_zf-delrin );
		epflag[i] = 1;
	}
	else{
		cell_IO[i] = iocand;
		cell_IO[i] += zvector;
	}
	/// for debug
	if( i == 0 ) phi_in = dphi;
}
// path length estimation
// phi calculation
Hep3Vector cl = cell_IO[1] - cell_IO[0];
#ifdef YDEBUG
cout<<"cell_IO[0] "<<cell_IO[0]<<" cell_IO[1] "<<cell_IO[1]<<" cl "<<cl<<endl; 
#endif

double ch_theta;
double ch_dphi;
double ch_ltrk = 0;
double ch_ltrk_rp = 0;
ch_dphi = cl.perp()*0.5/(ALPHA_loc*pt);
ch_dphi = 2.0 * asin( ch_dphi );
ch_ltrk_rp = ch_dphi*ALPHA_loc*pt;
#ifdef YDEBUG
cout<<"ch_dphi "<<ch_dphi<<" ch_ltrk_rp "<<ch_ltrk_rp<<" cl.z "<<cl.z()<<endl; 
#endif
ch_ltrk = sqrt( ch_ltrk_rp*ch_ltrk_rp + cl.z()*cl.z() );
ch_theta = cl.theta();

if( ch_theta < theta*0.85 || 1.15*theta < ch_theta)
	ch_ltrk *= -1; /// miss calculation

if( epflag[0] == 1 || epflag [1] == 1 )
	ch_ltrk *= -1;  /// invalid resion for dE/dx or outside of Mdc

	mom_[layer] = momentum( phi_in );
	PathL_[layer] = ch_ltrk;
#ifdef YDEBUG
	cout<<"ch_ltrk "<<ch_ltrk<<endl; 
#endif
	return ch_ltrk;
	}
*/


void KalFitTrack::update_bit(int i){
	int j(0);
	if (i < 31){
		j = (int) pow(2.,i);
		if (!(pat1_ & j))
			pat1_ = pat1_ | j;
	} else if (i < 50) {
		j = (int) pow(2.,(i-31));
		if (!(pat2_ & j))
			pat2_ = pat2_ | j;
	}
}

int KalFitTrack::nmass(void){  return NMASS;}
double KalFitTrack::mass(int i){  return MASS[i];}
void KalFitTrack::chgmass(int i){
	mass_=MASS[i];
	l_mass_=i;
}

void KalFitTrack::lead(int i){ lead_ = i;}
int KalFitTrack::lead(void){ return lead_;}
void KalFitTrack::back(int i){ back_ = i;}
int KalFitTrack::back(void){ return back_;}
void KalFitTrack::resol(int i){ resolflag_ = i;}
int KalFitTrack::resol(void){ return resolflag_;}
void KalFitTrack::numf(int i){ numf_ = i;}
int KalFitTrack::numf(void){ return numf_;}
void KalFitTrack::LR(int x){ LR_ = x;}
void KalFitTrack::HitsMdc(vector<KalFitHitMdc>& lh){ HitsMdc_ = lh;}
void KalFitTrack::appendHitsMdc(KalFitHitMdc h){ HitsMdc_.push_back(h);}

/* 
   This member function is in charge of the forward filter,
   for the tof correction of the drift distance in the case of cosmic rays
   if way=1, it's a down track means same as track in collision data,
   if way=-1, it's a up track !
 */

double KalFitTrack::update_hits(KalFitHitMdc & HitMdc, int inext, Hep3Vector& meas, int way, double& dchi2out, double& dtrack,double& dtracknew, double& dtdc, int csmflag) {

	double lr = HitMdc.LR();
	//std::cout<<" in update_hits: lr= " << lr <<std::endl;
	// For taking the propagation delay into account :
	const KalFitWire& Wire = HitMdc.wire();
	int wire_ID = Wire.geoID();
	int layerid = HitMdc.wire().layer().layerId();
	//std::cout<<" when in layer: "<<layerid<<std::endl;
	double entrangle = HitMdc.rechitptr()->getEntra();

	if (wire_ID<0 || wire_ID>6796){  //bes
		std::cout << " KalFitTrack: wire_ID problem : " << wire_ID 
			<< std::endl;
		return 0;
	} 
	int flag_ster = Wire.stereo();
	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;
	if (Tof_correc_){
		double t = tanl();
		double dphi(0);

		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		double phi_ip(0);
		Hep3Vector ip(0, 0, 0);
		work.pivot(ip);
		phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		dphi = phi - phi_ip;
		double l = fabs(radius() * dphi * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && HitMdc.wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	const HepVector& v_a = a();
	double dchi2R(99999999), dchi2L(99999999);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	dtrack = estim;
	// std::cout<<" in update_hits estim is  "<<estim<<std::endl;
	HepVector ea_v_H = ea * v_H;
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNewL(5), eaNewR(5);
	HepVector aNewL(5), aNewR(5);

	double drifttime = getDriftTime(HitMdc , tofest);
	double ddl = getDriftDist(HitMdc, drifttime, 0 );
	double ddr = getDriftDist(HitMdc, drifttime, 1 );
	double erddl = getSigma( HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( HitMdc, a()[4], 1, ddr);

	if(debug_ == 4) {
		std::cout<<"drifttime in update_hits() for ananlysis is  "<<drifttime<<std::endl;
		std::cout<<"ddl in update_hits() for ananlysis is  "<<ddl<<std::endl;
		std::cout<<"ddr in update_hits() for ananlysis is  "<<ddr<<std::endl;
		std::cout<<"erddl in update_hits() for ananlysis is  "<<erddl<<std::endl;
		std::cout<<"erddr in update_hits() for ananlysis is  "<<erddr<<std::endl;
	}

	//the following 3 line : tempory
	double dmeas2[2] = { 0.1*ddl, 0.1*ddr };  // millimeter to centimeter
	double er_dmeas2[2] = {0.,0.};
	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//   int layid = HitMdc.wire().layer().layerId();
		//   double sigma = getSigma(layid, dd);
		//   er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	// Left hypothesis :
	if ((LR_==0 && lr != 1.0) || 
			(LR_==1 && lr == -1.0)) {
		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*fabs(dmeas2[0]);
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs(HitMdc.dist()[0]);
			er_dmeasL = HitMdc.erdist()[0];
		}
		dtdc = dmeasL;
		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNewL.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(debug_ == 4){
			std::cout<<" ea_v_H * AL * ea_v_HT is: "<<ea_v_H * AL * ea_v_HT<<std::endl;
			std::cout<<" v_H is: "<<v_H<<" Ea is: "<<ea<<" v_H_T_ea_v_H is: "<<v_H_T_ea_v_H<<std::endl;
			std::cout<<" AL is: "<<AL<<" (v_H_T_ea_v_H)[0] * AL is: "<<(v_H_T_ea_v_H)[0]*AL<<std::endl;
		}

		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNewL = v_a + diffL;
		double sigL = dmeasL -(v_HT * aNewL)[0];
		dtracknew = (v_HT * aNewL)[0];
		dchi2L = (sigL * sigL)/(RkL * er_dmeasL*er_dmeasL);

		if(debug_ == 4){
			std::cout<<" fwd_filter : in left hypothesis dchi2L is "<<dchi2L<<std::endl;
		}
	}

	if ((LR_==0 && lr != -1.0) ||
			(LR_==1 && lr == 1.0)) {
		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs(HitMdc.dist()[1]);
			er_dmeasR = HitMdc.erdist()[1];
		}
		dtdc = dmeasR;
		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNewR.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;

		if(debug_ == 4){
			std::cout<<" ea_v_H * AR * ea_v_HT is: "<<ea_v_H * AR * ea_v_HT<<std::endl;
			std::cout<<" v_H is: "<<v_H<<" Ea is: "<<ea<<" v_H_T_ea_v_H is: "<<v_H_T_ea_v_H<<std::endl;
			std::cout<<" AR is: "<<AR<<" (v_H_T_ea_v_H)[0] * AR is: "<<(v_H_T_ea_v_H)[0]*AR<<std::endl;
		}

		if(0. == RkR) RkR = 1.e-4;
		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNewR = v_a + diffR;
		double sigR = dmeasR -(v_HT * aNewR)[0];
		dtracknew = (v_HT * aNewR)[0];
		dchi2R = (sigR*sigR)/(RkR * er_dmeasR*er_dmeasR);
		if(debug_ == 4){
			std::cout<<" fwd_filter : in right hypothesis dchi2R is "<<dchi2R<<std::endl;
		}
	}
	// Update Kalman result :
	double dchi2_loc(0);
	if (fabs(dchi2R-dchi2L)<10. && inext>0) {
		KalFitHitMdc & HitMdc_next = HitsMdc_[inext];
		Helix H_fromR(pivot(), aNewR, eaNewR);
		double chi2_fromR(chi2_next(H_fromR, HitMdc_next, csmflag));
		Helix H_fromL(pivot(), aNewL, eaNewL);
		double chi2_fromL(chi2_next(H_fromL, HitMdc_next, csmflag));
#ifdef YDEBUG
		std::cout << "   chi2_fromL = " << chi2_fromL 
			<< ", chi2_fromR = " << chi2_fromR << std::endl;
#endif
		if (fabs(chi2_fromR-chi2_fromL)<10.){
			int inext2(-1);
			if (inext+1<HitsMdc_.size())
				for( int k=inext+1 ; k < HitsMdc_.size(); k++ )
					if (!(HitsMdc_[k].chi2()<0)) {
						inext2 = k;
						break;
					}

			if (inext2 != -1){
				KalFitHitMdc & HitMdc_next2 = HitsMdc_[inext2];
				double chi2_fromR2(chi2_next(H_fromR, HitMdc_next2, csmflag));
				double chi2_fromL2(chi2_next(H_fromL, HitMdc_next2, csmflag));
#ifdef YDEBUG
				std::cout << "   chi2_fromL2 = " << chi2_fromL2 
					<< ", chi2_fromR2 = " << chi2_fromR2 << std::endl;
#endif
				if (fabs(dchi2R+chi2_fromR+chi2_fromR2-(dchi2L+chi2_fromL+chi2_fromL2))<2) {
					if (chi2_fromR2<chi2_fromL2)
						dchi2L = DBL_MAX;
					else 
						dchi2R = DBL_MAX;
				}
			} 
		}

		if (!(dchi2L == DBL_MAX && dchi2R == DBL_MAX)) {
			if (dchi2R+chi2_fromR < dchi2L+chi2_fromL){
				dchi2L = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose right..." << std::endl;
#endif
			} else {
				dchi2R = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose left..." << std::endl;
#endif
			}
		}
	}
	if ((0 < dchi2R && dchi2R < dchi2cutf_anal[layerid]) ||
			(0 < dchi2L && dchi2L < dchi2cutf_anal[layerid])) {

		if (((LR_==0 && dchi2R < dchi2L && lr != -1) || 
					(LR_==1 && lr == 1)) && 
				fabs(aNewR[2]-a()[2]) < 1000. && aNewR[2]) {
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2R < dchi2cutf_anal[layerid]){
				nchits_++;
				if (flag_ster) nster_++;
				Ea(eaNewR);
				a(aNewR);
				chiSq_ += dchi2R;
				dchi2_loc = dchi2R;
				if (l_mass_ == lead_){
					HitMdc.LR(1);
				}        
				update_bit(HitMdc.wire().layer().layerId());
			}
		} else if (((LR_==0 && dchi2L <= dchi2R && lr != 1) || 
					(LR_==1 && lr == -1)) && 
				fabs(aNewL[2]-a()[2]) < 1000. && aNewL[2]){
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2L < dchi2cutf_anal[layerid]){
				nchits_++;
				if (flag_ster) nster_++;
				Ea(eaNewL);
				a(aNewL);
				chiSq_ += dchi2L;
				dchi2_loc = dchi2L;
				if (l_mass_ == lead_){
					HitMdc.LR(-1);
				}
				update_bit(HitMdc.wire().layer().layerId());
			}
		}
	}
	if (dchi2_loc > dchi2_max_) {
		dchi2_max_ = dchi2_loc ;
		r_max_ = pivot().perp();
	}
	dchi2out = dchi2_loc;
	//if(dchi2out == 0) {
	//   dchi2out = ( (dchi2L < dchi2R ) ? dchi2L : dchi2R ) ;
	// }
	return chiSq_;
}


double KalFitTrack::update_hits_csmalign(KalFitHelixSeg& HelixSeg, int inext, Hep3Vector& meas,int way, double& dchi2out, int csmflag ) {


	HepPoint3D ip(0.,0.,0.);

	KalFitHitMdc* HitMdc = HelixSeg.HitMdc();
	double lr = HitMdc->LR();
	int layerid = (*HitMdc).wire().layer().layerId();
	// cout<<"layerid: "<<layerid<<endl;
	double entrangle = HitMdc->rechitptr()->getEntra();

	if(debug_ == 4) {
		std::cout<<"in update_hits(kalFitHelixSeg,...) : the layerid ="<<layerid<<std::endl; 
		std::cout<<" update_hits: lr= " << lr <<std::endl;
	}
	// For taking the propagation delay into account :
	const KalFitWire& Wire = HitMdc->wire();
	int wire_ID = Wire.geoID();

	if (wire_ID<0 || wire_ID>6796){  //bes
		std::cout << " KalFitTrack: wire_ID problem : " << wire_ID 
			<< std::endl;
		return 0;
	} 
	int flag_ster = Wire.stereo();
	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;
	if (Tof_correc_){
		double t = tanl();
		double dphi(0);

		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		double phi_ip(0);
		Hep3Vector ip(0, 0, 0);
		work.pivot(ip);
		phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		dphi = phi - phi_ip;

		double l = fabs(radius() * dphi * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && (*HitMdc).wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	HelixSeg.Ea_pre_fwd(ea);
	HelixSeg.Ea_filt_fwd(ea);


	const HepVector& v_a = a();
	HelixSeg.a_pre_fwd(v_a);
	HelixSeg.a_filt_fwd(v_a);

	/*

	   HepPoint3D pivot_work = pivot();
	   HepVector a_work = a();
	   HepSymMatrix ea_work = Ea();
	   KalFitTrack helix_work(pivot_work, a_work, ea_work, 0, 0, 0);
	   helix_work.pivot(ip);

	   HepVector a_temp = helix_work.a();
	   HepSymMatrix ea_temp = helix_work.Ea();

	   HelixSeg.Ea_pre_fwd(ea_temp);	
	   HelixSeg.a_pre_fwd(a_temp);

	// My God, for the protection purpose 
	HelixSeg.Ea_filt_fwd(ea_temp);
	HelixSeg.a_filt_fwd(a_temp);

	 */

	double dchi2R(99999999), dchi2L(99999999);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNewL(5), eaNewR(5);
	HepVector aNewL(5), aNewR(5);
#ifdef YDEBUG
	cout<<"phi  "<<phi<<"  snf0 "<<snf0<<"  csf0  "<<csf0<<endl
		<<"  meas:  "<<meas <<endl;   
	cout<<"the related matrix:"<<endl;
	cout<<"v_H  "<<v_H<<endl;
	cout<<"v_a  "<<v_a<<endl;
	cout<<"ea  "<<ea<<endl;
	cout<<"v_H_T_ea_v_H  "<<v_H_T_ea_v_H<<endl;
	cout<<"LR_= "<< LR_ << "lr= " << lr <<endl;
#endif

	double time = (*HitMdc).tdc();
	//  if (Tof_correc_)
	//  time = time - way*tofest;

	//  double dd = 1.0e-4 * 40.0 * time;
	//the following 3 line : tempory

	double drifttime = getDriftTime(*HitMdc , tofest);
	double ddl = getDriftDist(*HitMdc, drifttime, 0 );
	double ddr = getDriftDist(*HitMdc, drifttime, 1 );
	double erddl = getSigma( *HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( *HitMdc, a()[4], 1, ddr);

	if(debug_ == 4){
		std::cout<<"the pure drift time is "<<drifttime<<std::endl;
		std::cout<<"the drift dist left hypothesis is "<<ddl<<std::endl;
		std::cout<<"the drift dist right hypothesis is "<<ddr<<std::endl;
		std::cout<<"the error sigma left hypothesis is "<<erddl<<std::endl;
		std::cout<<"the error sigma right hypothesis is "<<erddr<<std::endl;
	}
	double dmeas2[2] = { 0.1*ddl , 0.1*ddr }; //millimeter to centimeter
	double er_dmeas2[2] = {0. , 0.} ;

	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//   int layid = (*HitMdc).wire().layer().layerId();
		//   double sigma = getSigma(layid, dd);
		//   er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	// Left hypothesis :
	if ((LR_==0 && lr != 1.0) || 
			(LR_==1 && lr == -1.0)) {

		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*fabs(dmeas2[0]);
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs((*HitMdc).dist()[0]);
			er_dmeasL = (*HitMdc).erdist()[0];
		}

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNewL.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);

		aNewL = v_a + diffL;
		double sigL = dmeasL -(v_HT * aNewL)[0];
		dchi2L = (sigL * sigL) /  (RkL * er_dmeasL*er_dmeasL);
	}

	if ((LR_==0 && lr != -1.0) ||
			(LR_==1 && lr == 1.0)) {

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs((*HitMdc).dist()[1]);
			er_dmeasR = (*HitMdc).erdist()[1];
		}

		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNewR.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);

		aNewR = v_a + diffR;
		double sigR = dmeasR -(v_HT * aNewR)[0];
		dchi2R = (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	}

	// Update Kalman result :
	double dchi2_loc(0);

#ifdef YDEBUG
	cout<<" track::update_hits......"<<endl;
	std::cout << "   dchi2R = " << dchi2R << ", dchi2L = " << dchi2L 
		<< "   estimate =  "<<estim<< std::endl;
	std::cout << "   dmeasR = " << dmeas2[1] 
		<< ", dmeasL = " << (-1.0)*fabs(dmeas2[0]) << ", check HitMdc.ddl = " 
		<< (*HitMdc).dist()[0] << std::endl;
	std::cout<<"dchi2L : "<<dchi2L<<" ,dchi2R:  "<<dchi2R<<std::endl; 
#endif


	if (fabs(dchi2R-dchi2L)<10. && inext>0) {

		KalFitHitMdc & HitMdc_next = HitsMdc_[inext];

		Helix H_fromR(pivot(), aNewR, eaNewR);
		double chi2_fromR(chi2_next(H_fromR, HitMdc_next,csmflag));
		//double chi2_fromR(chi2_next(H_fromR, HitMdc_next));

		Helix H_fromL(pivot(), aNewL, eaNewL);
		double chi2_fromL(chi2_next(H_fromL, HitMdc_next,csmflag));
		//double chi2_fromL(chi2_next(H_fromL, HitMdc_next));
#ifdef YDEBUG
		std::cout << "   chi2_fromL = " << chi2_fromL 
			<< ", chi2_fromR = " << chi2_fromR << std::endl;
#endif
		if (fabs(chi2_fromR-chi2_fromL)<10.){
			int inext2(-1);
			if (inext+1<HitsMdc_.size())
				for( int k=inext+1 ; k < HitsMdc_.size(); k++ )
					if (!(HitsMdc_[k].chi2()<0)) {
						inext2 = k;
						break;
					}

			if (inext2 != -1){
				KalFitHitMdc & HitMdc_next2 = HitsMdc_[inext2];
				//	double chi2_fromR2(chi2_next(H_fromR, HitMdc_next2));
				//	double chi2_fromL2(chi2_next(H_fromL, HitMdc_next2));
				double chi2_fromR2(chi2_next(H_fromR, HitMdc_next2, csmflag));
				double chi2_fromL2(chi2_next(H_fromL, HitMdc_next2, csmflag));
#ifdef YDEBUG
				std::cout << "   chi2_fromL2 = " << chi2_fromL2 
					<< ", chi2_fromR2 = " << chi2_fromR2 << std::endl;
#endif
				if (fabs(dchi2R+chi2_fromR+chi2_fromR2-(dchi2L+chi2_fromL+chi2_fromL2))<2) {
					if (chi2_fromR2<chi2_fromL2)
						dchi2L = DBL_MAX;
					else 
						dchi2R = DBL_MAX;
				}
			} 
		}

		if (!(dchi2L == DBL_MAX && dchi2R == DBL_MAX)) {
			if (dchi2R+chi2_fromR < dchi2L+chi2_fromL){
				dchi2L = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose right..." << std::endl;
#endif
			} else {
				dchi2R = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose left..." << std::endl;
#endif
			}
		}
	}

	if ((0 < dchi2R && dchi2R < dchi2cutf_calib[layerid]) ||
			(0 < dchi2L && dchi2L < dchi2cutf_calib[layerid])) {

		if (((LR_==0 && dchi2R < dchi2L && lr != -1) || 
					(LR_==1 && lr == 1)) && 
				fabs(aNewR[2]-a()[2]) < 1000. && aNewR[2]) {
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2R < dchi2cutf_calib[layerid]){
				nchits_++;
				if (flag_ster) nster_++;
				if(layerid>19){  
					Ea(eaNewR);
					HelixSeg.Ea_filt_fwd(eaNewR);
					a(aNewR);
					HelixSeg.a_filt_fwd(aNewR);
				}         
				/*
				   Ea(eaNewR);
				   a(aNewR);

				   KalFitTrack helixR(pivot_work, aNewR, eaNewR, 0, 0, 0);
				   helixR.pivot(ip);

				   a_temp = helixR.a();
				   ea_temp = helixR.Ea();

				   HelixSeg.Ea_filt_fwd(ea_temp);
				   HelixSeg.a_filt_fwd(a_temp);
				//HelixSeg.filt_include(1);

				 */

				chiSq_ += dchi2R;
				dchi2_loc = dchi2R;
				if (l_mass_ == lead_){
					(*HitMdc).LR(1);
					HelixSeg.LR(1);
				}        
				update_bit((*HitMdc).wire().layer().layerId());
			}
		} else if (((LR_==0 && dchi2L <= dchi2R && lr != 1) || 
					(LR_==1 && lr == -1)) && 
				fabs(aNewL[2]-a()[2]) < 1000. && aNewL[2]){
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2L < dchi2cutf_calib[layerid]){
				nchits_++;
				if (flag_ster) nster_++;
				if(layerid>19){
					Ea(eaNewL);
					HelixSeg.Ea_filt_fwd(eaNewL);
					a(aNewL);
					HelixSeg.a_filt_fwd(aNewL);
				}

				/* 
				   Ea(eaNewL);
				   a(aNewL);

				   KalFitTrack helixL(pivot_work, aNewL, eaNewL, 0, 0, 0);
				   helixL.pivot(ip);
				   a_temp = helixL.a();
				   ea_temp = helixL.Ea();
				   HelixSeg.Ea_filt_fwd(ea_temp);
				   HelixSeg.a_filt_fwd(a_temp);
				//HelixSeg.filt_include(1);

				 */

				chiSq_ += dchi2L;
				dchi2_loc = dchi2L;
				if (l_mass_ == lead_){
					(*HitMdc).LR(-1);
					HelixSeg.LR(-1);
				}
				update_bit((*HitMdc).wire().layer().layerId());
			}
		}
	}

	if (dchi2_loc > dchi2_max_) {
		dchi2_max_ = dchi2_loc ;
		r_max_ = pivot().perp();
	}
	dchi2out = dchi2_loc;
	//  if(dchi2out == 0) {
	//     dchi2out = ( (dchi2L < dchi2R ) ? dchi2L : dchi2R ) ;
	//  }
	return chiSq_;
}


double KalFitTrack::update_hits(KalFitHelixSeg& HelixSeg, int inext, Hep3Vector& meas,int way, double& dchi2out, int csmflag) {


	HepPoint3D ip(0.,0.,0.);

	KalFitHitMdc* HitMdc = HelixSeg.HitMdc();
	double lr = HitMdc->LR();
	int layerid = (*HitMdc).wire().layer().layerId();
	double entrangle = HitMdc->rechitptr()->getEntra();

	if(debug_ == 4) {
		std::cout<<"in update_hits(kalFitHelixSeg,...) : the layerid ="<<layerid<<std::endl; 
		std::cout<<" update_hits: lr= " << lr <<std::endl;
	}
	// For taking the propagation delay into account :
	const KalFitWire& Wire = HitMdc->wire();
	int wire_ID = Wire.geoID();

	if (wire_ID<0 || wire_ID>6796){  //bes
		std::cout << " KalFitTrack: wire_ID problem : " << wire_ID 
			<< std::endl;
		return 0;
	} 
	int flag_ster = Wire.stereo();
	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;
	if (Tof_correc_){
		double t = tanl();
		double dphi(0);

		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		double phi_ip(0);
		Hep3Vector ip(0, 0, 0);
		work.pivot(ip);
		phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		dphi = phi - phi_ip;

		double l = fabs(radius() * dphi * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && (*HitMdc).wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = Ea();
	HelixSeg.Ea_pre_fwd(ea);
	HelixSeg.Ea_filt_fwd(ea);


	const HepVector& v_a = a();
	HelixSeg.a_pre_fwd(v_a);
	HelixSeg.a_filt_fwd(v_a);

	/*

	   HepPoint3D pivot_work = pivot();
	   HepVector a_work = a();
	   HepSymMatrix ea_work = Ea();
	   KalFitTrack helix_work(pivot_work, a_work, ea_work, 0, 0, 0);
	   helix_work.pivot(ip);

	   HepVector a_temp = helix_work.a();
	   HepSymMatrix ea_temp = helix_work.Ea();

	   HelixSeg.Ea_pre_fwd(ea_temp);	
	   HelixSeg.a_pre_fwd(a_temp);

	// My God, for the protection purpose 
	HelixSeg.Ea_filt_fwd(ea_temp);
	HelixSeg.a_filt_fwd(a_temp);

	 */


	double dchi2R(99999999), dchi2L(99999999);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNewL(5), eaNewR(5);
	HepVector aNewL(5), aNewR(5);
#ifdef YDEBUG
	cout<<"phi  "<<phi<<"  snf0 "<<snf0<<"  csf0  "<<csf0<<endl
		<<"  meas:  "<<meas <<endl;   
	cout<<"the related matrix:"<<endl;
	cout<<"v_H  "<<v_H<<endl;
	cout<<"v_a  "<<v_a<<endl;
	cout<<"ea  "<<ea<<endl;
	cout<<"v_H_T_ea_v_H  "<<v_H_T_ea_v_H<<endl;
	cout<<"LR_= "<< LR_ << "lr= " << lr <<endl;
#endif

	double time = (*HitMdc).tdc();
	//  if (Tof_correc_)
	//  time = time - way*tofest;

	//  double dd = 1.0e-4 * 40.0 * time;
	//the following 3 line : tempory

	double drifttime = getDriftTime(*HitMdc , tofest);
	double ddl = getDriftDist(*HitMdc, drifttime, 0 );
	double ddr = getDriftDist(*HitMdc, drifttime, 1 );
	double erddl = getSigma( *HitMdc, a()[4], 0, ddl);
	double erddr = getSigma( *HitMdc, a()[4], 1, ddr);

	if(debug_ == 4){
		std::cout<<"the pure drift time is "<<drifttime<<std::endl;
		std::cout<<"the drift dist left hypothesis is "<<ddl<<std::endl;
		std::cout<<"the drift dist right hypothesis is "<<ddr<<std::endl;
		std::cout<<"the error sigma left hypothesis is "<<erddl<<std::endl;
		std::cout<<"the error sigma right hypothesis is "<<erddr<<std::endl;
	}
	double dmeas2[2] = { 0.1*ddl , 0.1*ddr }; //millimeter to centimeter
	double er_dmeas2[2] = {0. , 0.} ;

	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl;
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//   int layid = (*HitMdc).wire().layer().layerId();
		//   double sigma = getSigma(layid, dd);
		//   er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	// Left hypothesis :
	if ((LR_==0 && lr != 1.0) || 
			(LR_==1 && lr == -1.0)) {

		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*fabs(dmeas2[0]);
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs((*HitMdc).dist()[0]);
			er_dmeasL = (*HitMdc).erdist()[0];
		}

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNewL.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);

		aNewL = v_a + diffL;
		double sigL = dmeasL -(v_HT * aNewL)[0];
		dchi2L = (sigL * sigL) /  (RkL * er_dmeasL*er_dmeasL);
	}

	if ((LR_==0 && lr != -1.0) ||
			(LR_==1 && lr == 1.0)) {

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs((*HitMdc).dist()[1]);
			er_dmeasR = (*HitMdc).erdist()[1];
		}

		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNewR.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);

		aNewR = v_a + diffR;
		double sigR = dmeasR -(v_HT * aNewR)[0];
		dchi2R = (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	}

	// Update Kalman result :
	double dchi2_loc(0);

#ifdef YDEBUG
	cout<<" track::update_hits......"<<endl;
	std::cout << "   dchi2R = " << dchi2R << ", dchi2L = " << dchi2L 
		<< "   estimate =  "<<estim<< std::endl;
	std::cout << "   dmeasR = " << dmeas2[1] 
		<< ", dmeasL = " << (-1.0)*fabs(dmeas2[0]) << ", check HitMdc.ddl = " 
		<< (*HitMdc).dist()[0] << std::endl;
#endif

	if (fabs(dchi2R-dchi2L)<10. && inext>0) {

		KalFitHitMdc & HitMdc_next = HitsMdc_[inext];

		Helix H_fromR(pivot(), aNewR, eaNewR);
		double chi2_fromR(chi2_next(H_fromR, HitMdc_next,csmflag));

		Helix H_fromL(pivot(), aNewL, eaNewL);
		double chi2_fromL(chi2_next(H_fromL, HitMdc_next,csmflag));
#ifdef YDEBUG
		std::cout << "   chi2_fromL = " << chi2_fromL 
			<< ", chi2_fromR = " << chi2_fromR << std::endl;
#endif
		if (fabs(chi2_fromR-chi2_fromL)<10.){
			int inext2(-1);
			if (inext+1<HitsMdc_.size())
				for( int k=inext+1 ; k < HitsMdc_.size(); k++ )
					if (!(HitsMdc_[k].chi2()<0)) {
						inext2 = k;
						break;
					}

			if (inext2 != -1){
				KalFitHitMdc & HitMdc_next2 = HitsMdc_[inext2];
				double chi2_fromR2(chi2_next(H_fromR, HitMdc_next2, csmflag));
				double chi2_fromL2(chi2_next(H_fromL, HitMdc_next2, csmflag));
#ifdef YDEBUG
				std::cout << "   chi2_fromL2 = " << chi2_fromL2 
					<< ", chi2_fromR2 = " << chi2_fromR2 << std::endl;
#endif
				if (fabs(dchi2R+chi2_fromR+chi2_fromR2-(dchi2L+chi2_fromL+chi2_fromL2))<2) {
					if (chi2_fromR2<chi2_fromL2)
						dchi2L = DBL_MAX;
					else 
						dchi2R = DBL_MAX;
				}
			} 
		}

		if (!(dchi2L == DBL_MAX && dchi2R == DBL_MAX)) {
			if (dchi2R+chi2_fromR < dchi2L+chi2_fromL){
				dchi2L = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose right..." << std::endl;
#endif
			} else {
				dchi2R = DBL_MAX;
#ifdef YDEBUG
				std::cout << " choose left..." << std::endl;
#endif
			}
		}
	}

	if ((0 < dchi2R && dchi2R < dchi2cutf_calib[layerid]) ||
			(0 < dchi2L && dchi2L < dchi2cutf_calib[layerid])) {

		if (((LR_==0 && dchi2R < dchi2L && lr != -1) || 
					(LR_==1 && lr == 1)) && 
				fabs(aNewR[2]-a()[2]) < 1000. && aNewR[2]) {
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2R < dchi2cutf_calib[layerid]){
				nchits_++;
				if (flag_ster) nster_++;

				Ea(eaNewR);
				HelixSeg.Ea_filt_fwd(eaNewR);
				a(aNewR);
				HelixSeg.a_filt_fwd(aNewR);

				/*
				   Ea(eaNewR);
				   a(aNewR);

				   KalFitTrack helixR(pivot_work, aNewR, eaNewR, 0, 0, 0);
				   helixR.pivot(ip);

				   a_temp = helixR.a();
				   ea_temp = helixR.Ea();

				   HelixSeg.Ea_filt_fwd(ea_temp);
				   HelixSeg.a_filt_fwd(a_temp);
				//HelixSeg.filt_include(1);

				 */

				chiSq_ += dchi2R;
				dchi2_loc = dchi2R;
				if (l_mass_ == lead_){
					(*HitMdc).LR(1);
					HelixSeg.LR(1);
				}        
				update_bit((*HitMdc).wire().layer().layerId());
			}
		} else if (((LR_==0 && dchi2L <= dchi2R && lr != 1) || 
					(LR_==1 && lr == -1)) && 
				fabs(aNewL[2]-a()[2]) < 1000. && aNewL[2]){
			if (nchits_ < (unsigned) nmdc_hit2_ || dchi2L < dchi2cutf_calib[layerid]){
				nchits_++;
				if (flag_ster) nster_++;
				Ea(eaNewL);
				HelixSeg.Ea_filt_fwd(eaNewL);
				a(aNewL);
				HelixSeg.a_filt_fwd(aNewL);


				/* 
				   Ea(eaNewL);
				   a(aNewL);

				   KalFitTrack helixL(pivot_work, aNewL, eaNewL, 0, 0, 0);
				   helixL.pivot(ip);
				   a_temp = helixL.a();
				   ea_temp = helixL.Ea();
				   HelixSeg.Ea_filt_fwd(ea_temp);
				   HelixSeg.a_filt_fwd(a_temp);
				//HelixSeg.filt_include(1);

				 */

				chiSq_ += dchi2L;
				dchi2_loc = dchi2L;
				if (l_mass_ == lead_){
					(*HitMdc).LR(-1);
					HelixSeg.LR(-1);
				}
				update_bit((*HitMdc).wire().layer().layerId());
			}
		}
	}

	if (dchi2_loc > dchi2_max_) {
		dchi2_max_ = dchi2_loc ;
		r_max_ = pivot().perp();
	}
	dchi2out = dchi2_loc;
	//  if(dchi2out == 0) {
	//     dchi2out = ( (dchi2L < dchi2R ) ? dchi2L : dchi2R ) ;
	//  }
	return chiSq_;
}


double KalFitTrack::chi2_next(Helix& H, KalFitHitMdc & HitMdc ){

	double lr = HitMdc.LR();
	const KalFitWire& Wire = HitMdc.wire();
	int wire_ID = Wire.geoID();
	int layerid = HitMdc.wire().layer().layerId();
	double entrangle = HitMdc.rechitptr()->getEntra();	

	HepPoint3D fwd(Wire.fwd());
	HepPoint3D bck(Wire.bck());
	Hep3Vector wire = (Hep3Vector)fwd -(Hep3Vector)bck;
	Helix work = H;
	work.ignoreErrorMatrix();
	work.pivot((fwd + bck) * .5);
	HepPoint3D x0kal = (work.x(0).z() - bck.z())/ wire.z() * wire + bck;
	H.pivot(x0kal);

	Hep3Vector meas = H.momentum(0).cross(wire).unit();

	if (wire_ID<0 || wire_ID>6796){  //bes
		std::cout << "KalFitTrack : wire_ID problem : " << wire_ID 
			<< std::endl;
		return DBL_MAX;
	} 

	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;

	if (Tof_correc_) {
		Hep3Vector ip(0, 0, 0);
		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		work.pivot(ip);
		double phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		double t = tanl();
		double l = fabs(radius() * (phi - phi_ip) * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		//  if(csmflag==1 && HitMdc.wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = H.Ea();
	const HepVector& v_a = H.a();
	double dchi2R(DBL_MAX), dchi2L(DBL_MAX);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNewL(5), eaNewR(5);
	HepVector aNewL(5), aNewR(5);

	//double time = HitMdc.tdc();
	//if (Tof_correc_)
	// time = time - tofest;
	double drifttime = getDriftTime(HitMdc , tofest);
	double ddl = getDriftDist(HitMdc, drifttime , 0 );
	double ddr = getDriftDist(HitMdc, drifttime , 1 );
	double erddl = getSigma( HitMdc, H.a()[4], 0, ddl);
	double erddr = getSigma( HitMdc, H.a()[4], 1, ddr);

	double dmeas2[2] = { 0.1*ddl, 0.1*ddr };
	double er_dmeas2[2] = {0. , 0.};
	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl; 
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//  int layid = HitMdc.wire().layer().layerId();
		//  double sigma = getSigma(layid, dd);
		//  er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	if ((LR_==0 && lr != 1.0) || 
			(LR_==1 && lr == -1.0)) {

		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*fabs(dmeas2[0]);
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs(HitMdc.dist()[0]);
			er_dmeasL = HitMdc.erdist()[0];
		}

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNewL.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNewL = v_a + diffL;
		double sigL = dmeasL -(v_HT * aNewL)[0];
		dchi2L = (sigL * sigL) /  (RkL * er_dmeasL*er_dmeasL);
	}

	if ((LR_==0 && lr != -1.0) ||
			(LR_==1 && lr == 1.0)) {

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs(HitMdc.dist()[1]);
			er_dmeasR = HitMdc.erdist()[1];
		}

		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNewR.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNewR = v_a + diffR;
		double sigR = dmeasR -(v_HT * aNewR)[0];
		dchi2R = (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	} 

	if (dchi2R < dchi2L){
		H.a(aNewR); H.Ea(eaNewR);
	} else {
		H.a(aNewL); H.Ea(eaNewL);
	}
	return ((dchi2R < dchi2L) ? dchi2R : dchi2L);
}

double KalFitTrack::chi2_next(Helix& H, KalFitHitMdc & HitMdc, int csmflag){

	double lr = HitMdc.LR();
	const KalFitWire& Wire = HitMdc.wire();
	int wire_ID = Wire.geoID();
	int layerid = HitMdc.wire().layer().layerId();
	double entrangle = HitMdc.rechitptr()->getEntra();	

	HepPoint3D fwd(Wire.fwd());
	HepPoint3D bck(Wire.bck());
	Hep3Vector wire = (Hep3Vector)fwd -(Hep3Vector)bck;
	Helix work = H;
	work.ignoreErrorMatrix();
	work.pivot((fwd + bck) * .5);
	HepPoint3D x0kal = (work.x(0).z() - bck.z())/ wire.z() * wire + bck;
	H.pivot(x0kal);

	Hep3Vector meas = H.momentum(0).cross(wire).unit();

	if (wire_ID<0 || wire_ID>6796){  //bes
		std::cout << "KalFitTrack : wire_ID problem : " << wire_ID 
			<< std::endl;
		return DBL_MAX;
	} 

	double x[3] ={pivot().x(), pivot().y(), pivot().z()};
	double pmom[3] ={momentum().x(), momentum().y(), momentum().z()};
	double tofest(0);
	double phi = fmod(phi0() + M_PI4, M_PI2);
	double csf0 = cos(phi);
	double snf0 = (1. - csf0) * (1. + csf0);
	snf0 = sqrt((snf0 > 0.) ? snf0 : 0.);
	if(phi > M_PI) snf0 = - snf0;

	if (Tof_correc_) {
		Hep3Vector ip(0, 0, 0);
		Helix work = *(Helix*)this;
		work.ignoreErrorMatrix();
		work.pivot(ip);
		double phi_ip = work.phi0();
		if (fabs(phi - phi_ip) > M_PI) {
			if (phi > phi_ip) phi -= 2 * M_PI;
			else phi_ip -= 2 * M_PI;
		}
		double t = tanl();
		double l = fabs(radius() * (phi - phi_ip) * sqrt(1 + t * t));
		double pmag( sqrt( 1.0 + t*t ) / kappa());
		double mass_over_p( mass_ / pmag );
		double beta( 1.0 / sqrt( 1.0 + mass_over_p * mass_over_p ) );
		tofest = l / ( 29.9792458 * beta );
		if(csmflag==1 && HitMdc.wire().y()>0.)  tofest= -1. * tofest;
	}

	const HepSymMatrix& ea = H.Ea();
	const HepVector& v_a = H.a();
	double dchi2R(DBL_MAX), dchi2L(DBL_MAX);

	HepVector v_H(5, 0);
	v_H[0] =  -csf0 * meas.x() - snf0 * meas.y();
	v_H[3] =  -meas.z();
	HepMatrix v_HT = v_H.T();

	double estim = (v_HT * v_a)[0];
	HepVector ea_v_H = ea * v_H;
	HepMatrix ea_v_HT = (ea_v_H).T();
	HepVector v_H_T_ea_v_H = v_HT * ea_v_H;

	HepSymMatrix eaNewL(5), eaNewR(5);
	HepVector aNewL(5), aNewR(5);

	//double time = HitMdc.tdc();
	//if (Tof_correc_)
	// time = time - tofest;
	double drifttime = getDriftTime(HitMdc , tofest);
	double ddl = getDriftDist(HitMdc, drifttime , 0 );
	double ddr = getDriftDist(HitMdc, drifttime , 1 );
	double erddl = getSigma( HitMdc, H.a()[4], 0, ddl);
	double erddr = getSigma( HitMdc, H.a()[4], 1, ddr);

	double dmeas2[2] = { 0.1*ddl, 0.1*ddr };
	double er_dmeas2[2] = {0. , 0.};
	if(resolflag_ == 1) { 
		er_dmeas2[0] = 0.1*erddl; 
		er_dmeas2[1] = 0.1*erddr;
	} 
	else if(resolflag_ == 0) {
		//  int layid = HitMdc.wire().layer().layerId();
		//  double sigma = getSigma(layid, dd);
		//  er_dmeas2[0] = er_dmeas2[1] = sigma;
	}

	if ((LR_==0 && lr != 1.0) || 
			(LR_==1 && lr == -1.0)) {

		double er_dmeasL, dmeasL;
		if(Tof_correc_) {
			dmeasL = (-1.0)*fabs(dmeas2[0]);
			er_dmeasL = er_dmeas2[0];
		} else {
			dmeasL = (-1.0)*fabs(HitMdc.dist()[0]);
			er_dmeasL = HitMdc.erdist()[0];
		}

		double AL = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasL*er_dmeasL);
		eaNewL.assign(ea - ea_v_H * AL * ea_v_HT);
		double RkL = 1 - (v_H_T_ea_v_H)[0] * AL;
		if(0. == RkL) RkL = 1.e-4;

		HepVector diffL = ea_v_H * AL * (dmeasL - estim);
		aNewL = v_a + diffL;
		double sigL = dmeasL -(v_HT * aNewL)[0];
		dchi2L = (sigL * sigL) /  (RkL * er_dmeasL*er_dmeasL);
	}

	if ((LR_==0 && lr != -1.0) ||
			(LR_==1 && lr == 1.0)) {

		double er_dmeasR, dmeasR;
		if(Tof_correc_) {
			dmeasR = dmeas2[1];
			er_dmeasR = er_dmeas2[1];
		} else {
			dmeasR = fabs(HitMdc.dist()[1]);
			er_dmeasR = HitMdc.erdist()[1];
		}

		double AR = 1 / ((v_H_T_ea_v_H)[0] + er_dmeasR*er_dmeasR);
		eaNewR.assign(ea - ea_v_H * AR * ea_v_HT);
		double RkR = 1 - (v_H_T_ea_v_H)[0] * AR;
		if(0. == RkR) RkR = 1.e-4;

		HepVector diffR = ea_v_H * AR * (dmeasR - estim);
		aNewR = v_a + diffR;
		double sigR = dmeasR -(v_HT * aNewR)[0];
		dchi2R = (sigR*sigR) /  (RkR * er_dmeasR*er_dmeasR);
	} 

	if (dchi2R < dchi2L){
		H.a(aNewR); H.Ea(eaNewR);
	} else {
		H.a(aNewL); H.Ea(eaNewL);
	}
	return ((dchi2R < dchi2L) ? dchi2R : dchi2L);
}


double KalFitTrack::getSigma(int layerId, double driftDist ) const {
	double sigma1,sigma2,f;
	driftDist *= 10;//mm
	if(layerId<8){
		if(driftDist<0.5){
			sigma1=0.112784;      sigma2=0.229274;      f=0.666;
		}else if(driftDist<1.){
			sigma1=0.103123;      sigma2=0.269797;      f=0.934;
		}else if(driftDist<1.5){
			sigma1=0.08276;        sigma2=0.17493;      f=0.89;
		}else if(driftDist<2.){
			sigma1=0.070109;      sigma2=0.149859;      f=0.89;
		}else if(driftDist<2.5){
			sigma1=0.064453;      sigma2=0.130149;      f=0.886;
		}else if(driftDist<3.){
			sigma1=0.062383;      sigma2=0.138806;      f=0.942;
		}else if(driftDist<3.5){
			sigma1=0.061873;      sigma2=0.145696;      f=0.946;
		}else if(driftDist<4.){
			sigma1=0.061236;      sigma2=0.119584;      f=0.891;
		}else if(driftDist<4.5){
			sigma1=0.066292;      sigma2=0.148426;      f=0.917;
		}else if(driftDist<5.){
			sigma1=0.078074;      sigma2=0.188148;      f=0.911;
		}else if(driftDist<5.5){
			sigma1=0.088657;      sigma2=0.27548;      f=0.838;
		}else{
			sigma1=0.093089;      sigma2=0.115556;      f=0.367;
		}
	}else{
		if(driftDist<0.5){
			sigma1=0.112433;      sigma2=0.327548;      f=0.645;
		}else if(driftDist<1.){
			sigma1=0.096703;      sigma2=0.305206;      f=0.897;
		}else if(driftDist<1.5){
			sigma1=0.082518;      sigma2=0.248913;      f= 0.934;
		}else if(driftDist<2.){
			sigma1=0.072501;      sigma2=0.153868;      f= 0.899;
		}else if(driftDist<2.5){
			sigma1= 0.065535;     sigma2=0.14246;       f=0.914;
		}else if(driftDist<3.){
			sigma1=0.060497;      sigma2=0.126489;      f=0.918;
		}else if(driftDist<3.5){
			sigma1=0.057643;      sigma2= 0.112927;     f=0.892;
		}else if(driftDist<4.){
			sigma1=0.055266;      sigma2=0.094833;      f=0.887;
		}else if(driftDist<4.5){
			sigma1=0.056263;      sigma2=0.124419;      f= 0.932;
		}else if(driftDist<5.){
			sigma1=0.056599;      sigma2=0.124248;      f=0.923;
		}else if(driftDist<5.5){
			sigma1= 0.061377;     sigma2=0.146147;      f=0.964;
		}else if(driftDist<6.){
			sigma1=0.063978;      sigma2=0.150591;      f=0.942;
		}else if(driftDist<6.5){
			sigma1=0.072951;      sigma2=0.15685;       f=0.913;
		}else if(driftDist<7.){
			sigma1=0.085438;      sigma2=0.255109;      f=0.931;
		}else if(driftDist<7.5){
			sigma1=0.101635;      sigma2=0.315529;      f=0.878;
		}else{
			sigma1=0.149529;      sigma2=0.374697;      f=0.89;
		}
	}
	double sigmax = sqrt(f*sigma1*sigma1+(1 - f)*sigma2*sigma2)*0.1;
	return sigmax;//cm
}

