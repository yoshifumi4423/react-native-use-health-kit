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
        healthStore = HKHealthStore()
    }

    /// Get sample data of BasalEnergyBurned.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBasalEnergyBurned(_ startDate: Double,
                              _ endDate: Double,
                              _ completion: @escaping (_ results: [HKSample]?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                    end: Date(timeIntervalSince1970: endDate),
                                                    options: [.strictStartDate, .strictEndDate])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { _, results, error in completion(results, error) }

        healthStore.execute(query)
    }

    /// Get sample data of BodyMass.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getBodyMass(_ startDate: Double,
                     _ endDate: Double,
                     _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .bodyMass)!

        let predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                    end: Date(timeIntervalSince1970: endDate),
                                                    options: [.strictStartDate, .strictEndDate])

        let options: HKStatisticsOptions = [.discreteAverage]

        let from = Date(timeIntervalSince1970: startDate)
        var anchorDateComponent = Calendar.current.dateComponents([.year, .month, .day], from: from)
        anchorDateComponent.hour = 0
        let anchorDate = Calendar.current.date(from: anchorDateComponent)!

        var interval = DateComponents()
        interval.day = 1

        let query = HKStatisticsCollectionQuery(quantityType: type,
                                                quantitySamplePredicate: predicate,
                                                options: options,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)

        query.initialResultsHandler = completion

        healthStore.execute(query)
    }

    /// Set array of BodyMass value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setBodyMass(_ bodyMassData: [[String: Double]],
                     _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .bodyMass)!
        let objects = bodyMassData.map { HKQuantitySample(type: type,
                                                          quantity: HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: $0["value"]!),
                                                          start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                          end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }

    /// Get sample data of RestingHeartRate.
    ///
    /// - Parameters:
    ///   - startDate: start date to get data.
    ///   - endDate: end date to get data.
    ///   - completion: handler when the query completes.
    func getRestingHeartRate(_ startDate: Double,
                             _ endDate: Double,
                             _ completion: @escaping (_ results: [HKSample]?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date(timeIntervalSince1970: startDate),
                                                    end: Date(timeIntervalSince1970: endDate),
                                                    options: [.strictStartDate, .strictEndDate])
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        let query = HKSampleQuery(sampleType: type,
                                  predicate: predicate,
                                  limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { _, results, error in completion(results, error) }

        healthStore.execute(query)
    }

    /// Set array of RestingHeartRate value.
    ///
    /// - Parameters:
    ///   - data: This is an array of dictionary which contains startDate, endDate and value.
    ///   - completion: handler when the query completes.
    func setRestingHeartRate(_ restingHeartRateData: [[String: Double]],
                             _ completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let type = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        let unit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let objects = restingHeartRateData.map { HKQuantitySample(type: type,
                                                                  quantity: HKQuantity(unit: unit, doubleValue: $0["value"]!),
                                                                  start: Date(timeIntervalSince1970: $0["startDate"]!),
                                                                  end: Date(timeIntervalSince1970: $0["endDate"]!)) }

        healthStore.save(objects) { success, error in completion(success, error) }
    }
}
