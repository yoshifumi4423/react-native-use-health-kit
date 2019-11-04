import Foundation
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
                              _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned)!
        let options: HKStatisticsOptions = [.cumulativeSum]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

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
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

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
                             _ completion: @escaping (_ query: HKStatisticsCollectionQuery, _ result: HKStatisticsCollection?, _ error: Error?) -> Void) {
        let type = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let options: HKStatisticsOptions = [.discreteAverage]

        let query = Query.makeHKStatisticsCollectionQuery(type, options, startDate, endDate) {
            query, result, error in completion(query, result, error)
        }

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
