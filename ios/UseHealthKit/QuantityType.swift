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
    
    /// Get BasalEnergyBurned.
    ///
    /// - Parameters:
    ///   - healthStore: HealthStore.
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    /// - Returns: Return samples.
    /// - Throws: Return error if error occurs.
    func getBasalEnergyBurned(_: Date, _: Date, _ completion: @escaping (_ results: [HKSample]?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let endDate = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: nil,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [endDate]) { _, results, error in completion(results, error) }
        
        self.healthStore.execute(query)
    }
}
