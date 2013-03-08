#include "Poco/OSP/Service.h"
#include "ServiceLibrary_export.h"

class SERVICELIBRARY_EXPORT AdditionService : public Poco::OSP::Service
{
public:
	int add(int a, int b);
};