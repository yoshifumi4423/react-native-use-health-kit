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

RCT_EXTERN_METHOD(getDietaryWater
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setDietaryWater
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBasalEnergyBurned
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyMass
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setBodyMass
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyFatPercentage
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setBodyFatPercentage
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getRestingHeartRate
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setRestingHeartRate
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getActiveEnergyBurned
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setActiveEnergyBurned
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getFlightsClimbed
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setFlightsClimbed
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getStepCount
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setStepCount
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getDistanceWalkingRunning
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setDistanceWalkingRunning
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getDietaryEnergyConsumed
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setDietaryEnergyConsumed
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(getBodyMassIndex
                  : (double *)startDate
                  : (double *)endDate
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setBodyMassIndex
                  : (NSArray *)data
                  : (RCTPromiseResolveBlock)resolve
                  : (RCTPromiseRejectBlock)reject)
@end
