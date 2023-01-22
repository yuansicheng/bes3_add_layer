#ifndef ADDLAYERSVC_H_
#define ADDLAYERSVC_H_

#include "GaudiKernel/IInterface.h"
#include "GaudiKernel/Kernel.h"
#include "GaudiKernel/Service.h"
#include "GaudiKernel/IIncidentListener.h"
#include "G4Material.hh"

#include "AddLayerSvc/IAddLayerSvc.hh"

#include <string>
#include <map>

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

#include "CLHEP/Vector/ThreeVector.h"
#include "CLHEP/Vector/LorentzVector.h"

class AddLayerSvc: public Service, virtual public IAddLayerSvc{
    public:
        AddLayerSvc(const std::string& name, ISvcLocator* svcloc);
        ~AddLayerSvc();

        virtual StatusCode queryInterface(const InterfaceID& riid, void** ppvUnknown);
        virtual StatusCode initialize();
        virtual StatusCode finalize();

        bool getAddLayerFlag(){return m_add_layer_flag;}
        G4Material* getMaterial(std::string);

        float getThickness(){return m_thickness;}
        int getParticleType(){return m_particle_type;}

        std::string getMaterialName(){return m_material;}

        void writeAntiNeutronMomentumOne(int, int, double, double, double, double, double, double);
        bool getSaveAntiNeutronFinalMomentumFlag(){return m_save_anti_neutron_final_momentum;}

    private:
        bool m_add_layer_flag;
        std::map<std::string, G4Material*> m_material_map;
        float m_thickness;
        int m_particle_type;
        std::string m_material;

        bool m_save_anti_neutron_final_momentum;
        int m_file_index;
        std::ofstream m_anti_neutron_final_momentum;

        void setMaterial();

        

};

#endif
