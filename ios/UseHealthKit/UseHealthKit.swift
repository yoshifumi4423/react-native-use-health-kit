import HealthKit

/*!
 @class         UseHealthKit
 @abstract      This class provides an interface for accessing and storing the user's health data.
 */
@objc(UseHealthKit)
class UseHealthKit: NSObject {
    enum Error: String {
        case error = "Error"
        case notAvailable = "HealthData is not available"
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

    
    /// Keeps instance of HKHealthStore. Will be initialized in initializer.
    let healthStore: HKHealthStore

    
    /// Initializer.
    override init() {
        self.healthStore = HKHealthStore()
    }
    
    
    /// HealthKit is not supported on all iOS devices such as iPad.
    ///
    /// - Returns: Returns true if HealthKit is supported on the device; otherwise false.
    func isHealthDataAvailable() -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            return false
        }

        return true
    }

    
    /// HealthKit is not supported on all iOS devices such as iPad.
    ///
    /// - Parameters:
    ///   - resolve: Return true if HealthKit is supported on the device.
    ///   - reject: Return false if HealthKit is not supported on the device.
    @objc func isHealthDataAvailable(_ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
        guard isHealthDataAvailable() else {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }

        resolve(true)
    }
    
    
    /// Initialize HKHealthStore with write and read permissions. This method should be called once to prevent unnecessary process.
    ///
    /// - Parameters:
    ///   - readPermissions: Array of string for read permission.
    ///   - writePermissions: Array of string for write permission.
    ///   - resolve: Return true if init is succeeded.
    ///   - reject: Return error message if init is failed.
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

    
    /// Return true to use this native module in main thread for heavy processing such as rendering UI.
    /// Return false to use this native module in secondly thread.
    ///
    /// - Returns: true for main thread; otherwise false.
    @objc static func requiresMainQueueSetup() -> Bool {
        return false
    }
}
