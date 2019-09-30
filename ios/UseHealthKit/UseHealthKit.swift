import HealthKit

@objc(UseHealthKit)
class UseHealthKit: NSObject {
    enum Error: String {
        case error = "Error"
        case notAvailable = "HealthData is not available"
        case noPermissions = "No permissions to access user health data"
    }

    let Permissions: [String: HKSampleType] = [
//        // HKCategoryTypeIdentifier
//        // Vital Signs
//        "lowHeartRateEvent": HKObjectType.categoryType(forIdentifier: .lowHeartRateEvent)!,
//        "highHeartRateEvent": HKObjectType.categoryType(forIdentifier: .highHeartRateEvent)!,
//        "irregularHeartRhythmEvent": HKObjectType.categoryType(forIdentifier: .irregularHeartRhythmEvent)!,
//        // Reproductive Health
//        "cervicalMucusQuality": HKObjectType.categoryType(forIdentifier: .cervicalMucusQuality)!,
//        "menstrualFlow": HKObjectType.categoryType(forIdentifier: .menstrualFlow)!,
//        "intermenstrualBleeding": HKObjectType.categoryType(forIdentifier: .intermenstrualBleeding)!,
//        "ovulationTestResult": HKObjectType.categoryType(forIdentifier: .ovulationTestResult)!,
//        "sexualActivity": HKObjectType.categoryType(forIdentifier: .sexualActivity)!,
//        // Activity
//        "biologicalSex": HKObjectType.categoryType(forIdentifier: .appleStandHour)!,
//        // Mindfullness and Sleep
//        "biologicalSex": HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
//        "biologicalSex": HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
//
//        // HKCharacteristicTypeIdentifier
//        "biologicalSex": HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
//        "bloodType": HKObjectType.characteristicType(forIdentifier: .bloodType)!,
//        "dateOfBirth": HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
//        "fitzpatrickSkinType": HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!,
//        "wheelchairUse": HKObjectType.characteristicType(forIdentifier: .wheelchairUse)!,

        // HKQuantityTypeIdentifier
        "stepCount": HKObjectType.quantityType(forIdentifier: .stepCount)!,
        "heartRate": HKObjectType.quantityType(forIdentifier: .heartRate)!,
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

        var readType: Set<HKSampleType>?
        if !readPermissions.isEmpty {
            let permissions = readPermissions.map { Permissions[$0]! }
            readType = Set(permissions)
        }

        var writeType: Set<HKSampleType>?
        if !writePermissions.isEmpty {
            let permissions = writePermissions.map { Permissions[$0]! }
            writeType = Set(permissions)
        }

        if readType == nil, writeType == nil {
            reject(Error.error.rawValue, Error.noPermissions.rawValue, nil)
            return
        }

        var errorMessage: String?
        healthStore.requestAuthorization(toShare: writeType, read: readType) { _, error in
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
}
