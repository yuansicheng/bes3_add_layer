#include "GaudiKernel/MsgStream.h"
#include "GaudiKernel/AlgFactory.h"
#include "GaudiKernel/Algorithm.h"
#include "GaudiKernel/ISvcLocator.h"
#include "GaudiKernel/SmartDataPtr.h"
#include "GaudiKernel/IDataProviderSvc.h"
#include "GaudiKernel/PropertyMgr.h"
#include "GaudiKernel/Bootstrap.h"
#include "EventModel/EventModel.h"
#include "EventModel/Event.h"
#include "EvtRecEvent/EvtRecEvent.h"
#include "EvtRecEvent/EvtRecTrack.h"
#include "EventModel/EventHeader.h"
#include "DstEvent/TofHitStatus.h"
#include "McTruth/McParticle.h"
#include "McTruth/DecayMode.h"
#include "McTruth/MdcMcHit.h"
#include "McTruth/TofMcHit.h"
#include "McTruth/EmcMcHit.h"
#include "McTruth/TofMcHit.h"
#include "McTruth/MucMcHit.h"
#include "McTruth/McEvent.h"
#include "TMath.h"
#include "GaudiKernel/INTupleSvc.h"
#include "GaudiKernel/NTuple.h"
#include "GaudiKernel/Bootstrap.h"
#include "GaudiKernel/IHistogramSvc.h"
#include "CLHEP/Vector/ThreeVector.h"
#include "CLHEP/Vector/LorentzVector.h"
#include "CLHEP/Vector/TwoVector.h"
#include "CLHEP/Geometry/Point3D.h"
#include "EmcRecGeoSvc/EmcRecBarrelGeo.h"
#include "EmcRecGeoSvc/EmcRecGeoSvc.h"


#include "VertexFit/KalmanKinematicFit.h"
#include "VertexFit/VertexFit.h"
#include "VertexFit/Helix.h"
#include "VertexFit/IVertexDbSvc.h"



#include "ExtractRecInfo/extract_single_particle.hh"
#include "AddLayerSvc/AddLayerSvc.hh"

ExtractSingleParticle::ExtractSingleParticle(const std::string& name, ISvcLocator* pSvcLocator) : Algorithm(name, pSvcLocator) {   
}

StatusCode ExtractSingleParticle::initialize(){
    MsgStream log(msgSvc(), name());		
	log << MSG::INFO << "in initialize()" << endmsg;	

    bookNTuple();  
    m_event = 0;
    log << MSG::DEBUG << "successfully return from initialize()" <<endmsg;
  	return StatusCode::SUCCESS;
}

StatusCode ExtractSingleParticle::execute(){
    MsgStream log(msgSvc(), name());		
	log << MSG::DEBUG << "in execute()" << endmsg;

    getInfoFromEventHeader();
    getInfoFromMcParticleCol();
    getInfoFromEvtRecTrack();

    m_tuple->write();

    return StatusCode::SUCCESS;
}

StatusCode ExtractSingleParticle::finalize(){
    MsgStream log(msgSvc(), name());		
	log << MSG::DEBUG << "in finalize()" << endmsg;

    return StatusCode::SUCCESS;
}

// ////////////////////////////////////////////////////////////

bool ExtractSingleParticle::bookNTuple(){
    m_tuple = ntupleSvc()->book ("FILE1/RecInfo", CLID_ColumnWiseTuple, "N-Tuple");

    // event header
    m_tuple->addItem("run_no", m_run_no);
    m_tuple->addItem("event", m_event);

    // mc partical
    m_tuple->addItem("pdg_code", m_pdg_code);
    m_tuple->addItem("momentum", m_momentum);
    m_tuple->addItem("px", m_px);
    m_tuple->addItem("py", m_py);
    m_tuple->addItem("pz", m_pz);
    m_tuple->addItem("cos_theta", m_cos_theta);
    m_tuple->addItem("theta", m_theta);
    m_tuple->addItem("phi", m_phi);
    m_tuple->addItem("killed", m_killed);
    m_tuple->addItem("final_rxy", m_final_rxy);
    m_tuple->addItem("final_rz", m_final_rz);

    m_tuple->addItem("ntrack", m_ntrack, 0, 100);
        m_tuple->addIndexedItem("trick_id", m_ntrack, m_track_id);

        // // mdc track info
        // m_tuple->addIndexedItem("mdc_p", m_ntrack, m_mdc_p);
        // m_tuple->addIndexedItem("mdc_px", m_ntrack, m_mdc_px);
        // m_tuple->addIndexedItem("mdc_py", m_ntrack, m_mdc_py);
        // m_tuple->addIndexedItem("mdc_pz", m_ntrack, m_mdc_pz);

        // kal track info
        m_tuple->addIndexedItem("kal_p", m_ntrack, m_kal_p);
        m_tuple->addIndexedItem("kal_px", m_ntrack, m_kal_px);
        m_tuple->addIndexedItem("kal_py", m_ntrack, m_kal_py);
        m_tuple->addIndexedItem("kal_pz", m_ntrack, m_kal_pz);
        m_tuple->addIndexedItem("kal_theta", m_ntrack, m_kal_theta);
        m_tuple->addIndexedItem("kal_phi", m_ntrack, m_kal_phi);

    return true;
}

bool ExtractSingleParticle::getInfoFromEventHeader(){
    MsgStream log(msgSvc(),name());
    log << MSG::INFO << "in execute()" << endreq;
    SmartDataPtr<Event::EventHeader> eventHeader(eventSvc(),"/Event/EventHeader");
    m_run_no = eventHeader->runNumber();
    m_event = eventHeader->eventNumber();

    return true;
}

bool ExtractSingleParticle::getInfoFromMcParticleCol(){
    MsgStream log(msgSvc(), name());		
	log << MSG::DEBUG << "in getInfoFromMcParticleCol()" << endmsg;
    // momentum, theta, phi
    SmartDataPtr<Event::McParticleCol> mc_particle_col(eventSvc(), "/Event/MC/McParticleCol");
	if (!mc_particle_col){
	 	std::cout << "Could not retrieve McParticelCol" << std::endl;
	  	return false;
    }

    double px, py, pz;
    
    Event::McParticleCol::iterator iter_mc=mc_particle_col->begin();
    m_px = (*iter_mc)->initialFourMomentum().x();
    m_py = (*iter_mc)->initialFourMomentum().y();
    m_pz = (*iter_mc)->initialFourMomentum().z();

    Hep3Vector final_pos;
    final_pos = (*iter_mc)->finalPosition().v();
    m_final_rxy = sqrt(final_pos.x()*final_pos.x() + final_pos.y()*final_pos.y());
    m_final_rz = final_pos.z();

    Hep3Vector init_p;
    init_p = (*iter_mc)->initialFourMomentum();

    m_cos_theta = init_p.cosTheta();
    m_theta = init_p.theta();
    m_phi = init_p.phi();
    m_momentum = init_p.r();

    m_pdg_code = (*iter_mc)->particleProperty();

    m_killed = ((*iter_mc)->statusFlags() & 1<<13) >> 13;

    return true;
}

bool ExtractSingleParticle::getInfoFromEvtRecTrack(){
    MsgStream log(msgSvc(), name());

    // yuansc
	// query AddLayerSvc to get particle type
	ISvcLocator* svcLocator = Gaudi::svcLocator();
	IAddLayerSvc* add_layer_svc;
	StatusCode sc = svcLocator->service("AddLayerSvc", add_layer_svc);
	if(sc != StatusCode::SUCCESS) {
		G4cout << "AddLayerSvc\t" << "Error: Can't get AddLayerSvc." << G4endl;
  	}
	bool add_layer_flag = add_layer_svc->getAddLayerFlag();

    int pid_code;
    RecMdcKalTrack::PidType pid_type;
	if (add_layer_flag){
		pid_code = add_layer_svc->getParticleType();
        log << MSG::DEBUG << "pid_code: " << pid_code << endmsg;
	}
    switch (pid_code)
    {
    case 0:
        pid_type = RecMdcKalTrack::electron;
        break;
    case 1:
        pid_type = RecMdcKalTrack::muon;
        break;
    case 2:
        pid_type = RecMdcKalTrack::pion;
        break;
    case 3:
        pid_type = RecMdcKalTrack::kaon;
        break;
    case 4:
        pid_type = RecMdcKalTrack::proton;
        break;
    
    default:
        pid_type = RecMdcKalTrack::pion;
        break;
    }

    SmartDataPtr<EvtRecTrackCol> evt_rec_trk_col(eventSvc(),  EventModel::EvtRec::EvtRecTrackCol);
    m_ntrack = 0;
    HepVector mdc_track_distance;
    for(EvtRecTrackCol::iterator trk=evt_rec_trk_col->begin(); trk!= evt_rec_trk_col->end(); trk++){
        m_track_id[m_ntrack] = (*trk)->trackId();

        // // extract mdc track info
        // if ((*trk)->isMdcTrackValid()){           
        //     RecMdcTrack* mdc_track = (*trk)->mdcTrack();
        //     m_mdc_p[m_ntrack] = mdc_track->p();

        //     m_mdc_px[m_ntrack] = mdc_track->px();
        //     m_mdc_py[m_ntrack] = mdc_track->py();
        //     m_mdc_pz[m_ntrack] = mdc_track->pz();

        // }

        // extract kalman track info
        if ((*trk)->isMdcKalTrackValid()){           
            RecMdcKalTrack* kal_track = (*trk)->mdcKalTrack();
            RecMdcKalTrack::setPidType  (pid_type);
            // log << MSG::DEBUG << "RecMdcKalTrack::getPidType(): " << RecMdcKalTrack::getPidType() << endmsg;
            m_kal_p[m_ntrack] = kal_track->p();

            m_kal_px[m_ntrack] = kal_track->px();
            m_kal_py[m_ntrack] = kal_track->py();
            m_kal_pz[m_ntrack] = kal_track->pz();

            m_kal_theta[m_ntrack] = kal_track->theta();
            m_kal_phi[m_ntrack] = kal_track->phi();

        }

        m_ntrack += 1;
        
    }

    return true;
}


