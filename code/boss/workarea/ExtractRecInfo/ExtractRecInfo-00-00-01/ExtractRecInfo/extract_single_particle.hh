#ifndef EXTRACT_SINGLE_PARTICLE_H
#define EXTRACT_SINGLE_PARTICLE_H

#include "GaudiKernel/AlgFactory.h"
#include "GaudiKernel/Algorithm.h"
#include "GaudiKernel/NTuple.h"
#include "GaudiKernel/SmartDataPtr.h"

class HepVector;
class RecMdcTrack;

class ExtractSingleParticle : public Algorithm {
    public:
        ExtractSingleParticle(const std::string& name, ISvcLocator* pSvcLocator);
        StatusCode initialize();
        StatusCode execute();
        StatusCode finalize();

    private:
        bool bookNTuple();
        bool getInfoFromMcParticleCol();
        bool getInfoFromEvtRecTrack();

        int m_event;

        NTuple::Tuple*  m_tuple;
        NTuple::Item<int> m_event_id;
  
        NTuple::Item<int> m_pdg_code;
        NTuple::Item<float> m_momentum;
        NTuple::Item<float> m_theta;
        NTuple::Item<float> m_phi;
        NTuple::Item<bool> m_killed;
        NTuple::Item<float> m_final_rxy;
        NTuple::Item<float> m_final_rz;

        NTuple::Item<int> m_ntrack;
            NTuple::Array<int> m_track_id;

            NTuple::Array<double> m_mdc_p;
            NTuple::Array<double> m_mdc_px;
            NTuple::Array<double> m_mdc_py;
            NTuple::Array<double> m_mdc_pz;

            NTuple::Array<double> m_kal_p;
            NTuple::Array<double> m_kal_px;
            NTuple::Array<double> m_kal_py;
            NTuple::Array<double> m_kal_pz;

            NTuple::Array<bool> m_is_e;
            NTuple::Array<bool> m_is_mu;
            NTuple::Array<bool> m_is_pi;
            NTuple::Array<bool> m_is_k;
            NTuple::Array<bool> m_is_p;
};

#endif