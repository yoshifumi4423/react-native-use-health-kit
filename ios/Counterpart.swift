import Foundation
import HealthKit

private enum HealthType: String {
    case sleepAnalysis
    case heartRate
    case dietaryWater
    case bodyMass
    case bodyFatPercentage
    case activeEnergyBurned
    case basalEnergyBurned
    case flightsClimbed
    case stepCount
    case distanceWalkingRunning
    case dietaryEnergyConsumed
    case bodyMassIndex
    case restingHeartRate
}

private var Permissions: [String: HKObjectType] = [
    HealthType.heartRate.rawValue: HKObjectType.quantityType(forIdentifier: .heartRate)!,
    HealthType.dietaryWater.rawValue: HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
    HealthType.bodyMass.rawValue: HKObjectType.quantityType(forIdentifier: .bodyMass)!,
    HealthType.bodyFatPercentage.rawValue: HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
    HealthType.activeEnergyBurned.rawValue: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
    HealthType.basalEnergyBurned.rawValue: HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
    HealthType.flightsClimbed.rawValue: HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
    HealthType.stepCount.rawValue: HKObjectType.quantityType(forIdentifier: .stepCount)!,
    HealthType.distanceWalkingRunning.rawValue: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
    HealthType.dietaryEnergyConsumed.rawValue: HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
    HealthType.bodyMassIndex.rawValue: HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
]

func getPermissions() -> [String: HKObjectType] {
    if #available(iOS 11.0, *) {
        if !(Permissions[HealthType.restingHeartRate.rawValue] != nil) {
            Permissions.updateValue(HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
                                    forKey: HealthType.restingHeartRate.rawValue)
        }
    }

    return Permissions
}

private var QuantityTypeIdentifiers: [String: HKQuantityTypeIdentifier] = [
    HealthType.heartRate.rawValue: HKQuantityTypeIdentifier.heartRate,
    HealthType.dietaryWater.rawValue: HKQuantityTypeIdentifier.dietaryWater,
    HealthType.bodyMass.rawValue: HKQuantityTypeIdentifier.bodyMass,
    HealthType.bodyFatPercentage.rawValue: HKQuantityTypeIdentifier.bodyFatPercentage,
    HealthType.activeEnergyBurned.rawValue: HKQuantityTypeIdentifier.activeEnergyBurned,
    HealthType.basalEnergyBurned.rawValue: HKQuantityTypeIdentifier.basalEnergyBurned,
    HealthType.flightsClimbed.rawValue: HKQuantityTypeIdentifier.flightsClimbed,
    HealthType.stepCount.rawValue: HKQuantityTypeIdentifier.stepCount,
    HealthType.distanceWalkingRunning.rawValue: HKQuantityTypeIdentifier.distanceWalkingRunning,
    HealthType.dietaryEnergyConsumed.rawValue: HKQuantityTypeIdentifier.dietaryEnergyConsumed,
    HealthType.bodyMassIndex.rawValue: HKQuantityTypeIdentifier.bodyMassIndex,
]

func getQuantityTypeIdentifiers() -> [String: HKQuantityTypeIdentifier] {
    if #available(iOS 11.0, *) {
        if !(QuantityTypeIdentifiers[HealthType.restingHeartRate.rawValue] != nil) {
            QuantityTypeIdentifiers.updateValue(HKQuantityTypeIdentifier.restingHeartRate,
                                                forKey: HealthType.restingHeartRate.rawValue)
        }
    }

    return QuantityTypeIdentifiers
}
