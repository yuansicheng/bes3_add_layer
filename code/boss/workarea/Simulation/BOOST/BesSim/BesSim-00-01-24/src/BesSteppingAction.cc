
#include "BesSteppingAction.hh"
#include "G4StepPoint.hh"
#include "G4ThreeVector.hh"
#include "G4Track.hh"

#include "G4UnitsTable.hh"
#include "G4VProcess.hh"

#include "AddLayerSvc/AddLayerSvc.hh"

#include "GaudiKernel/ISvcLocator.h"
#include "GaudiKernel/MsgStream.h"
#include "GaudiKernel/SmartDataPtr.h"
#include "GaudiKernel/Bootstrap.h"

#include "EventModel/EventHeader.h"
#include "EventModel/EventModel.h"
#include "EventModel/Event.h"

#include "GaudiKernel/IDataProviderSvc.h"

BesSteppingAction::BesSteppingAction()
{ }

BesSteppingAction::~BesSteppingAction()
{ }


void BesSteppingAction::UserSteppingAction(const G4Step* currentStep)
{

  G4StepPoint* postStep = currentStep->GetPostStepPoint();
  G4ThreeVector currentPosition = postStep->GetPosition();
  G4Track* currentTrack = currentStep->GetTrack();
  if(std::abs(currentPosition.x()) > 263.5*cm||
     std::abs(currentPosition.y()) > 263.5*cm||
     std::abs(currentPosition.z()) > 287.5*cm){
    G4cout<<"Out of World!!!"<<G4endl;
    currentTrack->SetTrackStatus(fKillTrackAndSecondaries);
  }else if(currentTrack->GetCurrentStepNumber()>=20000){ 
    G4cout<<"StepNumber>=20000 !!!"<<G4endl;
    currentTrack->SetTrackStatus(fKillTrackAndSecondaries);
  }


  // yuansc
  // query AddLayerSvc to get thickness
  ISvcLocator* svcLocator = Gaudi::svcLocator();
  IAddLayerSvc* add_layer_svc;
  StatusCode sc = svcLocator->service("AddLayerSvc", add_layer_svc);
  if(sc != StatusCode::SUCCESS) {
    std::cout << "AddLayerSvc\t" << "Error: Can't get AddLayerSvc." << std::endl;
  }

  // kill anti-n0 for ppinbar
  if (!add_layer_svc->getSaveAntiNeutronFinalMomentumFlag() && currentTrack->GetDefinition()->GetParticleName()=="anti_neutron"){
    currentTrack->SetTrackStatus(fKillTrackAndSecondaries);
  }
  
  if (add_layer_svc->getSaveAntiNeutronFinalMomentumFlag() && currentTrack->GetDefinition()->GetParticleName()=="anti_neutron"){

    float thickness = 0.;
    if (add_layer_svc->getAddLayerFlag()){
      thickness = add_layer_svc->getThickness();
    }

    double x, y, z, rxy;
    x = std::abs(currentPosition.x());
    y = std::abs(currentPosition.y());
    z = std::abs(currentPosition.z());

    rxy = sqrt(x*x + y*y);
    

    // std::cout << "rxy: " << rxy << std::endl;

    if (
      rxy > (3.37*cm + (thickness/10)*cm) ||
      z > 13.4*cm
    ){

      IDataProviderSvc* evtSvc;
      StatusCode sc=svcLocator->service("EventDataSvc", evtSvc);
      SmartDataPtr<Event::EventHeader> evt(evtSvc,"/Event/EventHeader");
      int run_no, event;
      run_no = evt->runNumber();
      event = evt->eventNumber();


    
      G4ThreeVector p = currentTrack->GetMomentum();
      add_layer_svc->writeAntiNeutronMomentumOne(run_no, event, p.r(), p.x(), p.y(), p.z(), p.theta(), p.phi());

      currentTrack->SetTrackStatus(fKillTrackAndSecondaries);
    }
  }


/*     G4cout.precision(15);
     G4cout<<"#Step# "<<currentTrack->GetCurrentStepNumber()<<" pName "<<currentTrack->GetDefinition()->GetParticleName()<<" prex prey prez "<<currentStep->GetPreStepPoint()->GetPosition().x()/mm<<" "<<currentStep->GetPreStepPoint()->GetPosition().y()/mm<<" "<<currentStep->GetPreStepPoint()->GetPosition().z()/mm<<G4endl;
     G4cout<<"prepx prepy prepz "<<currentStep->GetPreStepPoint()->GetMomentum().x()/GeV<<" "<<currentStep->GetPreStepPoint()->GetMomentum().y()/GeV<<" "<<currentStep->GetPreStepPoint()->GetMomentum().z()/GeV<<G4endl;
     G4cout<<"post step postx posty postz "<<postStep->GetPosition().x()/mm<<" "<<postStep->GetPosition().y()/mm<<" "<<postStep->GetPosition().z()/mm<<G4endl;
     G4cout<<"postpx postpy postpz "<<postStep->GetMomentum().x()/GeV<<" "<<postStep->GetMomentum().y()/GeV<<" "<<postStep->GetMomentum().z()/GeV<<G4endl;         
      G4cout << G4endl;
      G4cout << std::setw( 5) << "#Step#"     << " "
             << std::setw( 9) << "pName"      << " "
             << std::setw( 6) << "X"          << "    "
             << std::setw( 6) << "Y"          << "    "
             << std::setw( 6) << "Z"          << "    "
             << std::setw( 9) << "KineE"      << " "
             << std::setw( 9) << "dEStep"     << " "
             << std::setw(10) << "StepLeng"
             << std::setw(10) << "Volume"    << "  "
             << std::setw(10) << "Process"  
             << G4endl;
    

    G4cout << std::setw(5) << currentTrack->GetCurrentStepNumber() << " "
        << std::setw(9) << currentTrack->GetDefinition()->GetParticleName()
        << std::setw(6) << G4BestUnit(currentTrack->GetPosition().x(),"Length")
        << std::setw(6) << G4BestUnit(currentTrack->GetPosition().y(),"Length")
        << std::setw(6) << G4BestUnit(currentTrack->GetPosition().z(),"Length")
        << std::setw(6) << G4BestUnit(currentTrack->GetKineticEnergy(),"Energy")
        << std::setw(6) << G4BestUnit(currentStep->GetTotalEnergyDeposit(),"Energy")
        << std::setw(6) << G4BestUnit(currentStep->GetStepLength(),"Length");
    if( currentTrack->GetNextVolume() != 0 ) { 
        G4cout << std::setw(10) << currentTrack->GetVolume()->GetName();
     } else {
       G4cout << std::setw(10) << "OutOfWorld";
     }

    if(currentStep->GetPostStepPoint()->GetProcessDefinedStep() != NULL){
      G4cout << "  "
        << std::setw(10) << currentStep->GetPostStepPoint()->GetProcessDefinedStep()
                                        ->GetProcessName();
    } else {
      G4cout << "   UserLimit";
    }

    G4cout << G4endl;
   HepRandom::showEngineStatus();
*/
}



