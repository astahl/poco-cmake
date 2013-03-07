#include "ConsumerBundleActivator.h"
#include "Poco/OSP/ServiceRegistry.h"
#include "Poco/Logger.h"
#include "AdditionService.h"

void ConsumerBundleActivator::start(Poco::OSP::BundleContext::Ptr context)
{
	Poco::AutoPtr<AdditionService> service = context->registry().findByName("com.example.additionservice")->castedInstance<AdditionService>();
	int result = service->add(3, 4);
	context->logger().information("result "+result);
}

void ConsumerBundleActivator::stop(Poco::OSP::BundleContext::Ptr context)
{
}
