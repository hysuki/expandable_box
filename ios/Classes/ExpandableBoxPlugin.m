#import "ExpandableBoxPlugin.h"
#if __has_include(<expandable_box/expandable_box-Swift.h>)
#import <expandable_box/expandable_box-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "expandable_box-Swift.h"
#endif

@implementation ExpandableBoxPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftExpandableBoxPlugin registerWithRegistrar:registrar];
}
@end
