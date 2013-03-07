#include "Poco/OSP/Service.h"

class AdditionService : public Poco::OSP::Service
{
	int add(int &a, int &b);
};