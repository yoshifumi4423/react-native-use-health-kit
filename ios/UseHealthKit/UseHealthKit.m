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

RCT_EXTERN_METHOD(setQuantityData
                  : (NSDictionary *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getDietaryWater
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyMass
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyFatPercentage
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getRestingHeartRate
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getActiveEnergyBurned
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBasalEnergyBurned
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getFlightsClimbed
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getStepCount
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getDistanceWalkingRunning
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getDietaryEnergyConsumed
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyMassIndex
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(deleteQuantityData
                  : (NSDictionary *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)
@end
