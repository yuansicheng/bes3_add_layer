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

    getInfoFromEvtRecTrack();


    m_tuple->write();
    log << MSG::DEBUG << "m_event: " << m_event << endmsg;
    m_event += 1;
    m_event_id = m_event;


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
    m_tuple->addItem("event_id", m_event_id);

    m_tuple->addItem("ntrack", m_ntrack, 0, 100);
        m_tuple->addIndexedItem("trick_id", m_ntrack, m_track_id);

        // mdc track info
        m_tuple->addIndexedItem("mdc_p", m_ntrack, m_mdc_p);
        m_tuple->addIndexedItem("mdc_px", m_ntrack, m_mdc_px);
        m_tuple->addIndexedItem("mdc_py", m_ntrack, m_mdc_py);
        m_tuple->addIndexedItem("mdc_pz", m_ntrack, m_mdc_pz);

        // kal track info
        m_tuple->addIndexedItem("kal_p", m_ntrack, m_kal_p);
        m_tuple->addIndexedItem("kal_px", m_ntrack, m_kal_px);
        m_tuple->addIndexedItem("kal_py", m_ntrack, m_kal_py);
        m_tuple->addIndexedItem("kal_pz", m_ntrack, m_kal_pz);

        // part id
        m_tuple->addIndexedItem("is_e", m_ntrack, m_is_e);
        m_tuple->addIndexedItem("is_mu", m_ntrack, m_is_mu);
        m_tuple->addIndexedItem("is_pi", m_ntrack, m_is_pi);
        m_tuple->addIndexedItem("is_k", m_ntrack, m_is_k);
        m_tuple->addIndexedItem("is_p", m_ntrack, m_is_p);

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
        

        m_is_e[m_ntrack] = (*trk)->isElectron();
        m_is_mu[m_ntrack] = (*trk)->isMuon();
        m_is_pi[m_ntrack] = (*trk)->isPion();
        m_is_k[m_ntrack] = (*trk)->isKaon();
        m_is_p[m_ntrack] = (*trk)->isProton();

        // extract mdc track info
        if ((*trk)->isMdcTrackValid()){           
            RecMdcTrack* mdc_track = (*trk)->mdcTrack();
            m_mdc_p[m_ntrack] = mdc_track->p();

            m_mdc_px[m_ntrack] = mdc_track->px();
            m_mdc_py[m_ntrack] = mdc_track->py();
            m_mdc_pz[m_ntrack] = mdc_track->pz();

        }

        // extract kalman track info
        if ((*trk)->isMdcKalTrackValid()){           
            RecMdcKalTrack* kal_track = (*trk)->mdcKalTrack();
            RecMdcKalTrack::setPidType  (pid_type);
            log << MSG::DEBUG << "RecMdcKalTrack::getPidType(): " << RecMdcKalTrack::getPidType() << endmsg;
            m_kal_p[m_ntrack] = kal_track->p();

            m_kal_px[m_ntrack] = kal_track->px();
            m_kal_py[m_ntrack] = kal_track->py();
            m_kal_pz[m_ntrack] = kal_track->pz();

        }

        m_ntrack += 1;
        
    }

    return true;
}


