#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(PusherBeamPluginPlugin, "PusherBeamPlugin",
           CAP_PLUGIN_METHOD(checkPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(requestPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(addDeviceInterest, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeDeviceInterest, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getDeviceInterests, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setDeviceInterests, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearDeviceInterests, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setUserID, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearAllState, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(stop, CAPPluginReturnPromise);
)
