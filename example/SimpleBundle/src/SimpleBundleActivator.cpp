#include "SimpleBundleActivator.h"
#include "Poco/Logger.h"

void SimpleBundleActivator::start(Poco::OSP::BundleContext::Ptr context)
{
	context->logger().information("This is going well!");
}

void SimpleBundleActivator::stop(Poco::OSP::BundleContext::Ptr context)
{
	context->logger().information("Goodbye!");
}
