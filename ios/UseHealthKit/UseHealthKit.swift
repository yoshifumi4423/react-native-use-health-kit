import HealthKit

@objc(UseHealthKit)
class UseHealthKit: NSObject {
    enum Error: String {
        case error = "Error"
        case notAvailable = "HealthData is not available"
        case noPermissions = "No permissions to access user health data"
    }

    let Permissions: [String: HKObjectType] = [
//        // HKCategoryTypeIdentifier
//        // Vital Signs
//        "lowHeartRateEvent": HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!, // iOS 12.2 or newer
//        "highHeartRateEvent": HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!, // iOS 12.2 or newer
//        "irregularHeartRhythmEvent": HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!, // iOS 12.2 or newer
//        // Reproductive Health
//        "cervicalMucusQuality": HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality)!,
//        "menstrualFlow": HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
//        "intermenstrualBleeding": HKObjectType.categoryType(forIdentifier: .intermenstrualBleeding)!,
//        "ovulationTestResult": HKObjectType.categoryType(forIdentifier: .ovulationTestResult)!,
//        "sexualActivity": HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
        // Activity
//        "appleStandHour": HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
        // Mindfullness and Sleep
//        "mindfulSession": HKObjectType.categoryType(forIdentifier: .mindfulSession)!, // iOS 10.0 or newer
        "sleepAnalysis": HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,

        // HKCharacteristicTypeIdentifier
//        "biologicalSex": HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
//        "bloodType": HKObjectType.characteristicType(forIdentifier: .bloodType)!,
//        "dateOfBirth": HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
//        "fitzpatrickSkinType": HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!,
        //        "wheelchairUse": HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!, // iOS 10.0 or newer

        // HKQuantityTypeIdentifier
        "heartRate": HKObjectType.quantityType(forIdentifier: .heartRate)!,
        "dietaryWater": HKObjectType.quantityType(forIdentifier: .dietaryWater)!,
        "bodyMass": HKObjectType.quantityType(forIdentifier: .bodyMass)!,
        "bodyFatPercentage": HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)!,
        "restingHeartRate": HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        "activeEnergyBurned": HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        "basalEnergyBurned": HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
        "flightsClimbed": HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
        "stepCount": HKObjectType.quantityType(forIdentifier: .stepCount)!,
        "distanceWalkingRunning": HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        "dietaryEnergyConsumed": HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!,
        "bodyMassIndex": HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
    ]

    let healthStore: HKHealthStore

    override init() {
        self.healthStore = HKHealthStore()
    }

    func isHealthDataAvailable() -> Bool {
        if HKHealthStore.isHealthDataAvailable() {
            return true
        }

        return false
    }

    @objc func isHealthDataAvailable(_ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
        guard isHealthDataAvailable() else {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }

        resolve(true)
    }

    @objc func initHealthKit(_ readPermissions: [String]!, _ writePermissions: [String]!, _ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
        guard isHealthDataAvailable() else {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }

        var readType: Set<HKObjectType>?
        if !readPermissions.isEmpty {
            let permissions = readPermissions.map { Permissions[$0]! }
            readType = Set(permissions)
        }

        var writeType: Set<HKObjectType>?
        if !writePermissions.isEmpty {
            let permissions = writePermissions.map { Permissions[$0]! }
            writeType = Set(permissions)
        }

        if readType == nil, writeType == nil {
            reject(Error.error.rawValue, Error.noPermissions.rawValue, nil)
            return
        }

        var errorMessage: String?
        healthStore.requestAuthorization(toShare: writeType as? Set<HKSampleType>, read: readType) { _, error in
            if let e = error {
                errorMessage = e.localizedDescription
            }
        }
        if let e = errorMessage {
            reject(Error.error.rawValue, e, nil)
            return
        }
        resolve(true)
    }

    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
