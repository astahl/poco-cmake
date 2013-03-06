#include "Poco/OSP/BundleActivator.h"
#include "Poco/OSP/BundleContext.h"
#include "Poco/ClassLibrary.h"

class SimpleBundleActivator : public Poco::OSP::BundleActivator
{
	void start(Poco::OSP::BundleContext::Ptr context);
	void stop(Poco::OSP::BundleContext::Ptr context);
};

POCO_BEGIN_MANIFEST(Poco::OSP::BundleActivator)
    POCO_EXPORT_CLASS(SimpleBundleActivator)
POCO_END_MANIFEST