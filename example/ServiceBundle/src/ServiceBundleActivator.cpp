#include "ServiceBundleActivator.h"
#include "Poco/OSP/ServiceRegistry.h"
#include "AdditionService.h"

void ServiceBundleActivator::start(Poco::OSP::BundleContext::Ptr context)
{
	context->registry().registerService("com.example.additionservice", new AdditionService(), Poco::OSP::Properties());
}

void ServiceBundleActivator::stop(Poco::OSP::BundleContext::Ptr context)
{
	context->registry().unregisterService("com.example.additionservice");
}
