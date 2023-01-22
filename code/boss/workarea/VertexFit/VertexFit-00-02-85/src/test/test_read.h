#include <stdio.h>
#include "GaudiKernel/Algorithm.h"
#include "GaudiKernel/AlgFactory.h"
#include "GaudiKernel/Service.h"
#include "GaudiKernel/MsgStream.h"
//#include "VertexFit/IVertexDbSvc.h"
using namespace std;
/// Simple algorithm to test reading vertex database
class test_read : public Algorithm {

public:
  test_read(const std::string& name, ISvcLocator* pSvcLocator); 

  StatusCode initialize();

  StatusCode execute();

  StatusCode finalize();

private:

};



