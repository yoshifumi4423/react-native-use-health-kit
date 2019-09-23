#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(UseHealthKit, NSObject)
RCT_EXTERN_METHOD(increment: (NSInteger)origin withCallback:(RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(decrement: (NSInteger)origin withResolve:(RCTPromiseResolveBlock)resolve withReject:(RCTPromiseRejectBlock)reject)
@end
