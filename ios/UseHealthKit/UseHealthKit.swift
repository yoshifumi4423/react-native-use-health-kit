import HealthKit

@objc(UseHealthKit)
class UseHealthKit: NSObject {
    enum Error: String {
        case error = "Error"
        case notAvailable = "HealthData is not available"
        case noPermissions = "No permissions to access user health data"
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

    @objc func initializeHealthKit(_ readPermissions: [String]!, _ writePermissions: [String]!, _ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
        guard isHealthDataAvailable() else {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }

        var readType: Set<HKCharacteristicType>?
        if !readPermissions.isEmpty {
            readType = Set(arrayLiteral:
                HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                           HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                           HKObjectType.characteristicType(forIdentifier: .biologicalSex)!)
        }

        var writeType: Set<HKSampleType>?
        if !writePermissions.isEmpty {
            writeType = Set(arrayLiteral:
                HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!)
        }

        if readType == nil, writeType == nil {
            reject(Error.error.rawValue, Error.noPermissions.rawValue, nil)
            return
        }

        let healthStore = HKHealthStore()
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
