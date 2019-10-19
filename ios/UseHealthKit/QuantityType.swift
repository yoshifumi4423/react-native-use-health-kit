import HealthKit

/// QuantityType
class QuantityType {
    enum QuantityTypeError: Error {
        case queryExecutionFailure(String)
    }
    
    /// Keeps instance of HKHealthStore. Will be initialized in initializer.
    private let healthStore: HKHealthStore
    
    /// Initializer.
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }
    
    /// Initializer
    init() {
        self.healthStore = HKHealthStore()
    }
    
    /// Get sample data of BasalEnergyBurned.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBasalEnergyBurned(_: Date, _: Date, _ completion: @escaping (_ results: [HKSample]?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let endDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: nil,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [endDate]) { _, results, error in completion(results, error) }
        
        self.healthStore.execute(query)
    }
    
    /// Get sample data of BodyMass.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBodyMass(_: Date, _: Date, _ completion: @escaping (_ results: [HKSample]?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        let endDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: nil,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [endDate]) { _, results, error in completion(results, error) }
        
        self.healthStore.execute(query)
    }
    
    /// Set array of BodyMass value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBodyMass(_: [[String: Any]], _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 111)
        let objects = HKQuantitySample(type: type, quantity: quantity, start: Date(), end: Date())
        
        self.healthStore.save(objects) { success, error in completion(success, error) }
    }
}
