#include "GaudiKernel/DeclareFactoryEntries.h"
#include "ExtractRecInfo/extract_single_particle.hh"

DECLARE_ALGORITHM_FACTORY( ExtractSingleParticle )

DECLARE_FACTORY_ENTRIES( ExtractRecInfo ) {
  DECLARE_ALGORITHM(ExtractSingleParticle);
}
