#ifndef ServiceBundleActivator_H
#define ServiceBundleActivator_H

#include "Poco/OSP/BundleActivator.h"
#include "Poco/OSP/BundleContext.h"
#include "Poco/ClassLibrary.h"

class ServiceBundleActivator : public Poco::OSP::BundleActivator
{
	void start(Poco::OSP::BundleContext::Ptr context);
	void stop(Poco::OSP::BundleContext::Ptr context);
};

POCO_BEGIN_MANIFEST(Poco::OSP::BundleActivator)
    POCO_EXPORT_CLASS(ServiceBundleActivator)
POCO_END_MANIFEST
#endif