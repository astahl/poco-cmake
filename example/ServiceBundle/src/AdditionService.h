#include "Poco/OSP/Service.h"

class AdditionService : public Poco::OSP::Service
{
public:
	int add(int a, int b);
};