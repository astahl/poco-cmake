#include "ConsumerBundleActivator.h"
#include "Poco/OSP/ServiceRegistry.h"
#include "Poco/Logger.h"
#include "AdditionService.h"
#include "Poco/NumberFormatter.h"

void ConsumerBundleActivator::start(Poco::OSP::BundleContext::Ptr context)
{
	Poco::AutoPtr<AdditionService> service = context->registry().findByName("com.example.additionservice")->castedInstance<AdditionService>();
	int result = service->add(3, 4);
	context->logger().information("Addition Service says: 3 + 4 = "+ Poco::NumberFormatter().format(result));
}

void ConsumerBundleActivator::stop(Poco::OSP::BundleContext::Ptr context)
{
}
