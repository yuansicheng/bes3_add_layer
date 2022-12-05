#ifndef IADDLAYERSVC_H_
#define IADDLAYERSVC_H_

#include "GaudiKernel/IInterface.h"
#include "GaudiKernel/Kernel.h"
#include "G4Material.hh"

#include <string>

static const InterfaceID IID_IAddLayerSvc("IAddLayerSvc",1,0);

class IAddLayerSvc: virtual public IInterface{
    public:
        static const InterfaceID& interfaceID() { return IID_IAddLayerSvc; }

        virtual bool getAddLayerFlag()=0;
        virtual G4Material* getMaterial(std::string)=0;

        virtual float getThickness()=0;
        virtual int getParticleType()=0;
        virtual std::string getMaterialName()=0;
};

#endif