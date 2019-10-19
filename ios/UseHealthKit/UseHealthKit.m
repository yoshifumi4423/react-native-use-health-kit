#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE (UseHealthKit, NSObject)
RCT_EXTERN_METHOD(isHealthDataAvailable
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(initHealthKit
                  : (NSArray *)readPermissions
                  : (NSArray *)writePermissions
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBasalEnergyBurned
                  : (NSDate *)startDate
                  : (NSDate *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyMass
                  : (NSDate *)startDate
                  : (NSDate *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setBodyMass
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)
@end
