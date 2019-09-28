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
    
    @objc func initializeHealthKit(_ readPermissions: String, _ writePermissions: String, _ resolve: RCTPromiseResolveBlock, _ reject: RCTPromiseRejectBlock) {
        print("read \(readPermissions)")
        print("write \(writePermissions)")
        guard isHealthDataAvailable() else {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }
        if readPermissions == "" || writePermissions == "" {
            reject(Error.error.rawValue, Error.notAvailable.rawValue, nil)
            return
        }
        
        let readType = Set(arrayLiteral:
            HKObjectType.characteristicType(forIdentifier: .bloodType)!,
                           HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
                           HKObjectType.characteristicType(forIdentifier: .biologicalSex)!)
        let writeType = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: .bodyMass)!,
                            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!)
        
        let healthStore = HKHealthStore()
        var errorMessage: String?
        healthStore.requestAuthorization(toShare: nil, read: readType) { _, error in
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
