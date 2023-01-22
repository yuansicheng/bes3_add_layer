#include "GaudiKernel/DeclareFactoryEntries.h"
#include "VertexFit/VertexDbSvc.h"
#include "test_read.h"
 
  DECLARE_ALGORITHM_FACTORY( test_read )
 DECLARE_SERVICE_FACTORY(VertexDbSvc)
DECLARE_FACTORY_ENTRIES ( VertexFit)
{
     DECLARE_SERVICE( VertexDbSvc );
}
