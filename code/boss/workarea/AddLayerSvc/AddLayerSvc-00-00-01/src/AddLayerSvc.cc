#include "GaudiKernel/MsgStream.h"
#include "GaudiKernel/Kernel.h"
#include "GaudiKernel/IInterface.h"
#include "GaudiKernel/StatusCode.h"
#include "GaudiKernel/SvcFactory.h"

#include "GaudiKernel/IIncidentSvc.h"
#include "GaudiKernel/Incident.h"
#include "GaudiKernel/IIncidentListener.h"

#include "GaudiKernel/ISvcLocator.h"
#include "GaudiKernel/Bootstrap.h"

#include "AddLayerSvc/AddLayerSvc.hh"
#include "CLHEP/Vector/ThreeVector.h"
#include "CLHEP/Vector/LorentzVector.h"

AddLayerSvc::AddLayerSvc(const std::string& name, ISvcLocator* svcloc): Service (name, svcloc){
    declareProperty("AddLayerFlag", m_add_layer_flag = false);
    declareProperty("ParticleType", m_particle_type = 0);
    declareProperty("Thickness", m_thickness = 0.);
    declareProperty("Material", m_material = "");

    // save anti_neutron final momentum
    declareProperty("SaveAntiNeutronFinalMomentum", m_save_anti_neutron_final_momentum = false);
    declareProperty("FileIndex", m_file_index = 0);


    setMaterial();
}

AddLayerSvc::~AddLayerSvc(){}

StatusCode AddLayerSvc::queryInterface(const InterfaceID& riid, void** ppvInterface){
    if( IID_IAddLayerSvc.versionMatch(riid) ){
        *ppvInterface = static_cast<IAddLayerSvc*> (this);
    } 
    else{
        return Service::queryInterface(riid, ppvInterface);
    }
    return StatusCode::SUCCESS;
}

StatusCode AddLayerSvc::initialize(){
    MsgStream log(messageService(), name());
    log << MSG::INFO << "========== AddLayerSvc::initialize() ==========" << endreq;

    StatusCode sc = Service::initialize();

    // if necessary, open a csv file
    if (m_save_anti_neutron_final_momentum){
        char path[30];
        sprintf(path, "anti_neutron_%d.csv", m_file_index);
        m_anti_neutron_final_momentum.open(path);

        m_anti_neutron_final_momentum << "run_no,event,final_p,final_px,final_py,final_pz,final_theta,final_phi\n";
    }

    return sc;
}

StatusCode AddLayerSvc::finalize(){
    MsgStream log(messageService(), name());
    log << MSG::INFO << "========== AddLayerSvc::finalize() ==========" << endreq;

    if (m_save_anti_neutron_final_momentum){
        m_anti_neutron_final_momentum.close();
    }

    return StatusCode::SUCCESS;
}

void AddLayerSvc::setMaterial(){
    G4double density, z;
    G4int nel, natoms;
    G4String name, symbol;
    // ------------------------------------------------
    // G4Element* H  = new G4Element(name="Hydrogen",symbol="H" , z= 1., 1.0*g/mole);
    // G4Element* D = new G4Element(name="Deuterium",symbol="D" , z= 1., 2.0*g/mole);
    G4Element* Cs  = new G4Element(name="Cs"  ,symbol="Cs" , z= 55., 132.9*g/mole);
    G4Element* I  = new G4Element(name="I"  ,symbol="I" , z= 53., 126.9*g/mole);

    // ------------------------------------------------

    // liquid hydrogen
    density = 0.0708*g/cm3;
    m_material_map["LH"] = new G4Material(name="LH",1,2.02*g/mole,density);

    // liquid Deuterium
    density = 0.169*g/cm3;
    m_material_map["LD"]  = new G4Material(name="LD",1,4.03*g/mole,density);

    // CsI
    density = 4.51*g/cm3;
    G4Material* CsI = new G4Material(name="CsI",density,nel=2);
    CsI->AddElement(Cs, natoms=1);
    CsI->AddElement(I, natoms=1);
    m_material_map["CsI"] = CsI;
    
}

G4Material* AddLayerSvc::getMaterial(std::string material_name){
    MsgStream log(messageService(), name());
    std::map<std::string, G4Material*>::iterator it;
    it = m_material_map.find(material_name);
    if (it == m_material_map.end()){
        log << MSG::ERROR << "G4Material" << material_name << " has not been defined" << endreq;
        it = m_material_map.begin();
    }
    return it->second;
}


void AddLayerSvc::writeAntiNeutronMomentumOne(int run_no, int event, double p, double px, double py, double pz, double theta, double phi){
    m_anti_neutron_final_momentum << 
       run_no << "," <<
       event << "," <<
       p << "," <<
       px << "," <<
       py << "," <<
       pz << "," <<
       theta << "," <<
       phi << "\n";
}
